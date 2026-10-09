# Documentación REAKT

Esta carpeta describe la arquitectura acordada y distingue decisiones de implementación y pruebas realizadas.

| Archivo | Contenido |
|---|---|
| `requirements.md` | Requisitos escolares y verificaciones pendientes |
| `architecture.md` | Arquitectura del sistema y flujo de datos |
| `hardware.md` | ESP32, pulsador, WS2812B y alimentación |
| `firmware.md` | Comportamiento de firmware y antirrebote |
| `packet-protocol.md` | Protocolo común; campos aún no cerrados |
| `app.md` | Flutter (sin cambio de tecnología) |
| `backend.md` | Supabase/PostgreSQL (sin cambio de tecnología) |
| `testing.md` | Ensayos y criterios de aceptación |
| `roadmap.md` | Etapas y pendientes |
| `decisions.md` | Registro de decisiones arquitectónicas |
| `glossary.md` | Términos |
| `cambios-2026-10-08.md` | Informe del cambio de nodos y sensores |
| `development.md` | Flujo de trabajo |

## Estado
`TBD` = no decidido; `TODO` = decidido, no implementado; `IN PROGRESS` = en curso; `DONE` = implementado y validado; `BLOCKED` = bloqueado.

Las pruebas antiguas con ESP32-C3 y piezoeléctricos se conservan por trazabilidad. El diseño vigente utiliza cinco nodos ESP32 con pulsador mecánico.

Código = fuente de verdad de lo implementado. Documentación = fuente de verdad de decisiones y requisitos. Si discrepan, revisar antes de modificar.

## Nuevos documentos de ingeniería
- `pcb/README.md` — índice maestro de PCB y criterios de liberación.
- `pcb/componentes-dimensiones.md` — dimensiones aproximadas y fuentes.
- `pcb/arquitectura-electrica.md` — esquemas de bloques.
- `pcb/alimentacion-y-autonomia.md` — carga, protección y corriente.
- `pcb/pinout-y-conectores.md` — GPIO y conectores.
- `pcb/layout-kicad.md` — fabricación y reglas KiCad.
- `pcb/gateway-pcb.md` — gateway.
- `pcb/bom-preliminar.md` — materiales.
- `pcb/verificacion-pcb.md` — plan de pruebas.
- `pcb/plan-codex.md` — instrucciones para Codex local.
- `diseno-mecanico.md` — carcasa y mecanismo (especificación preliminar).
