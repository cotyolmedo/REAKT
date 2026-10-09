# Hoja de ruta REAKT

## Estado
Arquitectura actualizada en documentación. No se presume que el hardware nuevo esté ensamblado o validado.

## Fase 0 - Documentación y repositorio
- [x] Repositorio GitHub existente.
- [x] Decisión de cinco nodos ESP32 documentada.
- [x] Decisión de pulsador NA documentada.
- [ ] Confirmar modelo exacto de placas y GPIO.
- [ ] Definir protocolo de paquetes v1.

## Fase 1 - Hardware y comunicación
- [ ] Revisar alimentación, reguladores y protección.
- [ ] Ensayar un nodo ESP32 con pulsador y WS2812B.
- [ ] Compilar firmware gateway para placa real.
- [x] Crear estructura inicial de firmware de nodos ESP32 (sin protocolo v1 ni GPIO finales).
- [ ] Verificar ESP-NOW bidireccional con uno y cinco nodos.
- [ ] Manejar pérdidas, timeouts y duplicados.

## Fase 2 - Protocolo y temporización
- [ ] Definir ID de nodo, tipo de evento y formato.
- [ ] Definir timestamps, secuencia, sincronización y latencia.
- [ ] Probar compatibilidad gateway/nodos/app.

## Fase 3 - Aplicación Flutter
- [ ] Crear estructura de app.
- [ ] Definir conexión app↔gateway.
- [ ] Control de sesiones, indicadores y resultados.

## Fase 4 - Supabase
- [ ] Modelo de datos, autenticación y políticas RLS.
- [ ] Persistencia e historial de sesiones.

## Fase 5 - Primer modo completo
- [ ] Seleccionar modo inicial y métricas medibles mediante pulsadores.
- [ ] Validar flujo extremo a extremo.

## Fase 6 - Otros modos
- [ ] Memoria, agilidad, reflejos, velocidad, resistencia, precisión y coordinación según métricas definidas.

## Fase 7 - Mecánica e integración
- [ ] Diseño CAD hexagonal y mecanismo de tapa.
- [ ] Ensayos de impacto y fijación a superficies.
- [ ] PCB, alimentación final, integración y fiabilidad.

## Fase 8 - Exhibición
- [ ] Demostración funcional, documentación de campo, esquemas, manual y evidencias.

## Fase PCB/CAD — plan V1
- [ ] Identificar y medir ESP32 «32-s kit», TP4056, tira LED y pulsador.
- [ ] Elegir celda 1S, protección y política de uso durante carga.
- [ ] Cerrar presupuesto de corriente, reguladores y conectores.
- [ ] Crear esquemático KiCad del nodo y superar ERC.
- [ ] Diseñar PCB portadora, revisar DRC y encastre 3D.
- [ ] Crear carcasa CAD paramétrica y prototipo mecánico sin batería.
- [ ] Validar prototipo de nodo con fuente limitada.
- [ ] Diseñar PCB gateway tras definir interfaz con Flutter.
- [ ] Medir autonomía, temperatura, RF e impacto antes de replicar cinco unidades.
