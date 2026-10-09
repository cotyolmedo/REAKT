# Arquitectura eléctrica V1 — nodo y gateway

## Nodo: diagrama de bloques
```text
USB-C externo
    │
TP4056 1S (módulo a identificar) ─── Celda 1S protegida / protección equivalente
    │                                     │
    └── [gestión de carga y power-path TBD] ── interruptor / protección de línea
                                                 │
                                     ┌───────────┴───────────┐
                                regulador 3V3          regulador 5V LED
                                     │                       │
                              ESP32 DevKit             WS2812B + bulk C
                                     │                       ▲
                        GPIO27 ← pulsador NA           74AHCT125 ← GPIO18
                        GPIO34 ← divisor batería
                        GPIO25 → buzzer opcional
                        Wi-Fi/ESP-NOW ↔ gateway
```
El esquema es **conceptual**, no una netlist fabricable. La topología real de power-path, protecciones, reguladores, masa y puertos debe seleccionarse con hojas técnicas.

## Bloques del esquemático en KiCad
1. `PWR_INPUT`: entrada del cargador, batería, protección, interruptor y fusible adecuado.
2. `REG_3V3`: fuente para ESP32, picos RF, desacoplamiento y pruebas.
3. `REG_5V_LED`: fuente de LED dimensionada para corriente y autonomía objetivo.
4. `MCU_CARRIER`: dos conectores hembra del ESP32; footprint medido y orientación marcada.
5. `INPUT_IMPACT`: conector 2 vías, pull-up, protección/filtrado opcional según cable y ESD; masa común.
6. `RGB`: buffer 74AHCT125 a 5 V, salida datos, resistencia serie, bulk capacitor y conector 3 vías.
7. `VBAT_SENSE`: divisor a ADC1, posible habilitación por MOSFET y filtrado; evitar consumo parasitario.
8. `SERVICE`: testpoints GND, VBAT, 3V3, 5V, DATA, INPUT; serigrafía y puntos de depuración.

## Reglas
- No alimentar el pin `3V3` con tensión de celda 1S sin regulación.
- No suponer que `VIN/5V` de una placa DevKit acepta cualquier tensión de batería; comprobar su regulador y camino de alimentación.
- Evitar alimentar simultáneamente el USB de la DevKit y una fuente externa sin analizar la protección contra retorno de corriente.
- Para WS2812B a 5 V, no depender de niveles de 3,3 V fuera de especificación; usar buffer compatible y masa común.
- ESP-NOW no implica que los eventos recibidos tengan latencia cero ni que los relojes de distintos nodos estén sincronizados.
- Mantener conector del pulsador desacoplado de esfuerzos mecánicos y del circuito RF.
- Si el TP4056 elegido solo expone `B+/B−`, no inventar salidas protegidas. Si expone `OUT+/OUT−`, verificar físicamente qué protección incorpora.

## Interfaz aplicación-gateway
**TBD:** BLE, Wi-Fi AP/STA u otro transporte compatible con Flutter; coexistencia de canal Wi-Fi/ESP-NOW y su efecto en el firmware deben probarse. No implementar un enlace imaginario.

## Referencias
- https://www.ti.com/product/SN74AHCT125
- https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels
- https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32/esp32-devkitc/user_guide.html
