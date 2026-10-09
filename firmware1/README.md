# Firmware vigente de REAKT

Esta carpeta contiene la estructura de firmware alineada con `Docs1/`:

- `gateway/REAKT_Gateway/REAKT_Gateway.ino`: ESP32 central.
- `nodes/REAKT_Node/REAKT_Node.ino`: firmware común para los cinco ESP32 periféricos.

## Alcance implementado

La base cubre la organización no bloqueante, la inicialización ESP-NOW, las
colas de recepción fuera de callbacks, contadores de diagnóstico, recuperación
del transporte del gateway y la lectura antirrebote del pulsador en los nodos.

## Bloqueos legítimos

El protocolo v1, las MAC, el canal, los GPIO, la cantidad de WS2812B, la
alimentación y la interfaz App ↔ gateway continúan pendientes en la
documentación. No deben completarse con valores inventados. La compilación y
las pruebas físicas requieren seleccionar y medir las placas reales.
