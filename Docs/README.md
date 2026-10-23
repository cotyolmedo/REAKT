# Documentación REAKT

Esta carpeta distingue requisitos, decisiones, implementación y evidencia de
pruebas del proyecto.

## Mapa documental

| Archivo | Contenido |
|---|---|
| `requirements.md` | Requisitos escolares de referencia |
| `requirements-addendum.md` | Verificación pendiente sobre el pulsador como sensor |
| `architecture.md` | Arquitectura y responsabilidades |
| `hardware.md` | Inventario, interfaces físicas y pendientes |
| `firmware.md` | Convenciones y comportamiento embebido |
| `packet-protocol.md` | Protocolo común todavía no finalizado |
| `app.md` | Arquitectura prevista de Flutter |
| `backend.md` | Arquitectura prevista de Supabase/PostgreSQL |
| `development.md` | Flujo de desarrollo |
| `testing.md` | Estrategia, evidencia y verificaciones realizadas |
| `roadmap.md` | Fases y estado real |
| `decisions.md` | Decisiones arquitectónicas (ADR) |
| `diseno-mecanico.md` | Especificación conceptual de carcasa |
| `pcb/README.md` | Índice de ingeniería PCB y puertas de decisión |
| `cambios-2026-10-08.md` | Trazabilidad del cambio de nodos y entrada |
| `glossary.md` | Términos del proyecto |

## Fuentes de verdad

- El código describe lo implementado.
- Esta documentación describe requisitos y decisiones acordadas.
- `Docs/testing.md` describe únicamente verificaciones con evidencia.
- Los sketches en `Tests/` pueden ser históricos y no representan el diseño
  vigente.

Si código y documentación discrepan, determinar primero cuál refleja la última
decisión intencional, actualizar la fuente obsoleta y registrar un ADR cuando
exista un cambio de arquitectura.

## Estados

- `TBD`: por definir.
- `TODO`: decidido, no implementado.
- `IN PROGRESS`: en desarrollo.
- `DONE`: implementado y verificado.
- `BLOCKED`: depende de una decisión, pieza o validación externa.

No marcar elementos como `DONE` sin evidencia verificable.
