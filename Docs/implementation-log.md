# Bitácora de implementación MVP

Fecha de trabajo: **2026-10-22**, zona del usuario America/Argentina/Buenos_Aires.
Fecha objetivo: **2026-11-06**. Estados: IMPLEMENTADO (escrito), COMPILADO (build
exitoso), PROBADO (check ejecutado), PENDIENTE DE HARDWARE, BLOQUEADO (externo).

## 1. Inspección y respaldo

- Leídos AGENTS.md, Docs/README.md, desarrollo, arquitectura, decisiones, backend,
  protocolo, testing y READMEs de firmware/app. Detectado shell Flutter, bases
  firmware sin protocolo y ensayos históricos. No se borraron carpetas históricas.
- `git status --short` limpio al inicio. `git ls-remote origin refs/heads/main`
  coincide con HEAD `840c9b30bd9f1d3e5496ddac2a06956cbe06e3a9`.
- Respaldo recuperable antes de cambios: `/workspace/backups/REAKT-before-mvp.tar.gz`;
  `tar -tzf` correcto; SHA256
  `f78369747a8e0e5e10f4486661780e22799b6ccfbfdcd4110a2306af445a65db`.
  No contiene .git; metadatos Git existentes se conservaron sin cambios.
- Plan en `.agent/mvp-plan.md`. No commits, push ni merge.

## 2. Protocolo y núcleo portátil — IMPLEMENTADO / PROBADO

- `firmware/libraries/ReaktCore/`: serialización LE de32bytes, CRC32, validación,
  dedup por secuencia, ACK/reintentos120ms x8, antirrebote20ms, reloj de estímulo y
  métricas. `tests/core_test.cpp`, `tests/link_sim_test.cpp`, `tools/test-core.sh`.
- `./tools/test-core.sh` pasa con GCC nativo, -Wall/-Wextra/-Werror y ASan/UBSan.
  CRC de referencia, corrupción en cada byte, rango/longitud, ACK erróneo, pérdida,
  duplicación, wrap millis, pulsación mantenida y límite exacto de reacción.
- Diez sesiones sintéticas x diez rondas, pérdida de comandos/eventos/ACKs y sin
  doble conteo. Es simulación de componentes, NO diez sesiones físicas ni ejecución
  de loops Arduino sobre una radio real.

## 3. Firmware — IMPLEMENTADO / COMPILADO

- Reemplazadas bases `.ino`; agregados Config.h y ejemplos LocalConfig por rol,
  wrappers PlatformIO, platformio.ini y compilador cloud.
- Gateway: AP canal6, WebSocket81, pares MAC explícitos, rondas aleatorias,
  resultados/diagnósticos, snapshots completos, interrupción por pérdida persistente.
- Nodo: cola protegida, debounce, ACK/dedup, tiempo monotónico tras estímulo,
  WS2812B opcionales, protección frente a sesiones retiradas, backpressure de evento.
- Usuario confirmó **solo placas y pulsador**; LEDs deshabilitados por defecto.
  GPIO18/23 propuestas; hardware no habilitado sin validación y MAC reales.
- PlatformIO6.2.0 instalado, `pio run -j 2` falló al descargar registry: HTTP403
  de api.registry.platformio.org y dl.registry.platformio.org. No se repitió sin diagnóstico.
- Alternativa oficial: Arduino CLI1.2.2, core Espressif2.0.17 y GCC Xtensa8.4.0,
  descargados desde releases oficiales GitHub. Verificados SHA256 del índice oficial;
  ctags SHA512 y CLI contra checksums oficiales. Se mantuvo TLS/verificaciones.
- Primer build falló por Python sin pyserial, luego ctags faltante; instalados en
  virtualenv y herramienta oficial. WebSockets2.6.1 requiere String lvalue para
  sendTXT/broadcastTXT: corregido y compilación repetida satisfactoriamente.
- `tools/compile-firmware-cloud.sh`: builds nodo/gateway exitosos para ESP32 Dev
  Module, core2.0.17, dos jobs. Variante con LED_ENABLED=1/NODE_ID=2 también compiló.
  Imágenes bajo build/ son de banco y no configuran MAC reales.
- Revisión posterior: radio descarta frames corruptos sin recursión; gateway valida
  rondas y valores; pares no objetivo reciben Cancel de la ronda para registrar
  anticipaciones. Se repite build tras esos cambios.
- **PENDIENTE DE HARDWARE:** carga, radio, GPIO, estímulo, electricidad y diez sesiones.

## 4. Flutter y Android — IMPLEMENTADO / BLOQUEADO EN VALIDACIÓN

- `app/lib/main.dart` sustituye demo con entrenamiento, diagnóstico, Auth e historial.
  `services/`: contrato validado, WebSocket con watchdog/reconexión1..16s, SQLite
  transaccional, propietario estable y ACK de payload para sincronización diferida.
- `SessionRemote`, `SupabaseRemote`, `MemorySessionRemote`: repositorio real
  autenticado y simulado para pruebas de nube caída y escritura parcial.
- La app conserva funcionamiento local si Supabase no está configurado o falla al
  inicializar. Solo sincroniza estados terminales; nunca inventa cierre tras reboot.
- Android: Kotlin/MainActivity, manifest/permisos, cleartext limitado a AP y pruebas
  locales, Gradle wrapper8.10.2 con checksum de distribución; backup deshabilitado.
- SDK mínimo corregido a Dart3.7 tras consultar metadatos oficiales de sqflite2.4.2.
  Referencia Flutter3.29.3 en .fvmrc. No hay lock resuelto ni APK.
- Descarga SDK oficial storage.googleapis.com: proxy HTTP403; flutter/dart no
  instalados. **No ejecutados:** pub get, analyze, los diez tests Dart y build APK.
- Parser sintáctico tree-sitter para siete archivos Dart nuevos y XML Android:
  correcto. No sustituye analyzer ni build. La demo inicial tenía cierres faltantes
  y quedó conservada en respaldo/Git; no se mantiene duplicada dentro de lib/.
- Tests escritos de contrato (5), SQLite/reinicio/propietario/reintentos (5).
  **Sin ejecutar** por SDK. El remoto en memoria solo se usa en tests, no suplanta Auth.

## 5. Simulador WebSocket — IMPLEMENTADO / PROBADO

- `tools/mock_gateway.py` y `tests/test_mock_gateway.py`.
- `python3 tests/test_mock_gateway.py`: 2 pruebas aprobadas (completar/reconectar/
  repetir ID y rechazar configuración/cancelar). Datos marcados como simulación.
  No valida Flutter ni ESP-NOW. Se repitió tras ajustar UUID estándar; ambos casos volvieron a aprobar.

## 6. Supabase — SQL PROBADO LOCALMENTE / REMOTO BLOQUEADO

- `backend/migrations/20261022_001_reakt_mvp.sql`: tres tablas reakt_* con FK,
  constraints, índices y nueve políticas RLS. Sin modificaciones a datos existentes.
- `tests/test_backend.py` ejecuta PostgreSQL efímero con shim local de auth.uid().
  Diez pruebas aprobadas: upsert, aislamiento, anon, no DELETE, reasignación,
  relación padre/hijo, eventos/resultados y rangos. No es prueba del servicio Supabase.
- Conector Supabase buscado al inicio y nuevamente tras aprobación: sin herramientas
  disponibles. No hay variables Supabase/Android/Flutter inyectadas por nombre.
  No se solicitaron secretos por chat ni se consultó/modificó proyecto remoto.
- Presentado cambio, justificación, recursos, riesgos, alternativa SQLite y efecto
  de no aplicar en backend/README.md y pregunta de aprobación.
- **Aprobación recibida:** “Autorizo aplicar tras inspección, si no hay conflictos”.
  Persistida; no volver a pedir para este mismo cambio. Ejecución bloqueada por acceso
  al proyecto correcto. Conflictos exigirían adaptar/revisar; no asumir compatibilidad.
- Pendiente: inspeccionar reakt, aplicar solo si compatible, crear usuario de pruebas
  mediante Auth seguro y verificar RLS/sincronización reales. Sin claves inventadas.

## 7. Documentación y cierre

- Actualizados README, arquitectura, protocolo, decisiones y READMEs por rol.
- Agregados instalación/pinout propuesto, matriz física, informe escolar y bitácora.
- Protegidos LocalConfig.h y salidas generadas; ningún secreto creado ni impreso.
- Verificaciones finales y tamaños de binarios se registran en Docs/testing.md.
- Fuera de alcance físico actual: LEDs/fuente/nivel lógico y medición humana.
- Bloqueos externos reales: SDK Flutter por egress, acceso Supabase, componentes y
  acceso a placas. No se declara sistema integrado probado ni listo para exhibición.

## 8. Continuación solicitada: acceso remoto y preparación del colegio

- Usuario reiteró implementar todo lo posible y preparar documentos para el viernes
  23/10/2026. Releídos estado Git y pendientes; cambios locales anteriores preservados.
- Conector Supabase buscado nuevamente: cero herramientas disponibles. Variable names
  de conexión revisadas sin valores: ninguna Supabase/PostgreSQL presente.
- Usuario aportó URL pública `https://hvaoezcsgqepcttaznof.supabase.co`.
  GET Auth health y REST root: proxy CONNECT403, HTTP000 del servicio. No hubo
  autenticación ni SQL remoto. No se interpreta como fallo de la base de datos.
- Guardado en draft dominio exacto del proyecto y requisito no secreto SUPABASE_URL,
  preservando storage.googleapis.com. Guardar no aplica ni publica. Aprobación previa
  de migración sigue vigente tras inspección sin conflictos; no se pidió de nuevo.
- `backend/inspect-readonly.sql`: metadata sin filas de usuarios ni credenciales.
  Once pruebas PostgreSQL locales aprobadas incluyendo ejecución de esta inspección.
- Flutter host cambió de403 a404 en metadata/archivo consultados. Corrección: clone
  oficial tag3.29.3, enginecf56914b32 y Dart3.7.2 mediante herramientas oficiales.
  Descarga de SDK y pub get exitosas; lock resuelto incluido para reproducibilidad.
- Fallos de rutas de estado en HOME de solo lectura: se usaron XDG_CONFIG_HOME y
  ANALYZER_STATE_LOCATION_OVERRIDE soportados, sin reasignar HOME. Dart formatter
  con --suppress-analytics. `tools/cloud-env.sh` conserva inicialización cloud.
- Primer test Flutter: cinco casos de contrato pasaron; ocho dependientes de SQLite
  fallaron porque faltaba soname libsqlite3.so. Usada biblioteca del sistema .so.0
  mediante enlace local y ruta de carga, sin reemplazar librería ni desactivar checks.
- Mejoras GatewayLink: detener no depende de guardar en disco; una orden esperando
  SQLite no puede enviarse a una conexión reemplazada. Tres nuevos tests con servidor
  WebSocket real validan persistencia antes de enviar y estos fallos.
- Tests widget de pantalla offline y UI→WebSocket→SQLite. Se corrigió el harness de
  pruebas para alternar microtasks de Flutter fake clock e IO real; no se desactivaron
  expectativas ni cambió código productivo para simular resultados aprobados.
- Resultado: **15 tests Flutter aprobados** y `flutter analyze`: **No issues found**.
  El servidor del test entrega datos sintéticos; todavía no prueba gateway física.
- Panel `tools/web-diagnostics/index.html`: cliente del mismo contrato, localStorage,
  reconexión y exportación JSON. Prueba Chromium/Playwright pasó manual, métrica,
  persistencia tras reload y descarga de JSON, sin errores JavaScript. No sincroniza nube.
- Android SDK command-line tools19.0 verificados contra checksum del repositorio
  oficial; instalados SDK35/build-tools35/platform-tools y componentes que exige AGP.
- Gradle no usaba proxy: configurado host/puerto sin credenciales en configuración
  local externa al checkout, conservando TLS. Build detectó JRE21 sin javac: instalado
  JDK17 completo Temurin17.0.14+7 con SHA256 oficial verificado y truststore del sistema.
- Plugins requirieron NDK27.0.12077973 frente al26.3 de Flutter: versión explicitada
  en Gradle. Build final/APK se registran en ESTADO-FINAL-MVP.md y testing.md.
- Documentos nuevos: GUIA-COLEGIO-2026-10-23.md, registro-pruebas-colegio.md y
  ESTADO-FINAL-MVP.md. Se preparó exportador ZIP del árbol actual, incluyendo cambios
  sin commit, excluyendo archivos ignorados/configuración local/credenciales, con
  verificación de cada SHA256 y de la integridad del ZIP. No se hizo push.

### Respaldo de la app y verificación final

- Agregado `LocalStore.exportJson()` y botón **Copiar historial JSON** mediante
  Clipboard, sin credenciales Auth. Exportación legible, no importación automática.
- Test nuevo conserva snapshot pendiente, propietario y métricas exportadas.
  Suite completa: **16 tests Flutter aprobados**; analyze sin errores.
- APK inicial compiló con JDK17. Se repite build final tras exportación y pin NDK27.
  SDKManager falló al descargar NDK27; se usa archivo oficial con checksum del índice
  Android, sin desactivar verificación. Estado incompleto del instalador se preserva.

### APK final y entregables

- Build final `flutter build apk --debug --no-pub`: exit0, NDK27,18.1s reutilizando
  cachés. Incluye exportación JSON. `apksigner verify --verbose` aprobó firma v1/v2;
  aapt verificó paquete ar.edu.reakt, minSdk23, target35 y cuatro ABI.
- APK final:208433007bytes; SHA256 `a6323ae514e46d27e13106dffe703a009d2159fd30004020a200bd851bdb3201`.
- No contiene configuración/credenciales Supabase, no fue instalado en teléfono.
- Se guardaron install_script (pub get con lock) y start_skill actualizados en el
  draft. Persistencia confirmada; no aplican cambios ni publican ni prueban restauración.
- La publicación del entorno y la aplicación de política de red quedan del lado
  de configuración del usuario; no se hizo push/merge ni SQL remoto.

### Reconexión automática y paquete exportado

- Test adicional corta el WebSocket real, verifica reconexión automática y recuperación
  del mismo snapshot sin duplicar sesión SQLite. Suite final: **17 tests aprobados**,
  analyze sin errores. No es prueba de radio/gateway física.
- ZIP verificado con351archivos fuente, permisos de ejecución conservados, manifest
  SHA256 por archivo y checksum externo. APK y checksum se entregan por separado.
- Enlaces Markdown locales comprobados sin roturas; git diff --check aprobado.

## 9. Publicación solicitada por el usuario

- Autorización explícita para commit/push con mensaje exacto:
  `Cambios mayores, progreso considerable`.
- Base local y origin/main coinciden en840c9b3; trabajo local en rama work.
  Se publicará HEAD a main mediante avance rápido normal, sin force push.
- Agregados RESUMEN-ENTREGA.md y PROMPT-PARA-MANANA.md; actualizadas indicaciones
  para obtener el código desde GitHub. Conservado el historial de bloqueos anteriores.
- Se excluyen SDKs, APK/builds y configuración local de Git. Verificación de push
  mediante comparación del HEAD local con ls-remote después de publicarlo.

### Revisión previa al commit

- Detectadas cachés CMake `.cxx` anidadas bajo android/app: corregida regla de
  exclusión y retiradas del índice sin borrarlas del disco. ZIP regenerado con
  código/documentación, sin cachés de compilación. No había credenciales en esos archivos.
- Revisión de los80archivos de entrega: sin configuraciones locales, APK, claves
  privadas ni patrones de tokens. git diff --cached --check aprobado.
- El usuario autorizó esta publicación; los siguientes cambios no adquieren permiso
  automático para push. El prompt conserva esta distinción.

## 10. Colegio 23/10/2026

Migración Supabase autorizada aplicada tras inspección compatible (versión remota
20261023120712); metadata RLS/grants verificada. Gateway COM4 identificado por ROM,
MAC 30:c6:f7:92:d0:9c, ESP32-D0WDQ6. No flash ni prueba radio. Configuración pública
local ignorada y formulario Auth preparados. Registro/login requieren usuario.
Detalle de comandos, bloqueos y alcance: [continuación](CONTINUACION-COLEGIO-2026-10-23.md).

### Etapa software cerrada antes del armado

Usuario completó registro; cuenta confirmada en servidor. Pruebas RLS reales con
rol authenticated aprobadas y revertidas; otra identidad SQL sintética, sin segundo
login real. Prueba HTTP pública aprobada. Salida LED digital implementada y compilada,
nodo deshabilitado y gateway también compilados con core3.3.4. Analyze y17tests
Flutter aprobados en copia con dependencias de SDK3.47.4; lock original intacto.
Usuario armará circuito después. [Cierre y estimación MVP60%](CIERRE-SOFTWARE-2026-10-23.md).
