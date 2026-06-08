# Requisitos: {nombre-feature}

> **Estado:** Borrador | En revisión | Aprobado
> **Slug:** `{feature-slug}`
> **Fecha:** {YYYY-MM-DD}

<!--
Definición del formato (Kiro / spec mode):

You will use the spec mode to generate the Kiro requirement file. These
requirements are written in the form of user stories with acceptance criteria
in Easy Approach to Requirements Syntax (EARS) notation.
-->

## 1. Contexto y objetivo

{Por qué existe esta feature, problema que resuelve, usuarios afectados.}

## 2. User stories

Cada historia sigue el formato de user story. Los **criterios de aceptación**
deben escribirse en **notación EARS** (Easy Approach to Requirements Syntax),
no como checklist genérica.

### US-1: {título corto}

**Como** {rol}, **quiero** {acción}, **para** {beneficio}.

**Prioridad:** Must | Should | Could

**Criterios de aceptación (EARS):**

- [ ] **Ubicuo:** EL SISTEMA DEBE {respuesta siempre aplicable}.
- [ ] **Evento:** CUANDO {disparador}, EL SISTEMA DEBE {respuesta}.
- [ ] **Estado:** MIENTRAS {estado}, EL SISTEMA DEBE {respuesta}.
- [ ] **No deseado:** SI {condición indeseada}, ENTONCES EL SISTEMA DEBE {respuesta}.
- [ ] **Opcional:** DONDE {característica o contexto}, EL SISTEMA DEBE {respuesta}.

---

### US-2: {título corto}

**Como** {rol}, **quiero** {acción}, **para** {beneficio}.

**Prioridad:** Must | Should | Could

**Criterios de aceptación (EARS):**

- [ ] CUANDO {disparador}, EL SISTEMA DEBE {respuesta}.

## 3. Requisitos no funcionales

Los RNF también deben expresarse en EARS cuando describen comportamiento del sistema:

| ID | Categoría | Requisito (EARS) |
|----|-----------|------------------|
| RNF-1 | Rendimiento | CUANDO {condición de carga}, EL SISTEMA DEBE {métrica, ej. responder en p95 < 200 ms}. |
| RNF-2 | Seguridad | EL SISTEMA DEBE {requisito de seguridad siempre activo}. |
| RNF-3 | Accesibilidad | DONDE {interfaz de usuario}, EL SISTEMA DEBE cumplir {WCAG 2.1 AA}. |
| RNF-4 | i18n / l10n | EL SISTEMA DEBE {idiomas, locale es-ES, etc.}. |
| RNF-5 | Observabilidad | CUANDO {evento relevante}, EL SISTEMA DEBE {registrar métrica o log estructurado}. |

## 4. Estándares de desarrollo

Definidos para esta feature (heredar del proyecto si ya existen convenciones):

| Ámbito | Decisión |
|--------|----------|
| Idioma del código | {ej. inglés para identificadores} |
| Idioma de comentarios | {ej. español (es-ES)} |
| Idioma de documentación | {ej. español (es-ES)} |
| Nomenclatura | {ej. camelCase vars, PascalCase componentes, kebab-case archivos} |
| Commits | {ej. Conventional Commits} |
| Tests | {ej. obligatorios para lógica de negocio, framework X} |
| Lint / format | {ej. ESLint + Prettier, reglas del repo} |

## 5. Decisiones técnicas y dependencias

| Decisión | Opción elegida | Alternativas descartadas | Motivo |
|----------|----------------|--------------------------|--------|
| {ej. HTTP client} | {fetch nativo} | {axios} | {menos deps, suficiente} |
| {ej. validación} | {zod} | {yup} | {ya usado en el proyecto} |

**Restricciones:**

- {ej. no añadir dependencias sin aprobación}
- {ej. reutilizar módulo auth existente}

## 6. Fuera de alcance

- {qué NO incluye esta iteración}

## 7. Preguntas abiertas

- [ ] {pregunta pendiente de resolver con el usuario}

## 8. Aprobación

- [ ] Revisado por usuario
- [ ] Listo para fase de diseño
