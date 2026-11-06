# Planes históricos de REAKT

Archivo histórico consolidado el 06/11/2026. Cada sección conserva el texto de
su documento original, incluidos estados y pendientes de esa fecha. Para operar
el sistema, consultar [la guía actual](../Docs/PROBAR-HOY.md).

## Documento 1: colegio-20261023.md

# Continuación colegio 23/10/2026

## Objective
Habilitar persistencia remota del MVP y preparar cadena física con pulsador y un LED en protoboard.
## Current state
Base exacta 6e4eec6 en worktree .school-work/REAKT, rama codex/colegio-mvp-20261023. Checkout original preservado (incluye gateway ajeno modificado).
## Requirements
Auth, RLS, sincronización idempotente; gateway identificado por usuario en COM4. LED simple permitido por usuario, sin inventar pinout.
## Constraints
No push, publicaciones, gastos ni nuevos cambios estructurales/Supabase de seguridad sin aprobación. No declarar ensayos físicos sin ejecución.
## Design
Conservar WebSocket/ESP-NOW/SQLite/Supabase existentes; adaptar únicamente salida opcional LED digital. Configuración pública local ignorada.
## Implementation steps
- [x] Leer entrega y recuperar base exacta aislada.
- [x] Inspeccionar proyecto Supabase correcto, sin objetos reakt_* conflictivos.
- [x] Aplicar migración exacta autorizada, versión remota 20261023120712.
- [x] Comprobar RLS/grants y guardar configuración pública local.
- [x] Registro Auth completado por usuario; cuenta confirmada y metadata de sesiones comprobadas. RLS remoto transaccional aprobado.
- [x] Gateway identificado por ROM y compilación Windows de ambos roles aprobada.
- [x] LED simple opcional implementado y compilado; deshabilitado hasta validación.
- [x] Analyze y17tests Flutter en copia para SDK instalado; lock oficial intacto. Evidencia documentada.
## Validation
Inspección metadata, REST, Auth, aislamiento dos usuarios si disponibles; compilación firmware y Flutter; radio y GPIO solo con placas/configuración reales.
## Documentation changes
Bitácora, testing, roadmap, decisiones y registro de colegio.
## Risks and rollback
Worktree original intacto. Migración aditiva ya aplicada; no eliminar tablas como rollback automático. Copias locales nunca contienen claves privilegiadas.
## Status
Etapa software cerrada a pedido del usuario; sigue armado de circuito. Supabase/Auth/RLS verificados con los límites de Docs/historial-entrega.md. Firmware compilado, sin grabación. Android SDK y validación física pendientes. Estimación MVP60%.


---

## Documento 2: execplan-cad-modulo-hexagonal-v1.md

# ExecPlan - CAD modulo hexagonal V1

## 1. Objective

Crear una primera estructura CAD editable del modulo periferico REAKT: carcasa hexagonal, tapa movil, guias, topes, difusor LED, placa trasera y reservas de componentes.

## 2. Current state

La documentacion vigente describe un modulo hexagonal conceptual con ESP32, pulsador NA, WS2812B, TP4056 USB-C y bateria por definir. No hay medidas fisicas validadas de componentes reales.

Archivos relevantes:

- `Docs/README.md`
- `Docs/diseno-mecanico.md`
- `Docs/pcb/componentes-dimensiones.md`
- `Docs/pcb/plan-codex.md`
- `Docs/decisions.md`

## 3. Requirements

- Mantener geometria hexagonal de 150 mm entre vertices.
- Modelar base, tapa flotante, guias, resortes/topes y difusor perimetral.
- Separar carga mecanica de PCB, bateria y pulsador.
- Representar electronica como reservas de volumen, no como footprints finales.
- Mantener el resultado editable y claramente rotulado como preliminar.

## 4. Constraints

- No inventar cotas finales ni ensayos fisicos.
- No afirmar fabricabilidad o resistencia a golpes fuertes sin pruebas.
- No ubicar PCB/bateria en el camino de carga de impacto.
- No liberar STL/STEP final sin medir componentes reales.

## 5. Design

Modelo parametrico con:

- Base hexagonal estructural.
- Tapa flotante y almohadilla reemplazable.
- Cuatro guias con resortes/topes conceptuales.
- Canal/difusor perimetral para WS2812B.
- Placa trasera para adaptadores.
- Volumenes transparentes de PCB, ESP32, TP4056, bateria candidata y pulsador.

## 6. Implementation steps

- [x] Leer documentacion mecanica/PCB disponible.
- [x] Crear fuente OpenSCAD parametrica.
- [x] Crear script Python para Fusion 360.
- [x] Documentar uso y limitaciones.
- [!] Exportar STL/STEP: bloqueado porque `openscad`, FreeCAD y Blender no estan disponibles en PATH.
- [!] Validar interferencias con piezas reales: bloqueado hasta medir componentes.

## 7. Validation

Validacion realizada:

- Revision documental contra especificaciones preliminares.
- Inspeccion de existencia de herramientas CAD por consola.

Validacion pendiente:

- Ejecutar el script en Fusion 360 y revisar cuerpos.
- Exportar STL/STEP desde Fusion u OpenSCAD.
- Imprimir mecanismo sin bateria ni electronica.
- Ensayar carrera, retorno, golpe descentrado, retencion y acceso USB-C.

## 8. Documentation changes

Se agrego `hardware/cad/modulo-hexagonal/README.md` con uso, alcance y pendientes.

## 9. Risks and rollback

Riesgos:

- Las reservas de volumen pueden no coincidir con componentes comprados.
- La abertura USB-C y ubicacion de bateria pueden cambiar al medir piezas.
- Guias, topes y resortes requieren calculo/ensayo antes de golpes fuertes.

Rollback:

- Eliminar `hardware/cad/modulo-hexagonal/` y este ExecPlan si se decide rehacer el enfoque desde otro CAD.

## 10. Status

- [x] Modelo conceptual inicial creado.
- [!] Version final fabricable bloqueada por mediciones y ensayos reales.


---

## Documento 3: gateway-base-execplan.md

﻿# Gateway Base Firmware ExecPlan

## 1. Objective

Create a small, understandable Arduino firmware base for the ESP32 gateway. It
must initialize ESP-NOW, expose non-blocking runtime hooks, and avoid defining
the still-pending REAKT packet, node identity, app transport, GPIO map, or
Supabase integration.

## 2. Current state

- The repository has ESP-NOW exploration sketches under `tests/historical/`.
- The base gateway firmware now exists under `firmware/gateway/`; physical validation is pending.
- `Docs/packet-protocol.md` keeps the packet fields and encoding as TBD.
- `Docs/hardware.md` keeps the final gateway board, GPIO map, and power design
  as TBD.

## 3. Requirements

- Target an ESP32 gateway using the Arduino IDE and ESP32 Arduino core.
- Use ESP-NOW for gateway-to-node transport.
- Keep production behavior non-blocking.
- Keep initialization, communication, app input, processing, output, and
  diagnostics visibly separated.

## 4. Constraints

- Do not hardcode node MAC addresses, Wi-Fi credentials, GPIO assignments, or
  secrets.
- Do not define a final packet format before the protocol decision.
- Do not represent unvalidated hardware behavior as complete.

## 5. Design

The sketch owns ESP-NOW initialization and transport-level reception only.
Callbacks record minimal diagnostics without interpreting payloads. The main
loop periodically reports diagnostics and contains explicit hooks for the
future app interface, packet processing, node routing, and status outputs.

## 6. Implementation steps

- [x] Add the Arduino gateway sketch under `firmware/gateway/`.
- [x] Add a local README that records scope, current limits, and validation.
- [ ] Confirm the final ESP32 board and its ESP32 Arduino core version.
- [ ] Validate ESP-NOW initialization and a one-node physical link.
- [ ] Define packet v1 and register actual node peers.

## 7. Validation

- Compile with the final ESP32 board selected in Arduino IDE.
- Confirm serial output reaches `ESP-NOW ready`.
- Perform and document a physical receive test with one ESP32 node.
- Verify malformed/empty transport input does not enter packet processing.

## 8. Documentation changes

- `firmware/gateway/README.md` describes this base and its non-final areas.
- Do not mark roadmap firmware work done before hardware validation.

## 9. Risks and rollback

- ESP-NOW behavior depends on the installed ESP32 Arduino core and radio
  channel configuration.
- The gateway cannot route production messages until packet and node-ID
  decisions are finalized.
- Rollback consists of removing only the new `firmware/gateway/` files.

## 10. Status

Base created; hardware validation and protocol integration remain pending.



---

## Documento 4: integracion-20261023.md

# Integrar el repositorio — 23/10/2026

## Objetivo
Unificar app publicada, firmware MVP y guías actuales en main, preservando fuentes
locales e historial sin publicar configuraciones privadas.

## Estado inicial
main local divergente (6 propios, 2 remotos); APK en codex/android-demo-v0.3.0;
firmware de banco en codex/colegio-mvp-20261023; app equivalente guardada también
en codex/guardar-app-local-20261023. Gateway raíz modificado con otro proyecto.

## Requisitos y restricciones
No cambiar protocolo/esquema, GPIO ni MAC. No declarar pruebas físicas realizadas.
Respaldo local del archivo ajeno; sin claves en Git. Sin force push ni borrar ramas.

## Diseño y pasos
Integrar sobre la rama Android (descendiente de origin/main), fusionar colegio,
conservar ambas bitácoras y crear PROBAR-HOY. Validar app/firmware/herramientas,
publicar rama y avanzar main normalmente. Reubicar checkout raíz en main actualizado
con respaldo previo de cambios ajenos y rama histórica local.

## Validación
Comparación de código Flutter con ambas ramas, analyze/test, compilaciones Arduino
de nodo Off/Digital y gateway, sintaxis de herramientas, diff/check y revisión de
archivos secretos excluidos. Registrar resultados en Docs/testing.md antes de cerrar.

## Documentación y riesgos
README y PROBAR-HOY son entradas actuales. Historiales conservados; respaldo
PILLDROP local con SHA256 comprobado. No publicar configuraciones privadas.

## Estado
- [x] Fusionar colegio en rama Android y conservar ambas bitácoras.
- [x] Flutter21tests/analyze, simulador2tests y tres compilaciones Arduino aprobados.
- [x] Guías/enlaces y exclusiones revisados.
- [x] Integración publicada en main2e50b0c; copia principal sincronizada y limpia.
- [x] Android CI de main aprobado (run40010186970); sin publicar otro APK.
- [x] Identificar y respaldar gatewayCOM4 y nodoCOM19 (4MB cada uno).
- [x] Gateway cargado, hashes verificados y app conectada según confirmación del usuario.
- [x] Diagnóstico MAC corregido, ambos roles cargados y hashes/arranque comprobados.
- [x] Usuario armó nodo GPIO18/23 con pulsadorNA y LED común con resistencia.
- [x] Primera sesión física: LED/pulsador/acierto observado por usuario y hit1/miss0 en serial.
- [x] Usuario confirmó mantener sin duplicados, timeout5s, stop/LED apagado e historial tras reapertura.
- [x] Serie confirmó Cancelada con objetivo desactivado y sin errores de radio registrados.
- [x] Usuario confirmó doble sincronización sin duplicados; SQL remoto:11sesiones/11resultados/28eventos, sin sesiones sin resultado.
- [x] Integración y banco básico cerrados; límites extendidos documentados en Docs/banco-2026-10-23.md.


---

## Documento 5: mvp-plan.md

# MVP REAKT — plan de ejecución

## Objective
Cadena Flutter Android → WebSocket → gateway WROOM-32 → ESP-NOW → nodo, resultados locales y sincronización Supabase.
## Current state
HEAD 840c9b3, limpio y coincidente con origin/main. Shell Flutter sin servicios, firmware opaco, sin backend ni pruebas actuales. Respaldo /workspace/backups/REAKT-before-mvp.tar.gz verificado por tar y SHA256.
## Requirements
Un nodo obligatorio, hasta dos; cinco WS2812B, pulsador NA, reloj monotónico local, ACK, duplicados, gateway coordina entrenamiento sin Internet. Auth, RLS, outbox persistente.
## Constraints
No inventar MAC. GPIO18/23 requieren habilitación explícita tras validación. No push ni migraciones remotas sin aprobación. Sin conector Supabase disponible. Flutter SDK3.29.3 instalado y validado; Supabase remoto sigue bloqueado por proxy/conector.
## Design
Biblioteca C++ portátil compartida entre ambos sketches: formato binario CRC32, ACK y stop-and-wait, motor de rondas. SoftAP de gateway en canal fijo, peers explícitos; comandos JSON/WebSocket y snapshots con eventos identificados. Flutter conserva snapshots completos y sincroniza por upsert autenticado. SQL aislado preparado para aprobación.
## Implementation steps
- [x] Contrato, biblioteca y pruebas nativas aprobadas.
- [x] Nodo y gateway implementados y compilados con Arduino-ESP32 2.0.17; configuración de hardware deshabilitada por defecto.
- [x] Flutter: transporte, outbox, Auth y UI implementados; SDK impide verificación.
- [x] SQL preparado y probado en PostgreSQL local; documentación y matriz física.
- [x] Compilaciones ESP32 y tests nativos/WebSocket/SQL disponibles ejecutados.
- [x] Flutter SDK3.29.3/Dart3.7.2 instalado; lock resuelto, analyze y17tests aprobados.
- [x] APK Android debug compilado con JDK17/NDK27 y firma verificada; físico pendiente.
- [!] Supabase remoto: aprobación recibida tras inspección sin conflictos, conector no disponible.
- [!] Pruebas físicas: sin acceso a placas; usuario sin LEDs/fuente.
## Validation
Pruebas C++ de serialización, CRC, duplicados, reintentos, debounce, reloj y resultados. Compilar ESP32 con PlatformIO si egress permite toolchain. Flutter analyze/test/build si SDK disponible. Matriz física diez sesiones, sin simular evidencia.
## Documentation changes
Protocolo, arquitectura, ADR, instalación, pinout, pruebas, bitácora y aprobación SQL.
## Risks and rollback
Radio sin cifrar (banco aislado), desconexiones y energía WS2812B. Mantener respaldo completo; no borrar evidencia histórica. Migración remota pendiente, no aplicada.
## Status
Implementación local preparada; dos builds ESP32 y pruebas disponibles aprobadas. No se declara integración completa. Análisis/tests Flutter aprobados. Validaciones remotas y físicas bloqueadas; build APK registrado en el estado final. Aprobación de migración recibida de forma condicional, sin aplicación remota. Ver Docs/implementation-log.md y Docs/testing.md.


---

## Documento 6: repository-audit-action-plan.md

# Plan de saneamiento posterior a la auditoría

## 1. Objetivo

Dejar una única estructura canónica, coherente con la arquitectura vigente, sin
perder evidencia histórica ni presentar decisiones o pruebas pendientes como
resueltas.

## 2. Estado inicial

- `Docs1/` y `firmware1/` contenían una actualización paralela no integrada.
- `Docs/` y `firmware/` seguían describiendo parcialmente ESP32-C3/piezo.
- Había un lock de KiCad y bytecode Python rastreados.
- Faltaba `.gitignore` y un README principal.
- La actualización paralela incluía referencias a sus propias rutas, ADR
  duplicados y GPIO provisionales no respaldados por una placa confirmada.

## 3. Requisitos

- Conservar `tests/historical/` históricos.
- Integrar firmware no bloqueante de gateway y nodos.
- Mantener placa, GPIO, MAC, protocolo, alimentación e interfaz de app como
  `TBD` cuando corresponda.
- Mantener documentación escolar, app y backend ya existentes.

## 4. Restricciones

- No inventar validación física, ERC/DRC, métricas ni credenciales.
- No fabricar ni cerrar PCB/CAD sin piezas medidas.
- No hacer commit ni push automáticamente.

## 5. Diseño

`Docs/` y `firmware/` son las únicas rutas vigentes. `tests/historical/` conserva los
ensayos anteriores. Los artefactos de ingeniería preliminar viven bajo
`Docs/pcb/` y `hardware/`, claramente etiquetados como conceptuales.

## 6. Implementación

- [x] Integrar los documentos únicos de `Docs1/` en `Docs/`.
- [x] Reconciliar arquitectura, hardware, protocolo, roadmap y pruebas.
- [x] Integrar el firmware de nodo y mejorar la cola del gateway.
- [x] Corregir referencias `Docs1/`/`firmware1/` y numeración ADR.
- [x] Quitar GPIO no confirmados de la documentación vigente.
- [x] Eliminar carpetas paralelas y artefactos generados rastreados.
- [x] Añadir README principal y `.gitignore`.
- [x] Ejecutar verificaciones disponibles y registrar limitaciones.

## 7. Validación

- `git diff --check`.
- Búsqueda de referencias obsoletas, credenciales y `delay()` productivo.
- Revisión de enlaces locales Markdown.
- `flutter analyze` si la herramienta responde.
- Compilación Arduino y DRC solo si están disponibles las CLI y el destino real.

## 8. Documentación

Se actualizan `Docs/decisions.md`, `Docs/roadmap.md` y `Docs/testing.md` junto a
los archivos de arquitectura afectados.

## 9. Riesgos y reversión

El mayor riesgo es perder información útil al retirar las copias paralelas. Se
mitiga integrando primero archivos únicos y conservando requisitos, app/backend,
ensayos y artefactos de ingeniería. Antes de un commit, Git permite revisar o
restaurar cada cambio por archivo.

## 10. Estado

Implementación completada. `git diff --check`, referencias y enlaces locales se
verificaron el 2026-10-10. Flutter agotó el tiempo sin producir salida; Arduino
CLI y KiCad CLI no están instalados. Las validaciones dependientes de toolchains
o hardware quedan pendientes, no se declaran exitosas ni se interpretan como
fallas del diseño.
