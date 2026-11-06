# BOM preliminar y estrategia de compras

**Estado:** cantidades por **un nodo** salvo aclaración; no constituye orden de compra.

| Grupo | Cantidad | Elemento | Estado |
|---|---:|---|---|
| Control | 1 | ESP32 DevKit («32-s kit») | existente / variante por confirmar |
| PCB | 1 | carrier FR-4 2 capas | por diseñar |
| Entrada | 1 | pulsador mecánico NA con soporte | modelo por elegir |
| LED | 1 | tira WS2812B, longitud según perímetro | cantidad LED por decidir |
| Adaptación | 1 | buffer 74AHCT125 | candidato |
| LED pasivos | 1 + 1 | resistencia datos + capacitor bulk | valores finales según esquema |
| Energía | 1 | celda Li-ion/LiPo 1S | TBD |
| Energía | 1 | portabatería / alojamiento | TBD |
| Carga | 1 | módulo TP4056 USB-C | previsto, variante por medir |
| Protección | 1 conjunto | protección de celda + fusible según diseño | TBD |
| Energía | 1 | power-path o bloqueo durante carga | TBD |
| Regulación | 1 + 1 | regulador 3V3 y 5V LED | TBD |
| Sensado | 2+ | divisor VBAT, filtrado y posible habilitación | TBD |
| Interfaz | varios | conectores con retención, cables, testpoints | TBD |
| Mecánica | varios | tornillos, soportes, amortiguadores | consultar diseño mecánico |

**Total nodos:** multiplicar por cinco solo después de validar el prototipo. **Gateway:** BOM independiente.

## Reglas de BOM
Registrar `Reference`, `Value`, `Footprint`, `Manufacturer`, `MPN`, `Supplier`, `Qty`, `Unit Cost`, `Source`, `Status`, `Datasheet` y `Notes`. No inventar precios ni disponibilidad; permitir equivalentes únicamente después de comparar dimensiones, características y pinout.
