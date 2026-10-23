# Gateway MVP

Abrir `REAKT_Gateway/REAKT_Gateway.ino`. Banco actual compilado y cargado para
ESP32 Dev Module con core3.3.4, ReaktCore1.0.0, WebSockets2.7.2 y ArduinoJson7.4.3.
La referencia histórica usó core2.0.17, WebSockets2.6.1 y ArduinoJson6.21.5.
Copiar LocalConfig.example.h a LocalConfig.h, completar contraseña >=12 caracteres y
MAC station reales. El segundo peer es opcional. Sin configuración imprime bloqueo.

Crea Wi-Fi REAKT-MVP canal6 y WebSocket en puerto81. Coordina hasta50 rondas,
selecciona un peer aleatorio y confirma eventos. Reintentos120ms x8; agotamiento
o evento ausente interrumpe sesión. Snapshot completo cada segundo y al reconectar.
Retiene solo la última sesión en RAM; no cortar alimentación antes de recuperarla.
Ver Docs/packet-protocol.md y Docs/mvp-installation.md. GatewayCOM4 y nodoCOM19
cargados; ensayo básico desde Android comprobado en
[registro](../../Docs/banco-2026-10-23.md). Pruebas de fiabilidad extendida pendientes.
