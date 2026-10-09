# REAKT - Registro de decisiones (ADR)

## ADR-001 - Gateway central
Fecha: 2026. Estado: Aceptada.

Un ESP32 actúa como gateway entre Flutter y cinco nodos de entrenamiento. La tecnología de los nodos se actualizó en ADR-005.

## ADR-002 - Comunicación de nodos
Fecha: 2026. Estado: Aceptada.

ESP-NOW bidireccional entre gateway y nodos; canal, direccionamiento y recuperación ante errores todavía TBD.

## ADR-003 - Backend
Fecha: 2026. Estado: Aceptada.

Supabase/PostgreSQL como backend persistente previsto. No se define aún esquema definitivo.

## ADR-004 - Protocolo común
Fecha: 2026. Estado: Aceptada.

Usar una arquitectura de paquetes compartida por todos los modos; codificación y campos definitivos TBD.

## ADR-005 - Sustitución de ESP32-C3
Fecha: 2026-10-08. Estado: Aceptada.

**Contexto:** se revisó la plataforma de los cinco nodos.

**Decisión:** utilizar cinco ESP32 en lugar de cinco ESP32-C3. El gateway continúa siendo ESP32.

**Consecuencias:** revisar pinout, consumo, dimensiones, alimentación, compatibilidad del firmware y pruebas ESP-NOW. No trasladar directamente los GPIO de ensayos anteriores.

**Validación:** compilar para las placas reales y ensayar un nodo, luego cinco nodos.

## ADR-006 - Sustitución del piezoeléctrico
Fecha: 2026-10-08. Estado: Aceptada.

**Contexto:** se requiere detectar accionamientos del módulo de impacto de forma binaria.

**Decisión:** sustituir el piezoeléctrico por un pulsador mecánico normalmente abierto accionado por la tapa. El modelo y mecanismo físico siguen TBD.

**Consecuencias:** entrada digital, antirrebote, medición temporal de eventos y rediseño mecánico. Se pierde la posibilidad de estimar intensidad de golpe a partir de una señal analógica; no atribuir esta métrica al pulsador.

**Validación:** ensayar falsos positivos, doble conteo, latencia, recuperación, golpes fuera de centro y vida útil.

## ADR-007 - Concepto de carcasa hexagonal
Fecha: 2026-10-08. Estado: Propuesta conceptual, no diseño validado.

Carcasa hexagonal negra con tapa móvil amortiguada, iluminación perimetral y montaje intercambiable. Las cotas, materiales, resortes, topes y anclajes se definirán en un documento mecánico independiente.

## ADR-007 — PCB portadora de nodos y gateway separado
**Fecha:** 2026-10-08. **Estado:** aceptada como estrategia de prototipado.
**Decisión:** carrier PCB para ESP32 DevKit de cada nodo; gateway con placa separada. No integrar módulo ESP32 desnudo hasta validar prototipo. **Consecuencias:** más volumen, mayor reparabilidad y menos riesgo inicial. **Validación:** medidas reales, ERC/DRC, integración CAD.

## ADR-008 — Alimentación 1S con diseño pendiente
**Fecha:** 2026-10-08. **Estado:** propuesta, **no cerrada**.
**Decisión:** evaluar batería 1S con cargador TP4056 USB-C; definir protección, regulación 3V3/5V y política de uso durante carga antes de fabricar. **No** afirmar que TP4056 resuelve power-path. **Validación:** medición de picos, temperatura y carga.

## ADR-009 — PCB aislada de cargas de impacto
**Fecha:** 2026-10-08. **Estado:** aceptada.
**Decisión:** pulsador sujeto al bastidor, tapa guiada con topes estructurales; placa y celda fuera del camino de fuerzas. **Validación:** pruebas mecánicas progresivas y continuidad eléctrica.
