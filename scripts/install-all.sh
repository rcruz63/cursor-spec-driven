#!/usr/bin/env bash
# Instala skill personal + configura el proyecto actual (o ruta indicada).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:-.}"

"${REPO_ROOT}/scripts/install-personal.sh"
"${REPO_ROOT}/scripts/install-project.sh" "$TARGET"

echo ""
echo "✓ Instalación completa."
