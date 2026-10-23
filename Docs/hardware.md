# Hardware REAKT

## Banco actual — 23/10/2026

GatewayCOM4 ESP32-D0WDQ6 y nodoCOM19 ESP32-D0WDQ6-V3, flash4MB, alimentados por
USB. PulsadorNA GPIO18→GND y LED común con resistencia GPIO23→ánodo/cátodo→GND
confirmados por usuario y probados funcionalmente desde Android. Refiere solo al
banco de un nodo; no cierra la placa comercial, medidas ni pinout final de PCB.
El MVP usa ESP-NOW canal6 y WebSocket81. Ver [evidencia](banco-2026-10-23.md).

## Inventario vigente

| Elemento | Cantidad | Estado |
|---|---:|---|
| ESP32 central (gateway) | 1 | Arquitectura aceptada; placa exacta `TBD` |
| ESP32 periféricos | 5 | Arquitectura aceptada; placa exacta `TBD` |
| Pulsador mecánico normalmente abierto | 1 por nodo | Entrada acordada; modelo `TBD` |
| LED RGB direccionable WS2812B | `TBD` | Salida acordada; cantidad por nodo `TBD` |
| Carga y alimentación recargable | `TBD` | Topología, componentes y protección `TBD` |

Los ensayos antiguos con ESP32-C3 y piezoeléctricos no definen el hardware
actual. Sus GPIO tampoco deben copiarse a las placas nuevas.

## Nodo ESP32

- Entrada digital mediante pulsador NA. Cuando el circuito y el GPIO lo
  permitan, la opción prevista es pulsador hacia GND con `INPUT_PULLUP`.
- Lectura por flancos, antirrebote no bloqueante y un evento por accionamiento.
- Salida WS2812B para estímulo y estados; cantidad, GPIO, tensión, limitación de
  brillo y adaptación de nivel continúan `TBD`.
- ESP-NOW hacia el gateway; MVP canal6 y pares configurados por MAC reales locales.
  La ampliación a cinco nodos sigue pendiente.
- Carcasa hexagonal conceptual. La PCB, la batería y el pulsador deben quedar
  fuera del camino principal de carga mecánica.

El pulsador no mide fuerza, energía ni intensidad de impacto.

## Gateway ESP32

Coordina hasta dos nodos en el MVP y se comunica con Flutter mediante WebSocket
local en192.168.4.1:81. Cinco nodos, alimentación final y placa de producto pendientes.

## Alimentación y seguridad

Antes de diseñar el esquemático final se debe definir y verificar:

1. batería, química, capacidad y protección;
2. cargador y corriente de carga;
3. comportamiento durante carga y necesidad de *power-path*;
4. regulación para ESP32 y WS2812B;
5. consumo máximo y autonomía objetivo;
6. conectores, fusibles/protecciones y prevención de retorno de corriente;
7. fijación y aislamiento mecánico de la celda.

Un módulo TP4056 previsto no debe tratarse como regulador ni como solución de
*power-path*. No conectar una celda directamente a `3V3` ni asumir que un GPIO
puede manejar una carga sin revisar tensión y corriente.

## Decisiones bloqueantes

- Identificar y medir las placas ESP32 reales.
- Elegir GPIO compatibles evitando pines de arranque o funciones reservadas.
- Elegir pulsador y documentar fuerza, carrera, sobrecarrera y vida útil.
- Definir cantidad de LED y presupuesto de corriente.
- Cerrar batería, protección, carga, regulación y política durante carga.
- Confirmar con docentes si el pulsador satisface el requisito de sensor.

La ingeniería preliminar se organiza en `Docs/pcb/README.md` y
`Docs/diseno-mecanico.md`. Ninguna dimensión aproximada autoriza un footprint o
una fabricación final.

## Disponibilidad comunicada para el MVP — 2026-10-22

El usuario dispone únicamente de placas ESP32 y pulsador. WROOM-32/DevKitC es el
destino de compilación solicitado, por cotejar con placas reales. GPIO18 para
pulsador y GPIO23 para cinco WS2812B son propuestas, no pinout validado. Salida LED
deshabilitada; no hay LEDs/fuente/regulación/adaptación de nivel confirmados.
Ver mvp-installation.md para conexiones propuestas y pruebas sin LEDs.
