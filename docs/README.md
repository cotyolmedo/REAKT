# Documentación REAKT

Esta carpeta distingue requisitos, decisiones, implementación y evidencia de
pruebas del proyecto.

## Empezar por el estado actual

Migración vigente del nodo: [piezo IO34 / LED IO33](firmware/piezo-node.md), con umbral 600,
diagnóstico y procedimiento físico A–I. El banco con pulsador conserva valor
histórico y no acredita pruebas físicas del piezo.

[PROBAR-HOY.md](inicio/PROBAR-HOY.md) reúne firmware, APK 0.3.0, montaje y pruebas en
orden. [android-release-2026-10-23.md](archivo/2026-10/android-release-2026-10-23.md) registra la
publicación y configuración verificadas. Los documentos de entrega anteriores
se conservan como historia y no sustituyen ese estado.

## Mapa documental

| Área | Referencias principales |
|---|---|
| [Inicio](inicio/) | [Prueba actual](inicio/PROBAR-HOY.md), instalación y desarrollo |
| [Arquitectura](arquitectura/) | [Diseño](arquitectura/architecture.md), [protocolo](arquitectura/packet-protocol.md), [decisiones](arquitectura/decisions.md) |
| [Especificaciones](especificaciones/) | [Requisitos](especificaciones/requirements.md), hoja de ruta y glosario |
| [Firmware](firmware/) | [Piezo vigente](firmware/piezo-node.md) y convenciones |
| [Aplicación](aplicacion/) | Arquitectura Flutter |
| [Backend](backend/) | Supabase, PostgreSQL y RLS |
| [Hardware](hardware/) | Diseño eléctrico, mecánico y [PCB](hardware/pcb/) |
| [Validación](validacion/) | [Pruebas](validacion/testing.md), planes, resultados y pendientes |
| [Historial](historial/) | [Bitácora](historial/implementation-log.md) |
| [Archivo](archivo/2026-10/) | Entregas e informes históricos de octubre |

## Fuentes de verdad

- El código describe lo implementado.
- Esta documentación describe requisitos y decisiones acordadas.
- `docs/validacion/testing.md` describe únicamente verificaciones con evidencia.
- Los sketches en `tests/historicas/` pueden ser históricos y no representan el diseño
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

- [Instalación y pinout propuesto](inicio/mvp-installation.md).
- [Bitácora de implementación y aprobaciones](historial/implementation-log.md).
- [Pruebas físicas pendientes](validacion/mvp-physical-tests.md).
- [Informe técnico escolar](archivo/2026-10/mvp-school-report.md).

Las referencias a cinco nodos son la ampliación prevista. El banco actual tiene
un nodo con pulsador y LED común enGPIO18/23, probado desde Android. WS2812B y
alimentación recargable siguen sin validación física.

## Entrega para el colegio

- [Estado final](archivo/2026-10/ESTADO-FINAL-MVP.md).
- [Guía del viernes 23/10/2026](archivo/2026-10/GUIA-COLEGIO-2026-10-23.md).
- [Planilla de resultados del banco](validacion/registro-pruebas-colegio.md).

La publicación posterior usa Flutter3.47.4 y aprueba21tests. Los bloqueos de SDK
descriptos en entradas previas son históricos. PROBAR-HOY y android-release son
las referencias actuales para APK/acceso remoto y límites de validación física.

- [Resumen de entrega y referencia Git](archivo/2026-10/RESUMEN-ENTREGA.md).
- [Prompt para retomar desde la computadora del colegio](archivo/2026-10/PROMPT-PARA-MANANA.md).
- [Cierre software del23/10, verificación Supabase y estimación MVP](archivo/2026-10/CIERRE-SOFTWARE-2026-10-23.md).
- [Próximo armado en protoboard con LED común](inicio/MVP-PROTOBOARD.md).
