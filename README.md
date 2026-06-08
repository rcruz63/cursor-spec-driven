# cursor-spec-driven

Desarrollo guiado por especificaciones para **Cursor**: fases con aprobación, documentos en el repo, implementación tarea a tarea y commits automáticos.

## Qué incluye

| Componente | Ubicación en repo | Se instala en |
| ------------ | ---------------- | -------------- |
| **Skill** `spec-driven-dev` | `skill/spec-driven-dev/` | `~/.cursor/skills/` (personal, symlink) |
| **Rule** de proyecto | `project/rules/spec-driven.mdc` | `.cursor/rules/` del proyecto |
| **Hook** auto-commit | `project/hooks/commit-spec.sh` | `.cursor/hooks/` del proyecto |
| **Plantillas** | `skill/spec-driven-dev/templates/` | (via skill, no se copian) |
| **Specs** | — | `docs/specs/{feature}/` en cada proyecto |

## Flujo de trabajo

```text
Especificaciones del usuario
        ↓
  requirements.md   ← user stories, NFR, estándares, decisiones técnicas
        ↓ (Aprobar requisitos)
    design.md       ← arquitectura, componentes, testing
        ↓ (Aprobar diseño)
     tasks.md       ← tareas numeradas con checkboxes
        ↓ (Aprobar tareas)
  Implementación    ← tarea a tarea o todas las pendientes
        ↓
      done
```

Cada fase y cada tarea completada dispara un commit automático (hook `stop`).

## Requisitos

- [Cursor](https://cursor.com) con Hooks habilitados
- [jq](https://jqlang.github.io/jq/) (`brew install jq`) para el auto-commit
- Git en el proyecto destino

## Instalación

### 1. Clonar en cada máquina (Mac trabajo, Mac personal, etc.)

```bash
git clone https://github.com/rcruz63/cursor-spec-driven.git ~/Developer/Cloud/cursor-spec-driven
cd ~/Developer/Cloud/cursor-spec-driven
chmod +x scripts/*.sh project/hooks/*.sh
```

### 2. Skill personal (una vez por máquina)

Instala el skill en `~/.cursor/skills/` como symlink al repo (actualizaciones con `git pull`):

```bash
./scripts/install-personal.sh
```

### 3. Por cada proyecto donde quieras usar el flujo

Desde el repo clonado:

```bash
./scripts/install-project.sh /ruta/a/tu-proyecto
```

O todo en uno (skill + proyecto):

```bash
./scripts/install-all.sh /ruta/a/tu-proyecto
```

Esto crea:

```text
tu-proyecto/
  docs/specs/              # aquí viven las specs
  .cursor/
    rules/spec-driven.mdc
    hooks/commit-spec.sh
    hooks.json
```

### 4. Reiniciar Cursor

Tras instalar hooks, reinicia Cursor o guarda `hooks.json` para que cargue.

## Uso en Cursor

Abre el proyecto y escribe en el chat:

```text
Inicia spec-driven: módulo de autenticación OAuth con Google
```

Revisa y edita `docs/specs/{slug}/requirements.md`, luego:

```text
Aprobar requisitos
```

Repite para diseño y tareas:

```text
Aprobar diseño
Aprobar tareas
Implementar pendientes
```

O granular:

```text
Implementar tarea 1
Implementar tarea 3
```

## Documento de requisitos (Kiro + EARS)

Formato alineado con Kiro spec mode:

> You will use the spec mode to generate the Kiro requirement file. These requirements are written in the form of user stories with acceptance criteria in Easy Approach to Requirements Syntax (EARS) notation.

| Sección | Para qué sirve |
| -------- | -------------- |
| User stories (es-ES) | Valor de usuario: *Como… quiero… para…* |
| Criterios de aceptación (EARS) | Requisitos verificables: `CUANDO … EL SISTEMA DEBE …` |
| Requisitos no funcionales | También en EARS cuando describen comportamiento |
| Estándares de desarrollo | Nomenclatura, idioma código/comentarios/docs |
| Decisiones técnicas | Librerías, patrones, restricciones |
| Fuera de alcance | Evitar scope creep |

Patrones EARS y ejemplos: `skill/spec-driven-dev/reference.md`

## Auto-commit

El hook lee `docs/specs/{feature}/workflow-state.json`. Cuando el agente marca `pending_commit`:

| Valor | Cuándo | Mensaje de commit |
| ------- | -------- | ------------------- |
| `"phase"` | Fin de requirements, design, tasks o implement completo | `docs(spec): …` o `feat(slug): implementación completa` |
| `"task"` | Tras implementar una tarea | `feat(slug): tarea N - título` |

El agente debe actualizar `workflow-state.json` al terminar cada fase/tarea (definido en el skill).

## Actualizar en todas las máquinas

```bash
cd ~/Developer/Cloud/cursor-spec-driven
git pull
```

El skill es symlink → se actualiza solo. En cada proyecto, vuelve a ejecutar si cambiaron hooks o rules:

```bash
./scripts/install-project.sh /ruta/a/tu-proyecto
```

## Estructura del repo

```text
cursor-spec-driven/
├── README.md
├── skill/spec-driven-dev/     # Skill personal (symlink)
│   ├── SKILL.md
│   ├── reference.md
│   └── templates/
├── project/                   # Se copia a cada repo
│   ├── rules/
│   ├── hooks/
│   └── docs/specs/
└── scripts/
    ├── install-personal.sh
    ├── install-project.sh
    └── install-all.sh
```

## Personalización

- **Plantillas:** edita `skill/spec-driven-dev/templates/`
- **Idioma de specs:** por defecto español; indícalo al iniciar una feature
- **Commits:** ajusta mensajes en `project/hooks/commit-spec.sh`
- **Reglas extra:** añade rules en `.cursor/rules/` del proyecto

## Troubleshooting

| Problema | Solución |
| -------- | -------- |
| No commitea | ¿`jq` instalado? ¿`workflow-state.json` tiene `pending_commit`? Revisa canal **Hooks** en Cursor |
| Skill no aparece | Ejecuta `install-personal.sh`; reinicia Cursor |
| Hook no carga | Ruta en `hooks.json` debe ser `.cursor/hooks/commit-spec.sh`; script ejecutable (`chmod +x`) |
| Conflicto hooks.json | Fusiona manualmente la entrada `stop` de `project/hooks/hooks.json` |

## Licencia

MIT
