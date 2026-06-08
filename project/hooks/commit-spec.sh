#!/usr/bin/env bash
# Commits spec-driven artifacts after a phase or task completes.
# Triggered by the Cursor "stop" hook when workflow-state.json has pending_commit set.
set -euo pipefail

project_dir="${CURSOR_PROJECT_DIR:-$(pwd)}"
cd "$project_dir"

state_file=""
latest_mtime=0
if [[ -d docs/specs ]]; then
  while IFS= read -r -d '' f; do
    mtime=$(stat -f '%m' "$f" 2>/dev/null || stat -c '%Y' "$f" 2>/dev/null || echo 0)
    if [[ "$mtime" -gt "$latest_mtime" ]]; then
      latest_mtime=$mtime
      state_file=$f
    fi
  done < <(find docs/specs -name 'workflow-state.json' -print0 2>/dev/null)
fi

if [[ -z "$state_file" || ! -f "$state_file" ]]; then
  exit 0
fi

if ! command -v jq &>/dev/null; then
  echo '{"agent_message":"spec-driven: jq no instalado; instala jq para auto-commit"}' >&2
  exit 0
fi

pending=$(jq -r '.pending_commit // empty' "$state_file")
if [[ -z "$pending" || "$pending" == "null" ]]; then
  exit 0
fi

if ! git rev-parse --git-dir &>/dev/null; then
  exit 0
fi

slug=$(jq -r '.slug // "unknown"' "$state_file")
phase=$(jq -r '.phase // "unknown"' "$state_file")
last_task=$(jq -r '.last_completed_task // 0' "$state_file")
spec_dir=$(dirname "$state_file")

commit_msg=""
if [[ "$pending" == "phase" ]]; then
  case "$phase" in
    requirements) commit_msg="docs(spec): requisitos de ${slug}" ;;
    design)       commit_msg="docs(spec): diseño de ${slug}" ;;
    tasks)        commit_msg="docs(spec): tareas de ${slug}" ;;
    done)         commit_msg="feat(${slug}): implementación completa" ;;
    *)            commit_msg="docs(spec): fase ${phase} de ${slug}" ;;
  esac
elif [[ "$pending" == "task" ]]; then
  task_title=""
  tasks_file="${spec_dir}/tasks.md"
  if [[ -f "$tasks_file" ]]; then
    task_title=$(grep -m1 "^### Tarea ${last_task}:" "$tasks_file" 2>/dev/null | sed 's/^### Tarea [0-9]*: //' || true)
  fi
  if [[ -n "$task_title" ]]; then
    commit_msg="feat(${slug}): tarea ${last_task} - ${task_title}"
  else
    commit_msg="feat(${slug}): tarea ${last_task}"
  fi
else
  exit 0
fi

# Clear pending_commit before staging so it is included in the same commit
tmp=$(mktemp)
jq '.pending_commit = null | .updated_at = (now | strftime("%Y-%m-%dT%H:%M:%SZ"))' "$state_file" > "$tmp"
mv "$tmp" "$state_file"

git add "$spec_dir"
git add docs/specs 2>/dev/null || true

if [[ "$pending" == "task" || "$phase" == "done" || "$phase" == "implement" ]]; then
  git add -u 2>/dev/null || true
fi

if git diff --cached --quiet; then
  exit 0
fi

git commit -m "$commit_msg"
echo "{\"agent_message\":\"Commit creado: ${commit_msg}\"}"
exit 0
