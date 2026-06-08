#!/usr/bin/env bash
# Instala el skill spec-driven-dev en ~/.cursor/skills/ (uso personal, todos los proyectos).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="${REPO_ROOT}/skill/spec-driven-dev"
SKILL_DEST="${HOME}/.cursor/skills/spec-driven-dev"

if [[ ! -d "$SKILL_SRC" ]]; then
  echo "Error: no se encuentra ${SKILL_SRC}" >&2
  exit 1
fi

mkdir -p "${HOME}/.cursor/skills"

if [[ -L "$SKILL_DEST" ]]; then
  rm "$SKILL_DEST"
elif [[ -d "$SKILL_DEST" ]]; then
  echo "Ya existe ${SKILL_DEST}"
  read -r -p "¿Sobrescribir con symlink al repo? [y/N] " answer
  if [[ "${answer,,}" != "y" ]]; then
    echo "Cancelado."
    exit 0
  fi
  rm -rf "$SKILL_DEST"
fi

ln -s "$SKILL_SRC" "$SKILL_DEST"
echo "✓ Skill instalado: ${SKILL_DEST} -> ${SKILL_SRC}"
echo ""
echo "En cada máquina:"
echo "  git clone <tu-repo> ~/Developer/Cloud/cursor-spec-driven"
echo "  ./scripts/install-personal.sh"
