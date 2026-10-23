# REAKT

Proyecto integrador de electrónica de la E.E.S.T. N.º 4 orientado a módulos de
entrenamiento interactivo.

## Arquitectura vigente

```text
Flutter ↔ gateway ESP32 ↔ cinco nodos ESP32 (ESP-NOW)
   ↕
Supabase/PostgreSQL
```

Cada nodo prevé un pulsador mecánico normalmente abierto como entrada y uno o
más WS2812B como salida visual. El modelo exacto de placa, los GPIO, la
alimentación, la interfaz App ↔ gateway y el protocolo v1 continúan por definir.

## Estado real

- La app Flutter tiene una estructura y una interfaz inicial de demostración.
- El gateway tiene una base de transporte ESP-NOW no bloqueante.
- Los nodos tienen una base de firmware con antirrebote y estados, deshabilitada
  en hardware hasta definir GPIO reales.
- PCB y carcasa son prototipos conceptuales, no diseños listos para fabricar.
- Las pruebas históricas con ESP32-C3 y piezoeléctricos se conservan únicamente
  como evidencia del proceso anterior.

No hay todavía una integración completa App ↔ gateway ↔ nodos ↔ Supabase ni
validación física del diseño vigente.

## Estructura

- [`Docs/`](Docs/README.md): arquitectura, requisitos, decisiones y pruebas.
- [`firmware/gateway/`](firmware/gateway/README.md): firmware del coordinador.
- [`firmware/nodes/`](firmware/nodes/README.md): firmware común de los nodos.
- [`app/`](app/README.md): aplicación Flutter.
- [`hardware/`](hardware/): PCB y CAD conceptuales.
- [`Tests/`](Tests/): ensayos históricos y futura evidencia verificable.
- [`.agent/`](.agent/PLANS.md): planes de ejecución para cambios extensos.

## Antes de trabajar

Leer [`AGENTS.md`](AGENTS.md) y [`Docs/README.md`](Docs/README.md). No fijar MAC,
GPIO, credenciales, métricas ni resultados de pruebas sin evidencia. Los
cambios de arquitectura deben registrarse en `Docs/decisions.md`.

## Próximos bloqueos

1. Identificar y medir las placas y componentes reales.
2. Confirmar con docentes si el pulsador satisface el requisito de sensor.
3. Definir protocolo v1 e interfaz App ↔ gateway.
4. Compilar para la placa seleccionada y validar un enlace ESP-NOW con un nodo.
5. Diseñar y verificar alimentación antes de fabricar o instalar baterías.
