# Nodo MVP

La versión integrada admite LED digital con polaridad configurable, WS2812B con
cantidad configurable o salida deshabilitada mediante `Stimulus.h`. LED común
requiere resistencia y circuito verificados; no requiere NeoPixel. Las variantes
digital y deshabilitada también compilaron con core3.3.4. Empezar por
[PROBAR-HOY](../../Docs/PROBAR-HOY.md) y [protoboard](../../Docs/MVP-PROTOBOARD.md).

Abrir `REAKT_Node/REAKT_Node.ino`. Compilado para ESP32 Dev Module con core2.0.17,
ReaktCore y Adafruit NeoPixel1.12.3. Copiar LocalConfig.example.h a LocalConfig.h.

Registrar MAC station real del gateway, ID1/2, validar GPIO18 pulsadorNA a GND y
habilitar REAKT_HARDWARE_VALIDATED. LED GPIO23 es propuesta: REAKT_LED_ENABLED=0
por defecto porque el usuario todavía no tiene LEDs ni fuente. Cinco WS2812B solo
tras adquirirlos/verificar circuito; no alimentar desde GPIO ni regulador3V3.

Callback encola, loop valida peer/sesión/secuencia y confirma comandos sin repetir
estímulos. Reacción se mide localmente tras show y al confirmar debounce20ms.
Sin LEDs habilitados los eventos son diagnósticos, no medición de reacción visual.
Ver Docs/mvp-installation.md y Docs/mvp-physical-tests.md. No se probó en placa.
