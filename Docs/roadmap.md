# Hoja de ruta REAKT

## Estado actual

Fase inicial e incremental. Hay documentación, una interfaz Flutter de
demostración, bases de firmware y artefactos PCB/CAD conceptuales. No existe aún
un sistema integrado ni hardware vigente validado.

## Fase 0 — Repositorio y documentación

- [x] Repositorio GitHub.
- [x] Instrucciones de repositorio en `AGENTS.md`.
- [x] Arquitectura vigente documentada.
- [x] Cambio a cinco nodos ESP32 y pulsador NA documentado.
- [x] Estructura duplicada consolidada en `Docs/` y `firmware/`.
- [ ] Confirmar modelo exacto de placas, piezas y GPIO.
- [ ] Confirmar con docentes si el pulsador cumple el requisito de sensor.
- [ ] Finalizar protocolo v1 e interfaz App ↔ gateway.

## Fase 1 — Gateway y nodos

- [x] Base de firmware del gateway.
- [x] Base de firmware común de nodo, con hardware deshabilitado mientras el
  pinout sea `TBD`.
- [ ] Compilar ambos sketches para la placa real y registrar el core.
- [ ] Probar ESP-NOW bidireccional con un nodo.
- [ ] Extender a cinco nodos.
- [ ] Implementar y verificar pérdidas, timeouts, duplicados y recuperación.
- [ ] Integrar pulsador y WS2812B tras cerrar esquemático y alimentación.

## Fase 2 — Protocolo y temporización

- [ ] Definir versión, tipos, IDs, tamaños y serialización.
- [ ] Definir secuencia, ACK/reintentos y deduplicación.
- [ ] Definir referencia temporal, sincronización y latencia.
- [ ] Probar compatibilidad gateway ↔ nodos ↔ app.

## Fase 3 — Flutter

- [x] Estructura de proyecto.
- [x] Interfaz inicial con datos de demostración.
- [ ] Validar `flutter analyze`, pruebas y renderizado en dispositivos.
- [ ] Definir e implementar conexión con el gateway.
- [ ] Enviar comandos, recibir eventos y mostrar resultados reales.
- [ ] Manejar desconexión y datos inválidos.

## Fase 4 — Supabase

- [ ] Diseñar esquema y migraciones.
- [ ] Definir autenticación y políticas RLS.
- [ ] Persistir e historizar sesiones y resultados.
- [ ] Probar autorización, restricciones y errores.

## Fase 5 — Primer modo completo

- [ ] Elegir explícitamente un modo y métricas compatibles con entrada binaria.
- [ ] Implementar el flujo App → gateway → nodo → gateway → App → Supabase.
- [ ] Validar el modo extremo a extremo con evidencia.

## Fase 6 — Modos restantes

- [ ] Reutilizar la infraestructura global para los modos aprobados.
- [ ] Validar comportamiento y métricas de cada modo.

## Fase 7 — Mecánica, PCB e integración

- [x] Carrier PCB V0.1 editable y conceptual.
- [x] Modelo CAD conceptual editable.
- [ ] Medir ESP32, cargador, batería, conectores, pulsador y LED reales.
- [ ] Cerrar batería, protección, regulación y *power-path*.
- [ ] Crear esquemático y superar ERC.
- [ ] Cerrar footprints, ruteo, DRC, Gerbers y encastre 3D.
- [ ] Probar primero un módulo sin batería y con fuente limitada.
- [ ] Validar autonomía, temperatura, RF, mecanismo y fijación.
- [ ] Replicar cinco unidades solo tras validar el prototipo.

## Fase 8 — Exhibición

- [ ] Demostración funcional y plan de contingencia.
- [ ] Documentación de campo, esquemático final y manual.
- [ ] Evidencia fotográfica/audiovisual real.
- [ ] Código respaldado y materiales de presentación.

## Actualización MVP — 2026-10-22

- IMPLEMENTADO/COMPILADO: firmware gateway/nodo, contrato común y salidas opcionales.
- PROBADO: componentes C++/simulación, simulador WebSocket y SQL/RLS local aislado.
- IMPLEMENTADO, validación BLOQUEADA: Flutter Android/SQLite/Auth/sync; SDK inaccesible.
- BLOQUEADO: Supabase remoto sin conector; migración autorizada tras inspección sin conflictos.
- PENDIENTE DE HARDWARE: radio/pulsador; LEDs/fuente no disponibles.
- Meta física aún pendiente: diez sesiones consecutivas, uno o dos nodos según placas.
- No incluir segundo nodo/modos extra antes de cerrar integración básica en escuela.

### Continuación de preparación para el colegio

Flutter dejó de estar bloqueado: SDK/lock instalados, análisis y17tests aprobados.
Panel de banco Chromium probado y exportación de historial agregada. Build APK y
artefactos finales en ESTADO-FINAL-MVP.md; Supabase y pruebas físicas siguen separados.
