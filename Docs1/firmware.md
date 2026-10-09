# Firmware REAKT

## Destinos
- ESP32 central (gateway).
- Cinco nodos ESP32 con entrada digital de pulsador y salida WS2812B.

Entorno previsto: Arduino IDE, C/C++ y ESP32 Arduino core. Registrar la versión utilizada al compilar.

## Reglas
- No usar `delay()` en firmware productivo.
- Usar `millis()` para temporización general y `esp_timer_get_time()` cuando se necesiten marcas locales de microsegundos; precisión de la medida no implica precisión equivalente extremo a extremo.
- Organizar inicialización, ESP-NOW, entrada, máquina de estados, LEDs, eventos y manejo de errores.

## Lectura de pulsador
- Configurar un GPIO apto como `INPUT_PULLUP` con pulsador NA hacia GND, sujeto al esquemático final.
- Detectar transición estable HIGH→LOW y registrar un único evento por accionamiento; exigir liberación estable antes de rearmar.
- Antirrebote no bloqueante con ventana configurable (valor inicial para ensayar: 15–30 ms, no validado).
- Para evitar alterar la medida de reacción, definir si la marca temporal se toma en el primer flanco y se confirma después del antirrebote; documentar el criterio.
- Rechazar activaciones fuera de la ventana válida de entrenamiento.

## ESP-NOW
- Inicializar radio y peers, comprobar canal y gestionar pérdidas, duplicados y timeouts.
- Callbacks: trabajo mínimo; copiar/enqueuear eventos y procesarlos en el ciclo principal o tarea adecuada.
- Un paquete común para modos; ver `Docs/packet-protocol.md`.
- Identificadores, marcas temporales, ACK/reintentos y sincronización entre nodos: TBD.

## Estados de nodo (conceptual)
`INICIALIZANDO → LISTO → ESPERANDO_ESTIMULO → OBJETIVO_ACTIVO → EVENTO_REGISTRADO → LISTO`, con estados de error/desconexión.

## Iluminación
Patrones propuestos (no implementados): objetivo activo, acierto, error, conexión, batería baja y modo de espera. Evitar que la actualización WS2812B interfiera con recepción o temporización; validar en hardware.

## Estado real
El gateway actual es una base de transporte ESP-NOW, no un sistema de entrenamiento completo. Firmware definitivo de nodos, protocolo v1 y aplicación integrada: pendientes.
