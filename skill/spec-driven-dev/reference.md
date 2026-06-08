# Referencia: Spec-Driven Development

## Formato de requisitos (Kiro / EARS)

> You will use the spec mode to generate the Kiro requirement file. These requirements are written in the form of user stories with acceptance criteria in Easy Approach to Requirements Syntax (EARS) notation.

Las user stories capturan **valor para el usuario**. Los criterios de aceptación deben ser **requisitos formales verificables** en notación EARS, no frases vagas ni checklist sin estructura.

Además, el documento incluye NFR, estándares de desarrollo y decisiones técnicas (secciones 3–5 de la plantilla).

## Patrones EARS

| Patrón | Plantilla (es-ES) | Cuándo usarlo |
|--------|-------------------|---------------|
| **Ubicuo** | EL SISTEMA DEBE {respuesta}. | Siempre activo, sin disparador |
| **Evento** | CUANDO {disparador}, EL SISTEMA DEBE {respuesta}. | Acción o evento concreto |
| **Estado** | MIENTRAS {estado}, EL SISTEMA DEBE {respuesta}. | Condición que persiste en el tiempo |
| **No deseado** | SI {condición}, ENTONCES EL SISTEMA DEBE {respuesta}. | Errores, excepciones, casos límite |
| **Opcional** | DONDE {característica}, EL SISTEMA DEBE {respuesta}. | Variante o contexto específico |

Equivalentes en inglés (referencia): `WHEN`, `WHILE`, `IF … THEN`, `WHERE`, `THE SYSTEM SHALL`.

## Ejemplo completo

```markdown
### US-1: Inicio de sesión con Google

**Como** usuario registrado, **quiero** iniciar sesión con mi cuenta de Google,
**para** no tener que recordar otra contraseña.

**Prioridad:** Must

**Criterios de aceptación (EARS):**

- [ ] DONDE la pantalla de inicio de sesión, EL SISTEMA DEBE mostrar el botón «Continuar con Google».
- [ ] CUANDO el usuario pulsa «Continuar con Google», EL SISTEMA DEBE redirigir al flujo OAuth de Google.
- [ ] CUANDO Google devuelve un token válido, EL SISTEMA DEBE crear la sesión y redirigir a `/dashboard`.
- [ ] SI el email ya existe asociado a otro proveedor, ENTONCES EL SISTEMA DEBE mostrar un mensaje de error comprensible y no crear sesión.
- [ ] MIENTRAS la sesión esté activa, EL SISTEMA DEBE respetar la política de expiración definida en RNF-2.
```

### Mal vs bien

| ❌ Mal (checklist vaga) | ✅ Bien (EARS) |
|------------------------|----------------|
| Botón de Google visible | DONDE la pantalla de login, EL SISTEMA DEBE mostrar el botón «Continuar con Google». |
| Maneja errores bien | SI la autenticación falla, ENTONCES EL SISTEMA DEBE mostrar un mensaje de error y permanecer en `/login`. |
| Respuesta rápida | CUANDO la API reciba una petición autenticada, EL SISTEMA DEBE responder en menos de 200 ms (p95). |

## Transiciones de fase (workflow-state.json)

### Al iniciar feature

```json
{
  "feature": "Inicio de sesión con Google",
  "slug": "login-google",
  "phase": "requirements",
  "phase_status": "in_progress",
  "pending_commit": null,
  "last_completed_task": 0,
  "updated_at": "2026-06-08T10:00:00Z"
}
```

### Al completar requirements (esperando aprobación del usuario para design)

```json
{
  "phase": "requirements",
  "phase_status": "complete",
  "pending_commit": "phase"
}
```

### Tras aprobación, iniciando design

```json
{
  "phase": "design",
  "phase_status": "in_progress",
  "pending_commit": null
}
```

### Tras completar tarea 2

```json
{
  "phase": "implement",
  "phase_status": "in_progress",
  "last_completed_task": 2,
  "pending_commit": "task"
}
```

## Mensajes de commit (generados por hooks)

| Evento | Formato |
|--------|---------|
| Fase requirements | `docs(spec): requisitos de {slug}` |
| Fase design | `docs(spec): diseño de {slug}` |
| Fase tasks | `docs(spec): tareas de {slug}` |
| Fase implement (todas done) | `feat({slug}): implementación completa` |
| Tarea N | `feat({slug}): tarea {N} - {título corto}` |
