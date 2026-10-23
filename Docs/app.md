# REAKT Flutter Application

## Adaptación al demo — 2026-10-23

`app/` usa la base funcional remota `cotyolmedo/REAKT`, main `3f34294`, en lugar del shell local: Android, GatewayLink, TrainingSnapshot, LocalStore y CloudSync. Se conservan los cambios ajenos del firmware local.

La presentación sigue el inicio y menú públicos del demo Impacto/Jotform: Inicio, Entrenar, Historial, Progreso y Perfil; superficies negras, fondo bordó y acciones rojas. Entrenamiento del demo exige autenticación; su contenido interno no pudo inspeccionarse. El flujo interno se implementa según REAKT.

Entrenar configura rondas/tiempo y emite start/manual/stop. Historial conserva capturas, detalle y exportación; Progreso usa sesiones completadas; Perfil conserva Auth/outbox. Errores y desconexión visibles. `presentation/` separa componentes/adaptación de registros de los servicios.

El MVP remoto admite dos nodos; arquitectura final prevista: cinco. No interpretar peers configurados como dispositivos presentes. Antes de probar hardware comprobar compatibilidad con el [contrato MVP](https://github.com/cotyolmedo/REAKT/blob/3f34294/Docs/packet-protocol.md).

SDK verificado Flutter 3.47.4/Dart 3.13.3. APK generado y publicado mediante GitHub Actions; configuración pública Supabase y permisos remotos verificados. Pruebas físicas de teléfono, radio y sincronización desde Android pendientes. Uso en `app/README.md`, evidencia en `testing.md` y `android-release-2026-10-23.md`.

## Purpose

The Flutter application is the user-facing control and visualization layer.

## Responsibilities

- configure training sessions
- select mode
- configure nodes/session parameters
- communicate with gateway
- display live state
- display results
- access historical data where required
- interact with Supabase where appropriate

## Suggested logical layers

```text
UI / Presentation
        ↓
Application / State
        ↓
Domain Models
        ↓
Services
   ├── Gateway communication
   └── Supabase
```

This is a logical separation, not a requirement to introduce a large framework.

## Rules

- Keep UI widgets focused on presentation.
- Keep communication logic outside widgets.
- Keep database logic outside widgets.
- Use explicit models for protocol data.
- Validate external data before using it.
- Handle disconnected/error states visibly.
- Avoid unnecessary state-management dependencies.

## Hardware communication

The application must communicate according to the finalized gateway interface.

Do not allow Flutter code to assume ESP-NOW details directly. ESP-NOW is a gateway/node concern unless an explicit architecture decision says otherwise.

## Backend communication

Supabase integration should use a dedicated service/repository layer.

Do not embed privileged credentials in the application.

## UI

The UI must support the project requirements and the actual training workflow.

Wireframes/mockups should be kept separately from source code when appropriate.
