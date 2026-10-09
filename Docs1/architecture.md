# Arquitectura REAKT

## Topología vigente
```text
Flutter (interfaz, sesiones, métricas)
          ↕ interfaz App↔Gateway (TBD)
ESP32 central / gateway
          ↕ ESP-NOW bidireccional
  ┌───────┼────────┬────────┬────────┐
ESP32-1 ESP32-2 ESP32-3 ESP32-4 ESP32-5
  │       │        │        │        │
Pulsador NA + iluminación WS2812B por nodo

Flutter/servicios autorizados ↔ Supabase/PostgreSQL
```

## Responsabilidades
- **App Flutter:** configuración de modos/sesiones, presentación, resultados, conexión al gateway y persistencia mediante servicios autorizados.
- **Gateway ESP32:** coordinar nodos, transmitir órdenes ESP-NOW, recibir eventos, validar, deduplicar y retransmitir datos hacia la app. La interfaz app↔gateway sigue TBD.
- **Cinco nodos ESP32:** leer pulsador mecánico, detectar eventos con antirrebote, controlar WS2812B, medir tiempo local y comunicarse por ESP-NOW.
- **Supabase/PostgreSQL:** persistir datos de sesiones, resultados y usuarios según esquema futuro.

## Flujo de entrenamiento
1. La app configura la sesión y envía órdenes al gateway.
2. El gateway transmite órdenes a uno o varios nodos.
3. Los nodos presentan estímulos luminosos y detectan accionamientos.
4. Cada nodo comunica eventos al gateway; la app calcula o presenta resultados según el reparto de responsabilidades que se acuerde.
5. La aplicación guarda los resultados autorizados en el backend.

## Restricciones
- No Raspberry Pi en la arquitectura vigente.
- ESP-NOW entre gateway y nodos; política de canal y coexistencia Wi-Fi: TBD.
- Un protocolo común a todos los modos.
- Los pulsadores no miden fuerza ni intensidad del golpe.
- El diseño mecánico hexagonal se documentará por separado cuando esté validado.
- No se consideran completadas las funciones que todavía no tienen implementación o ensayos.

## Diseño físico y PCB V1
Cinco nodos ESP32 con PCB portadora, batería 1S por definir, TP4056 USB-C y accionamiento mecánico NA. Gateway ESP32 con PCB distinta y transporte app↔gateway aún por seleccionar. Ver `Docs/pcb/README.md` y `Docs/diseno-mecanico.md`. Esta sección es arquitectura **propuesta**, no hardware fabricado.
