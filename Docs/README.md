# Documentación REAKT

## Empezar

- [Puesta en marcha](PROBAR-HOY.md): herramientas, montaje, app y sincronización.
- [Montaje de protoboard](MVP-PROTOBOARD.md) e [instalación](mvp-installation.md).
- [APK vigente 0.3.1](android-release-2026-10-30.md) y
  [evidencia de 0.3.0](android-release-2026-10-23.md).
- [Pruebas físicas](mvp-physical-tests.md) y [planilla de banco](registro-pruebas-colegio.md).

## Referencias

| Tema | Documentos |
|---|---|
| Requisitos escolares | [Requisitos](requirements.md), [pulsador como sensor](requirements-addendum.md) |
| Arquitectura y protocolo | [Arquitectura](architecture.md), [protocolo](packet-protocol.md) |
| Software | [Flutter](app.md), [backend](backend.md), [firmware](firmware.md) |
| Hardware | [Inventario](hardware.md), [mecánica](diseno-mecanico.md), [PCB](pcb/README.md) |
| Desarrollo | [Flujo](development.md), [glosario](glossary.md), [sitio web](web-publication.md) |
| Decisiones y avance | [Decisiones](decisions.md), [roadmap](roadmap.md), [bitácora](implementation-log.md) |
| Evidencia | [Verificaciones](testing.md), [banco del 23/10](banco-2026-10-23.md) |
| Entrega escolar | [Informe](mvp-school-report.md) |
| Antecedentes | [Entregas y notas consolidadas](historial-entrega.md), [cambio de hardware](cambios-2026-10-08.md), [sitio anterior](historial-web.md) |

## Cómo interpretar el estado

El código describe lo implementado; requisitos y decisiones describen lo acordado.
Las pruebas solo se consideran hechas cuando tienen evidencia. Los ensayos en
`tests/historical/` y las notas consolidadas son antecedentes, con el estado de su
fecha. No sustituyen la guía de puesta en marcha ni la evidencia posterior.

El MVP admite uno o dos nodos; cinco nodos es la ampliación prevista. El banco
probado usa un nodo con pulsador y LED común en GPIO18/23. WS2812B y alimentación
recargable siguen pendientes de validación física.

`TBD`: por definir · `TODO`: pendiente · `IN PROGRESS`: en desarrollo ·
`DONE`: implementado y verificado · `BLOCKED`: dependencia externa.
