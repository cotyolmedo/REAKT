# Arquitectura REAKT

## Topología vigente

```text
Flutter (interfaz, sesiones y presentación)
          ↕ interfaz App ↔ gateway (TBD)
ESP32 central / gateway
          ↕ ESP-NOW bidireccional
  ┌───────┼────────┬────────┬────────┐
ESP32-1 ESP32-2 ESP32-3 ESP32-4 ESP32-5
  │       │        │        │        │
Pulsador NA + salida WS2812B por nodo

Flutter o servicio autorizado ↔ Supabase/PostgreSQL
```

## Responsabilidades

### Aplicación Flutter

- Configurar modos y sesiones.
- Presentar estados y resultados.
- Comunicarse con el gateway mediante una interfaz todavía `TBD`.
- Acceder a Supabase con credenciales apropiadas para cliente; nunca con claves
  privilegiadas embebidas.

### Gateway ESP32

- Recibir y validar comandos de la app.
- Coordinar hasta cinco nodos.
- Enviar órdenes y recibir eventos mediante ESP-NOW.
- Gestionar direccionamiento, duplicados, timeouts y fallos cuando el protocolo
  los defina.
- Reenviar eventos o resultados hacia la app.

### Cinco nodos ESP32

- Leer un pulsador mecánico NA con antirrebote.
- Controlar la salida visual WS2812B.
- Mantener temporización y lógica local no bloqueantes.
- Intercambiar órdenes, eventos y estado con el gateway.

### Supabase/PostgreSQL

- Persistir usuarios, sesiones, resultados e historial según un esquema futuro.
- Aplicar autenticación, autorización y RLS antes de uso productivo.

## Flujo previsto

1. La app configura una sesión y envía una orden al gateway.
2. El gateway valida y distribuye órdenes a uno o varios nodos.
3. Los nodos presentan estímulos y detectan pulsaciones.
4. Los eventos vuelven al gateway y luego a la app.
5. La app o un servicio autorizado persiste los resultados.

El reparto exacto del cálculo de métricas sigue `TBD`; no debe implementarse
antes de definir referencias temporales y latencias.

## Restricciones

- No hay Raspberry Pi en la arquitectura vigente.
- El enlace gateway ↔ nodos usa ESP-NOW.
- Todos los modos reutilizan un protocolo común.
- El firmware productivo es no bloqueante.
- El pulsador entrega una activación digital; no mide fuerza ni presión.
- La política de canal, la interfaz App ↔ gateway y la sincronización temporal
  siguen `TBD`.
- PCB y carcasa son conceptos hasta completar mediciones y validación física.

Todo cambio a esta arquitectura debe registrarse en `Docs/decisions.md`.
