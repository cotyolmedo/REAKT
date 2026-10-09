# Firmware de nodos REAKT

`REAKT_Node/REAKT_Node.ino` es la estructura inicial para los cinco ESP32 periféricos. La carpeta conserva el nombre del sketch principal requerido por Arduino IDE/CLI.

Incluye:

- lectura no bloqueante del pulsador NA con `INPUT_PULLUP` cuando se configure un GPIO verificado;
- detección de transición estable, antirrebote y un único evento hasta la liberación;
- estados conceptuales del nodo;
- inicialización ESP-NOW sin inventar MAC, canal ni peer;
- punto de integración para WS2812B sin escribir en GPIO todavía no confirmados.

El protocolo v1 no está implementado porque `Docs1/packet-protocol.md` todavía
lo declara TBD. El nodo no mide fuerza ni intensidad de impacto.
