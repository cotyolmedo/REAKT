# Firmware MVP REAKT

- Gateway WROOM-32: SoftAP canal6, WebSocket81, rondas aleatorias, ACK y métricas.
- Uno o dos nodos WROOM-32: ESP-NOW, pulsador antirrebote20ms, reloj monotónico,
  salida deshabilitada, LED digital o WS2812B configurable.
- `libraries/ReaktCore`: contrato y máquinas portátiles compartidas.

Referencia original Arduino-ESP32 2.0.17. Banco posterior core3.3.4 cargado en gateway
y nodo: LED comúnGPIO23/pulsadorGPIO18 y Android probados según
[registro](../Docs/banco-2026-10-23.md). Configuración pública por defecto imprime
MAC y bloqueo, sin peers inventados ni GPIO habilitados. Cada banco requiere
configuración local y comprobación de su circuito. WS2812B y matriz extendida pendientes.
Ver [instalación, pinout y herramientas](../Docs/mvp-installation.md) y
[protocolo](../Docs/packet-protocol.md).

Los ensayos históricos en Tests/ no representan el nuevo protocolo. Las simulaciones
C++ no verifican radio ni hardware. No hay delay() en los sketches ni núcleo propio.
