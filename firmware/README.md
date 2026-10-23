# Firmware MVP REAKT

- Gateway WROOM-32: SoftAP canal6, WebSocket81, rondas aleatorias, ACK y métricas.
- Uno o dos nodos WROOM-32: ESP-NOW, pulsador antirrebote20ms, reloj monotónico,
  salida opcional cinco WS2812B.
- `libraries/ReaktCore`: contrato y máquinas portátiles compartidas.

Compilados con Arduino-ESP32 2.0.17; sin carga ni validación física. Configuración
por defecto imprime MAC y bloqueo, no inventa peers. GPIO18/23 requieren validación
explícita. El usuario solo tiene placas y pulsador: LEDs deshabilitados por defecto.
Ver [instalación, pinout y herramientas](../Docs/mvp-installation.md) y
[protocolo](../Docs/packet-protocol.md).

Los ensayos históricos en Tests/ no representan el nuevo protocolo. Las simulaciones
C++ no verifican radio ni hardware. No hay delay() en los sketches ni núcleo propio.
