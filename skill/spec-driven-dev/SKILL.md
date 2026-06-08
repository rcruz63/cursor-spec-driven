---
name: spec-driven-dev
description: >-
  Spec-driven development workflow for Cursor. Transforms specifications into
  requirements, design, and task documents under docs/specs/, with gated phases
  and incremental implementation. Use when starting a new feature, when the user
  mentions spec-driven, spec-driven-dev, nueva feature, especificaciones,
  requisitos, fase de diseño, or implementar tareas pendientes.
---

# Spec-Driven Development

Workflow de desarrollo por fases con aprobación explícita del usuario. Los artefactos viven en `docs/specs/{feature-slug}/`.

## Comandos del usuario

| Comando | Acción |
|---------|--------|
| `Inicia spec-driven: {descripción}` | Crea feature, fase **requirements** |
| `Aprobar requisitos` | Marca requirements completo → fase **design** |
| `Aprobar diseño` | Marca design completo → fase **tasks** |
| `Aprobar tareas` | Marca tasks completo → fase **implement** |
| `Implementar tarea {N}` | Implementa una tarea y marca completada |
| `Implementar pendientes` | Implementa todas las tareas sin marcar |
| `Implementar todo` | Igual que pendientes (desde cero si ninguna hecha) |

## Reglas inquebrantables

1. **Nunca avances de fase** sin que el usuario lo pida explícitamente.
2. **Nunca implementes código** antes de que exista `tasks.md` aprobado por el usuario.
3. **Siempre escribe** en `docs/specs/{feature-slug}/`.
4. **Actualiza** `workflow-state.json` al completar cada fase o tarea (ver abajo).
5. **Usa las plantillas** en [templates/](templates/) como base; no inventes estructuras distintas.
6. Al terminar una fase o tarea, **informa al usuario** qué se generó y que el hook commiteará automáticamente.

## Estructura por feature

```
docs/specs/{feature-slug}/
  workflow-state.json
  requirements.md
  design.md
  tasks.md
```

### workflow-state.json

Actualiza este fichero en cada transición:

```json
{
  "feature": "nombre-legible",
  "slug": "feature-slug",
  "phase": "requirements",
  "phase_status": "in_progress",
  "pending_commit": null,
  "last_completed_task": 0,
  "updated_at": "2026-06-08T10:00:00Z"
}
```

Valores de `phase`: `requirements` | `design` | `tasks` | `implement` | `done`

Valores de `phase_status`: `in_progress` | `complete`

Valores de `pending_commit`: `null` | `"phase"` | `"task"`

**Al completar una fase:** `phase_status: "complete"`, `pending_commit: "phase"`.

**Al completar una tarea:** marca checkbox en `tasks.md`, incrementa `last_completed_task`, `pending_commit: "task"`.

## Fases

### 1. Requirements

**Entrada:** especificaciones del usuario (texto libre, notas, enlaces).

**Salida:** `requirements.md` usando [templates/requirements.md](templates/requirements.md).

Formato Kiro / spec mode:

> You will use the spec mode to generate the Kiro requirement file. These requirements are written in the form of user stories with acceptance criteria in Easy Approach to Requirements Syntax (EARS) notation.

Debe incluir:
- Contexto y objetivo
- **User stories** (español es-ES: *Como [rol], quiero [acción], para [beneficio]*)
- **Criterios de aceptación en notación EARS** por story (no checklist genérica). Ver patrones en [reference.md](reference.md)
- Requisitos no funcionales expresados también en EARS cuando aplique
- Estándares de desarrollo (nomenclatura, idioma del código/comentarios/docs, estilo)
- Decisiones técnicas preliminares (librerías, patrones, restricciones)
- Fuera de alcance

**Al terminar:** actualiza `workflow-state.json`, para y pide revisión. No pases a design.

### 2. Design

**Entrada:** `requirements.md` aprobado.

**Salida:** `design.md` usando [templates/design.md](templates/design.md).

Debe cubrir arquitectura, componentes, interfaces, modelos de datos, flujos, manejo de errores, testing y decisiones de librerías con justificación.

**Al terminar:** actualiza state, para y pide revisión.

### 3. Tasks

**Entrada:** `design.md` aprobado.

**Salida:** `tasks.md` usando [templates/tasks.md](templates/tasks.md).

Cada tarea:
- Numerada (`### Tarea N:`)
- Checkbox `- [ ]`
- Referencia a user story / requisito
- Alcance concreto (archivos, endpoints, componentes)
- Criterio de done verificable

Orden incremental: setup → tests/config → core → integración → docs.

**Al terminar:** actualiza state (`phase: "tasks"`, `phase_status: "complete"`), para y pide revisión.

### 4. Implement

**Entrada:** `tasks.md` aprobado.

Por cada tarea:
1. Lee la tarea y el contexto (requirements + design).
2. Implementa (código, deps, tests, docs según la tarea).
3. Marca `- [x]` en `tasks.md`.
4. Actualiza `workflow-state.json`: `last_completed_task`, `pending_commit: "task"`.
5. Informa qué se hizo; continúa solo si el usuario pidió múltiples tareas.

**Al completar todas las tareas:** `phase: "done"`, `pending_commit: "phase"`.

## Detección de feature activa

Si hay varias features en `docs/specs/`:
1. Usa la que el usuario nombre explícitamente.
2. Si no, la más reciente según `updated_at` en su `workflow-state.json`.
3. Si es ambiguo, pregunta.

## Slug de feature

Kebab-case, sin acentos, máx. 40 chars. Ejemplo: `auth-oauth-module`.

## Idioma

- Documentos de spec (`requirements.md`, `design.md`, `tasks.md`): **español de España (es-ES)** salvo que el usuario indique otro idioma.
- User stories y criterios EARS: en español, usando las claves EARS en mayúsculas (`CUANDO`, `EL SISTEMA DEBE`, `SI … ENTONCES`, etc.).
- Código y comentarios: seguir lo definido en *Estándares de desarrollo* del `requirements.md` del proyecto/feature.

## Referencia

Plantillas detalladas y ejemplos: [reference.md](reference.md)
