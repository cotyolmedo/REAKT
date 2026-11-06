# REAKT ExecPlans

## Purpose

An ExecPlan is a living implementation document for complex REAKT work.

Use one when a task:

- changes multiple subsystems
- changes architecture
- introduces a substantial feature
- changes the communication protocol
- changes the database schema
- requires significant refactoring
- is expected to take multiple implementation steps

Do not create an ExecPlan for a trivial typo, one-line fix or isolated configuration change.

## Required structure

Every ExecPlan should contain:

### 1. Objective

What must exist when the work is complete.

### 2. Current state

What exists now and which files/components are relevant.

### 3. Requirements

Explicit functional and technical requirements.

### 4. Constraints

Hardware, software, compatibility, school requirements and project rules.

### 5. Design

Describe the proposed architecture and data/control flow.

### 6. Implementation steps

Numbered, concrete steps that can be executed and validated.

### 7. Validation

Tests, builds, simulations or inspections required to verify the result.

### 8. Documentation changes

Which documentation files must be updated.

### 9. Risks and rollback

Potential failure modes and how to revert safely.

### 10. Status

Mark each step as:

- `[ ]` pending
- `[~]` in progress
- `[x]` completed
- `[!]` blocked

## Living-document rule

Update the plan as implementation progresses.

If the implementation discovers that the original plan is wrong, update the plan rather than silently diverging from it.

An ExecPlan is not permission to invent requirements. It is a record of an agreed technical approach.


## Limpieza del repositorio — 2026-11-06

### Objetivo y estado

Reducir archivos redundantes y facilitar la entrada al proyecto, conservando
código funcional y evidencia histórica. Base: c41c62d1c95877bccd2171884142ef7f0d4bb628.

### Requisitos y límites

Sin cambios de arquitectura, protocolo o esquema SQL. Mantener ensayos anteriores
y configuración local fuera de Git. Releases v0.3.1 es la distribución vigente.

### Diseño e implementación

- [x] Consolidar seis guías de entrega y seis planes antiguos.
- [x] Mover los dos ensayos a tests/historical.
- [x] Renombrar web vigente a index.html y conservar alias de publicación.
- [x] Retirar prototipo web anterior y ZIP antiguos; conservar referencias Git.
- [x] Actualizar índices y referencias relativas.

### Validación y documentación

Revisar enlaces internos, rutas sin colisión de mayúsculas, sintaxis JavaScript,
manifest y workflow Pages. Comparar fuentes operativas y ensayos con los blobs
originales. Registrar resultados en testing.md; no afirmar nuevas pruebas físicas.

### Riesgos y reversión

Los enlaces directos a archivos retirados de main deben usar el permalink de la
base histórica. El sitio conserva el alias anterior. Revertir el commit de limpieza
restaura la estructura previa sin reescribir el historial.
