# Hardware REAKT

## Inventario y estado
| Elemento | Cantidad | Estado |
|---|---:|---|
| ESP32 central (gateway) | 1 | Arquitectura aceptada; placa exacta TBD |
| ESP32 periféricos | 5 | Sustituyen ESP32-C3; modelo exacto TBD |
| Pulsador mecánico normalmente abierto (NA) | 5 | Entrada principal acordada; modelo TBD |
| LED RGB direccionable WS2812B | TBD | Retroalimentación visual acordada; cantidad por nodo TBD |
| Módulo de carga TP4056 USB-C | Previsto por nodo | Selección preliminar; variante y corriente de carga por verificar |
| Batería y portabaterías | TBD | Química, capacidad, protección y disposición TBD |

## Nodo ESP32
- **Entrada:** contacto NA. Esquema preliminar: GPIO digital ↔ pulsador ↔ GND, con `INPUT_PULLUP` interno si el GPIO y la placa lo admiten. Al cerrar: nivel bajo. Debe verificarse el pinout y evitar pines de arranque o usos incompatibles.
- **Lectura:** flancos y antirrebote no bloqueante; un evento por pulsación válida. El pulsador no mide fuerza, energía ni intensidad de impacto.
- **Salida:** WS2812B para indicación de objetivo, acierto, error y estados. Definir cantidad, limitación de brillo, alimentación, masa común, resistencia de datos y adaptación de nivel lógico si corresponde.
- **Comunicación:** ESP-NOW con gateway; canal, direccionamiento y pares TBD.
- **Mecánica:** carcasa hexagonal negra y tapa móvil en etapa conceptual; no hay cotas finales ni resistencia al impacto validada.

## Gateway ESP32
- Coordina cinco nodos y se comunica con la app.
- GPIO, interfaz app↔gateway, alimentación y placa exacta: TBD.

## Alimentación y seguridad
- Un TP4056 carga una celda Li-ion/LiPo de una sola serie (1S) bajo condiciones apropiadas; **no** es regulador de 3,3 V/5 V ni garantiza alimentación simultánea y carga (*power-path*).
- Confirmar si la placa TP4056 tiene protección de celda, su corriente de carga y su compatibilidad con la batería seleccionada.
- Incorporar reguladores apropiados para ESP32 y WS2812B, protección eléctrica y dimensionamiento para picos de corriente.
- No colocar la celda en el recorrido de impactos; prever fijación y separación mecánica.
- No conectar WS2812B directamente a un GPIO sin verificar niveles lógicos, alimentación y consumo.

## Por definir antes del esquemático final
1. Modelo/dimensiones reales del ESP32 y mapa GPIO.
2. Pulsador concreto y curva fuerza-recorrido.
3. Número de LED y presupuesto de corriente.
4. Batería, protección, cargador, reguladores y uso mientras carga.
5. Conectores, fijación, acceso USB-C y cableado.
6. Sensor adicional si la evaluación escolar no admite un pulsador como sensor.

Los GPIO de antiguas pruebas ESP32-C3 no deben copiarse al diseño ESP32.

## Integración PCB V1 (2026-10-08)
La placa del nodo será inicialmente una carrier PCB para ESP32 DevKit; placa gateway separada. No están congelados batería, pinout físico, alimentación ni cantidad de LED. Ver `Docs/pcb/README.md`, `Docs/pcb/componentes-dimensiones.md`, `Docs/pcb/arquitectura-electrica.md` y `Docs/pcb/alimentacion-y-autonomia.md`.

Propuesta GPIO: GPIO27 impacto, GPIO18 datos LED, GPIO34 ADC1 batería, GPIO25 buzzer opcional. Verificar placa real. TP4056 USB-C es cargador 1S, no power-path ni fuente regulada. LED WS2812B a 5 V requiere dimensionamiento de corriente y adaptación de nivel lógico. Montar pulsador en bastidor, no sobre PCB sometida a impacto.
