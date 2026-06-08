#!/usr/bin/env bash
# Instala rules, hooks y docs/specs/ en un proyecto existente.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:-.}"

if [[ ! -d "$TARGET" ]]; then
  echo "Error: directorio no existe: ${TARGET}" >&2
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"
echo "Instalando spec-driven en: ${TARGET}"

# docs/specs/
mkdir -p "${TARGET}/docs/specs"
if [[ ! -f "${TARGET}/docs/specs/.gitkeep" ]]; then
  cp "${REPO_ROOT}/project/docs/specs/.gitkeep" "${TARGET}/docs/specs/.gitkeep" 2>/dev/null || touch "${TARGET}/docs/specs/.gitkeep"
fi

# rules
mkdir -p "${TARGET}/.cursor/rules"
cp "${REPO_ROOT}/project/rules/spec-driven.mdc" "${TARGET}/.cursor/rules/spec-driven.mdc"

# hooks
mkdir -p "${TARGET}/.cursor/hooks"
cp "${REPO_ROOT}/project/hooks/commit-spec.sh" "${TARGET}/.cursor/hooks/commit-spec.sh"
chmod +x "${TARGET}/.cursor/hooks/commit-spec.sh"

HOOKS_FILE="${TARGET}/.cursor/hooks.json"
if [[ -f "$HOOKS_FILE" ]]; then
  if command -v jq &>/dev/null; then
    # Merge stop hook if jq available
    tmp=$(mktemp)
    jq --slurpfile new "${REPO_ROOT}/project/hooks/hooks.json" '
      .version = 1 |
      .hooks.stop = (
        ((.hooks.stop // []) + ($new[0].hooks.stop // [])) |
        unique_by(.command)
      )
    ' "$HOOKS_FILE" > "$tmp" && mv "$tmp" "$HOOKS_FILE"
    echo "✓ hooks.json fusionado"
  else
    echo "⚠ hooks.json ya existe; fusiona manualmente el hook stop de project/hooks/hooks.json"
  fi
else
  cp "${REPO_ROOT}/project/hooks/hooks.json" "$HOOKS_FILE"
  # Fix path for project root
  sed -i '' 's|project/hooks/|.cursor/hooks/|g' "$HOOKS_FILE" 2>/dev/null || \
    sed -i 's|project/hooks/|.cursor/hooks/|g' "$HOOKS_FILE"
  echo "✓ hooks.json creado"
fi

echo ""
echo "✓ Proyecto configurado."
echo ""
echo "Requisito: jq instalado (brew install jq) para auto-commit."
echo "Skill personal: ejecuta ./scripts/install-personal.sh si aún no lo hiciste."
echo ""
echo "Uso: abre el proyecto en Cursor y di:"
echo '  Inicia spec-driven: {descripción de la feature}'
