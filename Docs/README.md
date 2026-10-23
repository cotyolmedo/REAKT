# Documentación REAKT

Esta carpeta distingue requisitos, decisiones, implementación y evidencia de
pruebas del proyecto.

## Empezar por el estado actual

[PROBAR-HOY.md](PROBAR-HOY.md) reúne firmware, APK 0.3.0, montaje y pruebas en
orden. [android-release-2026-10-23.md](android-release-2026-10-23.md) registra la
publicación y configuración verificadas. Los documentos de entrega anteriores
se conservan como historia y no sustituyen ese estado.

## Mapa documental

| Archivo | Contenido |
|---|---|
| `requirements.md` | Requisitos escolares de referencia |
| `requirements-addendum.md` | Verificación pendiente sobre el pulsador como sensor |
| `architecture.md` | Arquitectura y responsabilidades |
| `hardware.md` | Inventario, interfaces físicas y pendientes |
| `firmware.md` | Convenciones y comportamiento embebido |
| `packet-protocol.md` | Contrato MVP v1 implementado; máximo dos nodos |
| `app.md` | Arquitectura Flutter y adaptación funcional 0.3.0 |
| `backend.md` | Arquitectura Supabase/PostgreSQL y evidencia enlazada |
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

## MVP de entrega 2026-11-06

La especificación posterior del usuario concreta WebSocket local, WROOM-32 y uno
o dos nodos en el primer MVP. Consultar primero:

- [Instalación y pinout propuesto](mvp-installation.md).
- [Bitácora de implementación y aprobaciones](implementation-log.md).
- [Pruebas físicas pendientes](mvp-physical-tests.md).
- [Informe técnico escolar](mvp-school-report.md).

Las referencias anteriores a cinco nodos son la ampliación prevista. Hoy solo
hay placas y pulsador; no hay validación física de WS2812B ni alimentación.

## Entrega para el colegio

- [Estado final](ESTADO-FINAL-MVP.md).
- [Guía del viernes 23/10/2026](GUIA-COLEGIO-2026-10-23.md).
- [Planilla de resultados sin completar](registro-pruebas-colegio.md).

La publicación posterior usa Flutter3.47.4 y aprueba21tests. Los bloqueos de SDK
descriptos en entradas previas son históricos. PROBAR-HOY y android-release son
las referencias actuales para APK/acceso remoto y límites de validación física.

- [Resumen de entrega y referencia Git](RESUMEN-ENTREGA.md).
- [Prompt para retomar desde la computadora del colegio](PROMPT-PARA-MANANA.md).
- [Cierre software del23/10, verificación Supabase y estimación MVP](CIERRE-SOFTWARE-2026-10-23.md).
- [Próximo armado en protoboard con LED común](MVP-PROTOBOARD.md).
