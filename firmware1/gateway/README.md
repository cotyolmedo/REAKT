# Firmware del gateway REAKT

## Estado
`REAKT_Gateway/REAKT_Gateway.ino` es una estructura de transporte ESP-NOW con cola de recepción segura para callbacks. La carpeta conserva el nombre del sketch principal requerido por Arduino IDE/CLI. No es una implementación completa de sesiones ni del protocolo v1.

## Arquitectura vigente
- Gateway: ESP32.
- Nodos: cinco ESP32 (no ESP32-C3).
- Cada nodo usa pulsador mecánico NA y WS2812B; su firmware final está pendiente.

## Implementado
- Inicialización Wi-Fi estación y ESP-NOW.
- Callback de envío con contador de fallos.
- Callback de recepción que valida límites, copia y encola la trama.
- Procesamiento de la cola en el ciclo principal, fuera del callback.
- Contadores de diagnóstico y ejecución periódica con `millis()`.

## Pendiente
- MAC de nodos, registro de peers y política de canal.
- Protocolo v1, validación semántica, ACK, reintentos y deduplicación.
- Interfaz app↔gateway y lógica de sesiones.
- Compilación/validación con la versión concreta de Arduino ESP32 core.

## Ensayos pendientes
1. Compilar para la placa gateway real y registrar versión del core.
2. Verificar inicialización por monitor serie.
3. Probar recepción y transmisión con **un nodo ESP32**.
4. Extender a cinco nodos, pérdidas, duplicados y recuperación.

No se afirma validación física de esta estructura. Antes de cargarla hay que seleccionar la placa ESP32 real y registrar la versión del Arduino ESP32 core.
