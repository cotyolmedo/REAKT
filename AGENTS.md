# REAKT - Instrucciones del repositorio

## Identidad y arquitectura
REAKT es un proyecto integrador de electrónica de la E.E.S.T. N.º 4. El MVP usa Flutter ↔ gateway ESP32 ↔ uno o dos nodos ESP32 por ESP-NOW y Supabase/PostgreSQL para persistencia autenticada. Cinco nodos son la ampliación prevista.

## Hardware vigente
- Un ESP32 central y uno o dos nodos en el MVP; el prototipo de banco probado usó un nodo WROOM-32. Pinout eléctrico definitivo: pendiente.
- Entrada principal de cada nodo: disco piezoeléctrico por solicitud del 06/11/2026, con señal acondicionada y protección del ADC pendientes de validar. El pulsador NA queda como banco histórico.
- Salida visual: LED RGB direccionable WS2812B; número de LED, alimentación y GPIO: TBD.
- Alimentación recargable prevista; batería, regulador, protección y power-path: TBD.
- La carcasa hexagonal está en fase conceptual, no constituye un diseño mecánico validado.

## Reglas de desarrollo
1. Leer `docs/README.md` y los documentos pertinentes antes de modificar código.
2. Conservar los ensayos anteriores de ESP32-C3 y pulsador como evidencia histórica; el piezo es la entrada del desarrollo vigente y requiere validación física propia.
3. Usar C/C++ y firmware no bloqueante: `millis()`, `esp_timer_get_time()` y máquinas de estados. Evitar `delay()` en producción.
4. Para pulsadores, contemplar `INPUT_PULLUP` cuando el circuito lo permita, detección de flancos, antirrebote y eventos únicos por accionamiento.
5. Separar adquisición de entradas, control de LED, comunicación, temporización, lógica y errores.
6. Mantener un protocolo común a todos los modos; consultar `docs/arquitectura/packet-protocol.md` antes de definir campos o codificaciones.
7. No inventar MAC, GPIO, esquemas de alimentación, interfaces de app, métricas medidas ni resultados de pruebas.
8. No incrustar contraseñas, tokens ni credenciales de Supabase. No usar claves privilegiadas en Flutter.
9. Documentar decisiones en `docs/arquitectura/decisions.md`, avances en `docs/especificaciones/roadmap.md` y verificaciones en `docs/validacion/testing.md`.
10. Respetar los requisitos escolares de `docs/especificaciones/requirements.md`. Un pulsador es una entrada digital; confirmar con docentes si satisface el requisito de sensor.
11. No reescribir código funcional no relacionado. Compilar y probar cuando sea posible, e indicar explícitamente las verificaciones pendientes.
12. Los commits de la reorganización en `chore/reorganizacion-2026-11` están autorizados. No fusionar en `main`, borrar ramas remotas ni usar force push. Otros trabajos requieren su propia autorización.

## Áreas
- `firmware/gateway/`: coordinador ESP32.
- `firmware/nodes/`: firmware de nodos ESP32, pendiente de desarrollo/validación.
- `docs/`: documentación técnica.
- `tests/`: pruebas automáticas; `tests/historicas/`: sketches antiguos.
- `app/`, `backend/`: componentes planificados según la estructura efectiva del repositorio.
- `.agent/`: planificación de cambios extensos.

## Criterio de estado
`TBD`: por definir; `TODO`: decidido, no implementado; `IN PROGRESS`: en desarrollo; `DONE`: implementado y verificado; `BLOCKED`: dependencia externa.

## Ingeniería KiCad y CAD V1
Antes de crear o modificar PCB/CAD, leer `docs/hardware/pcb/README.md` y `docs/hardware/diseno-mecanico.md`. Las dimensiones aproximadas no autorizan footprints finales; medir piezas reales. No crear artefactos KiCad/CAD falsos ni declarar ERC/DRC o pruebas físicas completados sin ejecutarlos. Mantener PCB separada de cargas mecánicas, protección Li-ion y verificación del power-path. Consultar `docs/hardware/pcb/plan-codex.md`.
