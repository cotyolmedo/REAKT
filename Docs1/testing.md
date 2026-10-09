# Estrategia de pruebas REAKT

## Criterio
Avanzar desde componentes aislados hacia la integración. Ninguna prueba se considera aprobada sin evidencia registrada.

## 1. ESP32 ↔ ESP32 (ESP-NOW)
- Inicialización y registro de peers.
- Envío y recepción en ambos sentidos.
- Prueba con un nodo y después con cinco.
- Paquetes inválidos, duplicados, fuera de orden, pérdidas y timeouts.
- Convivencia del enlace gateway↔app con ESP-NOW, incluida política de canal.

## 2. Pulsador NA
- Reposo abierto y cierre correcto; polaridad lógica documentada.
- Detección de un solo evento por pulsación.
- Antirrebote, liberación y rearme.
- Pulsaciones rápidas, prolongadas y golpes fuera de centro.
- Falsos disparos por vibración.
- Medición y registro del criterio de timestamp.

## 3. WS2812B
- Estados objetivo, acierto, error y espera.
- Alimentación, brillo y consumo máximo medidos.
- Sin interferencia funcional con adquisición o ESP-NOW.

## 4. Alimentación
- Tensiones bajo carga y picos de LED/Wi-Fi.
- Protección de celda, corriente de carga y comportamiento ante batería baja.
- Funcionamiento durante carga solo si se diseña y verifica power-path apropiado.

## 5. Mecánica (pendiente de definición)
- Recorrido, topes, retorno, accionamiento, resistencia y fijación segura a pared/superficie.
- No ensayar golpes fuertes con batería instalada hasta validar estructura y seguridad.

## 6. Integración
```text
Flutter → ESP32 gateway → ESP32 nodo (LED)
Flutter ← ESP32 gateway ← ESP32 nodo (pulsador)
Flutter ↔ Supabase/PostgreSQL
```

## Evidencia por ensayo
Registrar fecha, versión de firmware, placas, conexiones, método, resultado esperado, resultado real, errores y fotos/video si corresponde.

Los sketches antiguos ESP32-C3/piezo son antecedentes, no validaciones del diseño actual.

## Verificación electrónica/PCB y mecánica
Consultar `Docs/pcb/verificacion-pcb.md` y `Docs/diseno-mecanico.md`. Los nuevos nodos son ESP32, no ESP32-C3. El TP4056 y la batería exigen validación eléctrica/ térmica específica. Ningún ensayo físico se declara completado.
