# Firmware del gateway REAKT

## Estado
`REAKT_Gateway.ino` es un esqueleto de transporte ESP-NOW, no una implementación completa de sesiones.

## Arquitectura vigente
- Gateway: ESP32.
- Nodos: cinco ESP32 (no ESP32-C3).
- Cada nodo usa pulsador mecánico NA y WS2812B; su firmware final está pendiente.

## Implementado en el esqueleto
Inicialización Wi-Fi estación, ESP-NOW, callbacks de envío/recepción, contadores de diagnóstico y ejecución periódica con `millis()`.

## Pendiente
- MAC de nodos, registro de peers y política de canal.
- Protocolo v1, validación, colas, ACK, reintentos y deduplicación.
- Interfaz app↔gateway y lógica de sesiones.
- Compilación/validación con la versión concreta de Arduino ESP32 core.

## Ensayos propuestos
1. Compilar para la placa gateway real y registrar versión del core.
2. Verificar inicialización por monitor serie.
3. Probar recepción y transmisión con **un nodo ESP32**.
4. Extender a cinco nodos, pérdidas, duplicados y recuperación.

No se afirma validación física de este esqueleto.
