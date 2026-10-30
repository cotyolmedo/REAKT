# Hoja de ruta REAKT

## Estado integrado — 23/10/2026

Puesta en marcha posterior: gatewayCOM4 y nodoCOM19 cargados y verificados;
primera sesión manual con LED/pulsador y acierto confirmada por usuario y serie.
Ver [registro del banco](banco-2026-10-23.md) para verificaciones en curso.

- App 0.3.0 y APK publicados, análisis/21 tests y firma/SHA256 verificados.
- Supabase remoto aplicado; Auth/API/RLS comprobados con transacciones revertidas.
- Firmware nodo con salida digital/WS2812B/deshabilitada y gateway compilados.
- Sincronización Android comprobada:11sesiones/11resultados/28eventos remotos;
  repetición sin duplicados confirmada por usuario.
- Pendientes: completar matriz extendida, exportación del historial, aislamiento
  con dos logins y diez sesiones físicas consecutivas completas.
- [Procedimiento actual](PROBAR-HOY.md). Las entradas inferiores conservan el historial.

## Estado histórico anterior al MVP

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

## Avance colegio 23/10/2026

- DONE: inspección de Supabase y aplicación compatible de migración aprobada;
  metadata RLS/grants verificada. Auth/sincronización real siguen IN PROGRESS.
- DONE: identificación ROM gateway COM4/MAC real; programación y radio pendientes.
- Aceptado por usuario: MVP en protoboard con pulsador y un LED. Tipo/circuito y
  adaptación para LED común pendientes; salida permanece deshabilitada.
- Trabajo aislado en .school-work/REAKT desde 6e4eec6; original preservado.
- [Detalle y pendientes](CONTINUACION-COLEGIO-2026-10-23.md).

### Cierre de etapa software

Auth confirmado, RLS remoto y API pública probados; salida LED común implementada
y compilada, gateway compilado,17tests Flutter y analyze aprobados en copia local.
MVP estimado60% por entregables (no por horas); hardware/cadena física no completados.
Sigue armado por usuario, configuración real, carga, radio, Android y diez sesiones.
[Criterio y evidencia](CIERRE-SOFTWARE-2026-10-23.md).

## 2026-10-30 — Tarjetas del equipo web V2

DONE: tarjetas ampliadas en REAKT_webv2.html, fotografía local de Chirino Olmedo
Constantino y rol indicado por el usuario. Diseño visual revisado en navegador
a ancho de escritorio y móvil. Pendiente: fotografías y roles de los otros integrantes.

### 2026-10-30 — Carrusel del equipo

DONE: carrusel horizontal con flechas y teclado; fotografía, nombre completo y
rol de Pereyra Mia Pilar incorporados. Verificación visual en escritorio y móvil.

### 2026-10-30 — Material visual del usuario

DONE: cuatro capturas Flutter en Evidencia, ampliables, y foto/rol de Palma en el
carrusel. Continúa pendiente la foto y el rol de Mendez Mia.

### 2026-10-30 — Acceso GitHub en la web

DONE: mensaje y botón dinámico hacia el repositorio público al final de Evidencia.

### 2026-10-30 — Nueva identidad visual

DONE: integración de logo/marca originales en web V1/V2 y Flutter, assets declarados
e icono Android referenciado. Web revisada en escritorio y viewport móvil; Flutter
analyze y 21 tests aprobados, inicio renderizado con nuevo logo. Pendiente: compilar
nuevo APK y verificar icono/instalación en Android físico; renovar capturas reales.

### 2026-10-30 — GitHub Pages

IN PROGRESS: Pages habilitado, workflow preparado; pendiente verificar despliegue
público en https://cotyolmedo.github.io/REAKT/.
