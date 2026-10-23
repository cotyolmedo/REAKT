# Hardware REAKT

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
- ESP-NOW hacia el gateway; canal, pares y direccionamiento continúan `TBD`.
- Carcasa hexagonal conceptual. La PCB, la batería y el pulsador deben quedar
  fuera del camino principal de carga mecánica.

El pulsador no mide fuerza, energía ni intensidad de impacto.

## Gateway ESP32

Coordina los cinco nodos y se comunica con Flutter. Placa, GPIO, alimentación e
interfaz App ↔ gateway siguen `TBD`.

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
