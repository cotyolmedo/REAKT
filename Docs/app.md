# REAKT Flutter Application

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
