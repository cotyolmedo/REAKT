# Firmware REAKT

## Implementación actual — 23/10/2026

MVP de uno o dos nodos y gateway implementado según [protocolo v1](packet-protocol.md).
Nodo con pulsador, antirrebote20ms, ACK/reintentos y salida digital/WS2812B/off;
gateway con SoftAP canal6 y WebSocket81. Cinco nodos siguen siendo ampliación.
Compilado y cargado; ensayo físico básico con un nodo y Android comprobado.
Matriz extendida pendiente. [Guía operativa](PROBAR-HOY.md).

## Destinos

- Un ESP32 gateway.
- Cinco nodos ESP32 con pulsador digital y WS2812B.

Entorno previsto: Arduino IDE, C/C++ y ESP32 Arduino core. La placa concreta y
la versión del core deben registrarse con cada compilación relevante.

## Reglas

- Evitar `delay()` en firmware productivo.
- Usar `millis()` para temporización general y `esp_timer_get_time()` cuando se
  necesiten marcas locales de microsegundos.
- Separar inicialización, comunicación, adquisición, lógica, salidas,
  temporización y errores.
- Mantener callbacks de radio breves: validar límites, copiar/encolar y procesar
  fuera del callback.
- Interpretar y validar payloads según `Docs/packet-protocol.md`, ya definido para el MVP.

## Pulsador

- Usar `INPUT_PULLUP` con pulsador NA hacia GND solo si el circuito final lo
  permite.
- Detectar una transición estable HIGH → LOW.
- Emitir un solo evento y exigir liberación estable antes de rearmar.
- Implementar antirrebote configurable y no bloqueante.
- Definir si el timestamp representa el primer flanco o la confirmación tras el
  antirrebote; documentar y validar el criterio.

## ESP-NOW

- Definir canal, peers y direccionamiento antes de registrarlos en producción.
- Gestionar inicialización fallida, colas llenas y fallos de envío.
- Incorporar validación, ACK/reintentos, deduplicación y timeouts después de
  cerrar el protocolo v1.
- No asumir relojes sincronizados ni latencia nula entre dispositivos.

## Estados conceptuales de nodo

`INICIALIZANDO → LISTO → ESPERANDO_ESTIMULO → OBJETIVO_ACTIVO → EVENTO_REGISTRADO → LISTO`

También deben existir estados o rutas de recuperación para errores y pérdida de
comunicación. Los estados no implican que el modo de entrenamiento esté ya
implementado.

## Estado real

- `firmware/gateway/`: base de transporte con cola y recuperación no bloqueante.
- `firmware/nodes/`: base de adquisición con GPIO deshabilitado hasta definir el
  pinout y recepción opaca de ESP-NOW.
- Protocolo v1, control WS2812B, peers, app y sesiones: pendientes.
- Compilación para la placa real y pruebas físicas: pendientes.
