# REAKT Roadmap

## APK conectado a configuración del proyecto — 2026-10-23

Compilación/publicación autorizada en GitHub Actions desde rama aislada. Configuración pública Supabase incluida al compilar, servicio/Auth/metadata/RLS verificados. Las placas siguen sin configurar según confirmación del usuario: conexión física al gateway y prueba Android final pendientes. Detalle y evidencia en `testing.md`.

APK 0.3.0 de demostración publicado con firma y checksum: https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.0-demo.4.1. Build/analyze/21 pruebas remotas aprobados. La generación del APK ya no está pendiente; continúan pendientes la configuración de placas y la integración física.

## Avance de app — 2026-10-23

- Implementada adaptación del MVP remoto al demo: Inicio, Entrenar, Historial, Progreso y Perfil.
- Conservados WebSocket, validación, SQLite/outbox; agregados configuración, detalle y progreso calculado.
- La matriz histórica siguiente no acredita integración física. El contrato de la app MVP admite dos nodos; arquitectura final prevista: cinco.
- Pendientes: pruebas físicas de teléfono/gateway/nodos/LED y sincronización desde Android. APK y verificaciones remotas posteriores completados según la entrada superior. Evidencia ejecutada en `testing.md`.

## Current phase

Initial/incremental development.

The project should be advanced in demonstrable stages.

## Phase 0 - Repository and documentation

- [x] GitHub repository exists
- [ ] Codex repository instructions installed
- [ ] architecture documented
- [ ] hardware inventory documented
- [ ] protocol specification finalized
- [ ] development workflow documented

## Phase 1 - Gateway and nodes

- [ ] ESP32 gateway base firmware
- [ ] ESP32-C3 node base firmware
- [ ] ESP-NOW connection test
- [ ] bidirectional communication
- [ ] multiple-node communication
- [ ] error/timeout handling

## Phase 2 - Global packet protocol

- [ ] finalize packet types
- [ ] finalize node ID
- [ ] finalize mode representation
- [ ] finalize timing representation
- [ ] finalize payload
- [ ] compatibility tests

## Phase 3 - Flutter

- [x] project structure
- [x] initial UI
- [ ] gateway connection
- [ ] command transmission
- [ ] event reception
- [ ] result display

## Phase 4 - Supabase

- [ ] schema design
- [ ] migrations
- [ ] authentication if required
- [ ] result persistence
- [ ] historical data
- [ ] security policies

## Phase 5 - First complete training mode

Implement one complete mode end-to-end before implementing all modes.

Candidate modes:

- memoria
- agilidad
- reflejos
- velocidad
- resistencia
- precisión
- coordinación

The selected first mode must be explicitly decided.

## Phase 6 - Remaining modes

- [ ] implement remaining modes
- [ ] reuse global packet infrastructure
- [ ] validate node behavior
- [ ] validate metrics

## Phase 7 - Final integration

- [ ] hardware integration
- [ ] application integration
- [ ] database production setup
- [ ] reliability testing
- [ ] enclosure
- [ ] PCB
- [ ] documentation

### PCB V0.1 note (2026-10-09)

- [x] provisional editable carrier layout created under `hardware/pcb/reakt-nodo/`
- [ ] identify and measure real ESP32, TP4056, battery, connectors and LED
- [ ] schematic, ERC, final footprints, routing, DRC and 3D verification

## Phase 8 - Exhibition

- [ ] complete live demo
- [ ] backup source code
- [ ] field documentation
- [ ] final schematic
- [ ] process evidence
- [ ] user manual
- [ ] technical documentation
