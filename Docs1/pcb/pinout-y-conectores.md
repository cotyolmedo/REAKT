# GPIO y conectores — propuesta NO congelada

| Señal | GPIO provisional | Comentario |
|---|---|---|
| `IMPACT_N` | GPIO27 | `INPUT_PULLUP`, pulsador NA a GND; detección flanco HIGH→LOW |
| `LED_DATA_3V3` | GPIO18 | salida hacia buffer 74AHCT125 alimentado a 5 V |
| `VBAT_ADC` | GPIO34 | ADC1 entrada; divisor dimensionado para VBAT máximo, sin sobrepasar tensión admitida |
| `BUZZER_CTRL` | GPIO25 | opcional, mediante driver si carga supera capacidad GPIO |
| `AUX` | GPIO26 | reservado |

Confirmar pines reales de «ESP32 32-s kit» y evitar pines de arranque (*strapping*), flash, entrada exclusiva cuando corresponda, y ADC2 si se usa Wi-Fi.

## Interfaces físicas
| Ref. | Conector | Señales | Requisito |
|---|---|---|---|
| J_IMPACT | 2 vías | IMPACT_N, GND | con retención, alivio de tensión |
| J_RGB | 3 vías | +5V_LED, GND, DATA_5V | dimensionado a corriente total de tira |
| J_BAT | 2 vías | B+, B− | polarizado y protegido, serie a definir |
| J_PWR | según módulo | alimentación desde gestor | no inventar terminales |
| J_SERVICE | testpoints | GND, 3V3, 5V, VBAT, DATA, IMPACT | acceso en carcasa |

## Entrada de impacto
El cierre del contacto **no mide fuerza**. Implementar antirrebote no bloqueante, evento único por activación y rearme tras liberación estable. Comprobar accionamiento repetido y simultáneo de varios nodos. El pulsador no es el tope de carga mecánica.

## Datos LED
Usar 74AHCT125 a 5 V con entrada TTL-compatible y habilitación apropiada; resistor serie de datos **300–500 Ω** como referencia de guía y capacitor bulk **500–1000 µF** cerca de alimentación de tira según montaje. Validar polaridad y tensión del capacitor, posición del buffer y longitud de cable.

## Batería ADC
Elegir R superior e inferior para que `V_ADC = V_BAT × Rinf/(Rsup+Rinf)` quede dentro de margen permitido al máximo VBAT. Calibrar ADC; no inferir porcentaje de carga linealmente solo por voltaje bajo carga.

## Referencias
- https://www.ti.com/product/SN74AHCT125
- https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels
