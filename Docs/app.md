# REAKT Flutter Application

## Estado actual — 23/10/2026

Flutter 0.3.0 adapta el demo Impacto con Inicio, Entrenar, Historial, Progreso y
Perfil. Conserva GatewayLink, TrainingSnapshot, LocalStore y CloudSync; configura
rondas/tiempo, manda start/manual/stop y calcula progreso desde sesiones guardadas.
No inventa métricas ni presencia de nodos. MVP máximo dos nodos; ampliación a cinco
pendiente. El contrato terminal no distingue manual/reflejos: historial usa Sesión.

Flutter 3.47.4/Dart 3.13.3, 21 tests y APK Android 7+ publicado con configuración
pública Supabase. Conexión física y ensayo básico LED/pulsador en Android
comprobados; sincronización desde teléfono confirmada y registros remotos cotejados.
Ver [guía actual](PROBAR-HOY.md), [app/README](../app/README.md) y
[evidencia de publicación](android-release-2026-10-23.md).

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

## Implementación MVP — 2026-10-22

`app/lib/services/` concreta contrato de snapshots, GatewayLink, LocalStore y
CloudSync. Gateway coordina sesiones; app presenta métricas reales recibidas,
conserva SQLite y sincroniza estados terminales por Auth. Android scaffold incluido.
El análisis/build y tests Dart no se ejecutaron por SDK bloqueado. Ver instalación,
bitácora y protocolo antes de atribuir funcionamiento a esta implementación.

Continuación de la misma entrega: SDK instalado, analyze y17tests aprobados.
Incluye exportación JSON de historial a portapapeles, sin importación automática.
Consultar ESTADO-FINAL-MVP.md para el APK y las verificaciones que siguen pendientes.
