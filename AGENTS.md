# REAKT - Instrucciones del repositorio

## Identidad y arquitectura
REAKT es un proyecto integrador de electrónica de la E.E.S.T. N.º 4. Arquitectura acordada: aplicación Flutter ↔ gateway ESP32 ↔ cinco nodos ESP32 mediante ESP-NOW; Supabase/PostgreSQL para persistencia a través de la aplicación o servicio autorizado.

## Hardware vigente
- Un ESP32 central y cinco ESP32 periféricos; modelo exacto de placa y pinout: TBD.
- Entrada principal de cada nodo: pulsador mecánico normalmente abierto (NA). El piezoeléctrico queda descartado del diseño vigente.
- Salida visual: LED RGB direccionable WS2812B; número de LED, alimentación y GPIO: TBD.
- Alimentación recargable prevista; batería, regulador, protección y power-path: TBD.
- La carcasa hexagonal está en fase conceptual, no constituye un diseño mecánico validado.

## Reglas de desarrollo
1. Leer `Docs/README.md` y los documentos pertinentes antes de modificar código.
2. Conservar los ensayos anteriores de ESP32-C3 y piezoeléctricos como evidencia histórica; no confundirlos con el diseño actual.
3. Usar C/C++ y firmware no bloqueante: `millis()`, `esp_timer_get_time()` y máquinas de estados. Evitar `delay()` en producción.
4. Para pulsadores, contemplar `INPUT_PULLUP` cuando el circuito lo permita, detección de flancos, antirrebote y eventos únicos por accionamiento.
5. Separar adquisición de entradas, control de LED, comunicación, temporización, lógica y errores.
6. Mantener un protocolo común a todos los modos; consultar `Docs/packet-protocol.md` antes de definir campos o codificaciones.
7. No inventar MAC, GPIO, esquemas de alimentación, interfaces de app, métricas medidas ni resultados de pruebas.
8. No incrustar contraseñas, tokens ni credenciales de Supabase. No usar claves privilegiadas en Flutter.
9. Documentar decisiones en `Docs/decisions.md`, avances en `Docs/roadmap.md` y verificaciones en `Docs/testing.md`.
10. Respetar los requisitos escolares de `Docs/requirements.md`. Un pulsador es una entrada digital; confirmar con docentes si satisface el requisito de sensor.
11. No reescribir código funcional no relacionado. Compilar y probar cuando sea posible, e indicar explícitamente las verificaciones pendientes.
12. No hacer commit/push automáticamente sin autorización. Nunca usar force push.

## Áreas
- `firmware/gateway/`: coordinador ESP32.
- `firmware/nodes/`: firmware de nodos ESP32, pendiente de desarrollo/validación.
- `Docs/`: documentación técnica.
- `Tests/`: pruebas, incluidas las históricas.
- `app/`, `backend/`: componentes planificados según la estructura efectiva del repositorio.
- `.agent/`: planificación de cambios extensos.

## Criterio de estado
`TBD`: por definir; `TODO`: decidido, no implementado; `IN PROGRESS`: en desarrollo; `DONE`: implementado y verificado; `BLOCKED`: dependencia externa.

## Ingeniería KiCad y CAD V1
Antes de crear o modificar PCB/CAD, leer `Docs/pcb/README.md` y `Docs/diseno-mecanico.md`. Las dimensiones aproximadas no autorizan footprints finales; medir piezas reales. No crear artefactos KiCad/CAD falsos ni declarar ERC/DRC o pruebas físicas completados sin ejecutarlos. Mantener PCB separada de cargas mecánicas, protección Li-ion y verificación del power-path. Consultar `Docs/pcb/plan-codex.md`.
