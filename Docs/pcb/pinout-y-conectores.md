# GPIO y conectores — pendientes de definición

No existe un pinout final. La placa ESP32 exacta debe identificarse antes de
asignar señales.

| Señal lógica | GPIO | Condición previa |
|---|---|---|
| `BUTTON_N` | `TBD` | GPIO digital apto para `INPUT_PULLUP`, sin conflicto de arranque |
| `LED_DATA` | `TBD` | Salida compatible con el circuito de adaptación de nivel seleccionado |
| `VBAT_SENSE` | `TBD` | ADC compatible con radio activa y divisor calculado |
| `AUX` | `TBD` | Solo si aparece un requisito aprobado |

El buzzer no forma parte del hardware vigente; no se le reserva GPIO ni
circuitería salvo una decisión posterior registrada.

## Interfaces físicas conceptuales

| Interfaz | Señales | Estado |
|---|---|---|
| Pulsador | `BUTTON_N`, GND | Conector/serie `TBD`; requiere alivio de tensión |
| WS2812B | alimentación, GND, datos | Conector, tensión y corriente `TBD` |
| Batería | positivo, negativo | Conector, química y protección `TBD` |
| Alimentación | según topología final | `TBD`; no inventar terminales del módulo |
| Servicio | señales de prueba necesarias | Definir después del esquemático |

## Criterios

- Pulsador NA hacia GND y `INPUT_PULLUP` solo si el GPIO confirmado lo permite.
- Un evento por accionamiento, con rearme tras liberación estable.
- El pulsador no es un tope mecánico ni mide fuerza.
- Para WS2812B, definir alimentación, masa común, adaptación de nivel,
  resistencia de datos y desacoplamiento desde las hojas técnicas de las piezas
  elegidas.
- Para sensar batería, calcular el divisor para la tensión máxima real, calibrar
  el ADC y no inferir porcentaje lineal solo desde tensión bajo carga.

## Verificación antes de congelar el pinout

1. Identificar modelo y revisión de la placa real.
2. Revisar *strapping pins*, flash, pines solo entrada y restricciones ADC/Wi-Fi.
3. Verificar continuidad y niveles en prototipo.
4. Actualizar firmware, esquemático y esta tabla en el mismo cambio.
