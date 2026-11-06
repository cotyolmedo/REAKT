# Historial de entrega — octubre de 2026

Archivo histórico consolidado el 06/11/2026. Cada sección conserva el texto de
su documento original, incluidos estados y pendientes de esa fecha. Para operar
el sistema, consultar [PROBAR-HOY.md](PROBAR-HOY.md).

## Documento 1: historial-entrega.md

# Cierre de etapa software — 23/10/2026

> Cierre histórico previo a la publicación Android. Actualmente hay APK 0.3.0
> con configuración de nube y ramas integradas. Consultar [PROBAR-HOY](PROBAR-HOY.md).
> El porcentaje y los bloqueos inferiores corresponden al momento de este cierre.

El usuario pidió cerrar esta etapa antes de armar el circuito. No se cargó firmware
ni se cambió el cableado. Trabajo en rama codex/colegio-mvp-20261023, desde 6e4eec6,
en .school-work/REAKT; checkout original preservado. Sin commit/push.

## Porcentaje estimado

**MVP actual: aproximadamente 60% completo.** Es una estimación de planificación
según entregables y evidencia, no una medición de horas ni una certificación.
El alcance es la cadena con un nodo, pulsador y LED en protoboard. No representa
el proyecto ampliado de cinco nodos, todos los modos, PCB y carcasa final.

| Área | Peso | Avance reconocido sobre el total |
|---|---:|---:|
| App y almacenamiento local | 25 | 20 |
| Firmware y protocolo | 20 | 17 |
| Supabase/Auth/persistencia | 20 | 16 |
| Hardware y montaje | 15 | 3 |
| Integración física y fiabilidad | 15 | 0 |
| Documentación operativa | 5 | 4 |
| Total estimado | 100 | 60 |

La mayor incertidumbre pendiente es la integración real. Tener código compilado
y pruebas de software no demuestra funcionamiento de radio, estímulo ni Android físico.

## Verificaciones ejecutadas en esta PC

- Supabase: cuenta de prueba registrada por el usuario y confirmada; consulta de
  metadata encontró tres sesiones Auth. No se accedió a contraseñas/tokens.
- `backend/remote-rls-smoke.sql`: aserciones remotas aprobadas con el UUID del
  usuario confirmado. Sesión idempotente, escritura/lectura de resultados/eventos,
  rechazo de rondas inválidas y cambio de dueño, DELETE bloqueado, identidad distinta
  sin lectura/actualización/upsert sobre datos ajenos, anónimo sin lectura.
  La segunda identidad es un subject SQL sintético, no un segundo login real.
  Transacción revertida; consulta posterior confirmó 0 sesiones, 0 resultados,
  0 eventos. No se dejaron métricas de prueba en producción.
- `node tools/probe-supabase-public.mjs`: Auth settings HTTP200; REST anónimo
  rechazado con HTTP401 en las tres tablas. No se imprimieron claves.
- Flutter3.47.4/Dart3.13.3 instalado: `pub get --enforce-lockfile` en la app
  original falló porque el SDK fija diez dependencias diferentes de Flutter3.29.3.
  No se modificó app/pubspec.lock. Se copió lib/test/pubspec a build/flutter347-app
  (ignorado), resolvieron allí las diez dependencias de SDK y se ejecutó:
  `analyze --no-pub`: No issues found; `test --no-pub`: 17 tests passed.
  Es validación con SDK más nuevo, no reproducción exacta del APK anterior.
- Arduino CLI1.1.1 / esp32:esp32:esp32 core3.3.4, dos jobs:
  nodo LED digital 888275 bytes flash / 44792 RAM;
  nodo salida deshabilitada 887975 / 44792;
  gateway 929487 / 48324. Gateway usó WebSockets2.7.2 y ArduinoJson7.4.3.
  Las tres compilaciones terminaron exit0. Destino genérico de banco, sin MAC
  del nodo ni pinout validados; no son evidencia de firmware cargado.
- `git diff --check`, sintaxis Node y parser PowerShell del nuevo script: aprobados.

## Cambios implementados

Salida del nodo encapsulada en Stimulus.h: admite LED digital con polaridad
configurable, WS2812B con cantidad configurable y salida deshabilitada. Mantiene
protocolo, debounce y reloj posterior a la escritura de salida. ENABLED y
HARDWARE_VALIDATED permanecen en0 por defecto. El LED digital no requiere NeoPixel.

Nuevos instrumentos: compilador Windows, formulario Auth local, comprobación
pública de API y prueba RLS remota transaccional. Configuración pública solo en
app/supabase-public.json ignorado por Git, sin claves privilegiadas.

## Qué sigue cuando esté el circuito

1. Seguir [MVP-PROTOBOARD.md](MVP-PROTOBOARD.md), verificar placa/pines/LED/resistencia.
2. Conectar el nodo, identificar su MAC real y completar configuración local de
   ambos roles. Gateway conocido: COM4, MAC30:c6:f7:92:d0:9c.
3. Respaldar flash existente y cargar cada rol con identidad y puerto comprobados.
4. Probar radio, pulsación, mantener/soltar, timeout, detener y recuperación.
5. Preparar Android SDK/JDK/NDK o recuperar APK compatible con configuración de nube;
   probar teléfono real, SQLite tras reinicio y sincronización desde app con Internet.
6. Segundo login real y aislamiento REST; diez sesiones físicas consecutivas.

Android SDK no fue localizado; no se generó APK nuevo con la configuración Supabase.
Las advertencias previas de funciones SECURITY DEFINER siguen documentadas y su
corrección requiere revisión/aprobación separada. No se deshabilitaron protecciones.


---

## Documento 2: historial-entrega.md

# Estado al retomar en la computadora del colegio

## Continuación colegio — 23/10/2026

- Base de trabajo: commit exacto `6e4eec6c51bb452b4ca4578e67da3cac6d528692`, rama `codex/colegio-mvp-20261023`, copia aislada en `.school-work/REAKT`. El checkout original main en 765e267 y sus cambios locales se conservaron. No commit/push.
- Supabase: conector operativo; proyecto `hvaoezcsgqepcttaznof`, URL coincidente y estado ACTIVE_HEALTHY. Inspección previa: siete tablas existentes con RLS, sin objetos reakt_* ni historial de migraciones; cero usuarios Auth. Se inspeccionaron políticas y funciones/trigger Auth.
- Aplicada sin cambios la migración autorizada `backend/migrations/20261022_001_reakt_mvp.sql`. Historial remoto: versión `20261023120712`, nombre `reakt_mvp`. Tres tablas nuevas, nueve políticas, RLS activo. Metadata verificada: anon sin acceso; authenticated SELECT/INSERT/UPDATE, sin DELETE. Consulta bajo rol authenticated sin propietario devolvió cero filas. No se probó todavía escritura autenticada ni aislamiento con dos usuarios reales.
- Configuración URL/clave pública recuperada por conector, guardada en `app/supabase-public.json`; `git check-ignore` confirmó exclusión. Sin claves privilegiadas ni contraseñas en fuentes.
- Auth: usuario indicó correo de prueba. Preparado `tools/auth-local/server.mjs` + formulario local; escucha 127.0.0.1:8766, no recibe contraseñas (navegador conecta por HTTPS directamente a Supabase), token solo en memoria. Requiere acción humana para registrar, confirmar correo e iniciar sesión. No hay evidencia todavía de registro/login.
- Advisors: siguen advertencias PREEXISTENTES por EXECUTE público sobre `handle_new_user()` y `rls_auto_enable()`. No se modificaron permisos ajenos a la migración aprobada; revisar propuesta separada antes de corregirlos. Referencia: https://supabase.com/docs/guides/database/database-linter?lint=0028_anon_security_definer_function_executable
- Herramientas instaladas: Arduino CLI 1.1.1; Espressif core 3.3.4, Arduino ESP32 2.0.18-arduino.5; ArduinoJson 7.4.3/WebSockets 2.7.2 (difieren de referencias previas). Flutter 3.47.4/Dart 3.13.3. Wrapper Flutter tiene script alterado y caché bloqueada por Git fetch de tags huérfano; identificados/detenidos solo esos procesos. Ejecución directa del snapshot con --no-version-check --version aprobada. Android SDK no localizado. Pub get --enforce-lockfile iniciado; resultado pendiente al cierre, no declarar analyze/test/build nuevos aprobados.
- Gateway conectado por usuario: COM4, USB VID 10C4/PID EA60 (CP210x). Lectura ROM esptool5.1.0 tras BOOT manual: ESP32-D0WDQ6 rev1.0, cristal40MHz, MAC real `30:c6:f7:92:d0:9c`. No valida pinout, radio, GPIO ni firmware. No se grabó flash. Auto-reset no entra en download: esptool informa modo0x13; lectura flash-id posterior bloqueada por ese motivo. Para la próxima operación ROM se necesita BOOT manual.
- Computer Use inicializó y listó apps, pero el intento de abrir una pestaña fue detenido por la herramienta: no pudo determinar la URL de Chrome con confianza suficiente. Se dejó de controlar la UI.
- Novedad autorizada: MVP en protoboard con pulsador y un LED. Falta identificar tipo de LED y circuito; no se habilitó ni modificó salida (sigue deshabilitada). El firmware entregado soporta WS2812B; LED común requiere adaptación pendiente.
- Próximos pasos: abrir http://127.0.0.1:8766, registrar/confirmar cuenta con contraseña local; verificar Auth y RLS reales; terminar dependencias Flutter/Android; respaldar flash existente antes de cargar; identificar nodo y sus MAC; validar pulsador/LED con docente; pruebas físicas y diez sesiones pendientes.


---

## Documento 3: historial-entrega.md

# Estado de entrega REAKT — 22/10/2026

> Archivo histórico de la entrega 0.2.0. El estado vigente está en
> [PROBAR-HOY.md](PROBAR-HOY.md) y la publicación 0.3.0 en
> [android-release-2026-10-23.md](android-release-2026-10-23.md).
> Los bloqueos de Supabase y generación de APK que siguen fueron resueltos después.

Objetivo: llevar al colegio el viernes23/10 una base reproducible y comprobar
primero radio/pulsador. Fecha límite global: 6/11/2026.

## Resultados verificados

| Componente | Estado y evidencia |
|---|---|
| Nodo y gateway WROOM-32 | COMPILADOS con Arduino-ESP32 2.0.17; no cargados físicamente desde aquí |
| ACK, CRC, duplicados, debounce y tiempo | PROBADOS en C++ con ASan/UBSan |
| Diez sesiones con pérdidas | PROBADAS en simulación de componentes, no en placas |
| APK Android debug | COMPILADO y firma verificada; uso físico pendiente |
| Flutter 3.29.3/Dart3.7.2 | INSTALADO; lock resuelto, analyze sin errores |
| Flutter contrato/SQLite/sync/conexión/UI | 17 tests APROBADOS; UI real contra servidor WebSocket de prueba y SQLite |
| Panel de diagnóstico navegador | PROBADO en Chromium: orden manual, métrica, historial tras reload y exportación JSON |
| SQL/RLS propuesto | 11 tests APROBADOS en PostgreSQL aislado; incluye inspección solo lectura |
| Supabase remoto | BLOQUEADO: conector sin herramientas y proxy rechaza CONNECT403 al proyecto indicado |
| Prueba física de Android/radio/pulsador | PENDIENTE DE HARDWARE |
| Estímulo visual WS2812B | BLOQUEADO: el usuario solo tiene placas y pulsador; faltan LEDs/circuito/alimentación |

## Archivos entregados

- `REAKT-MVP-2026-10-22.zip`: código actual y Markdown finales, incluidos cambios
  de la entrega y lock. No incluye SDKs, configuraciones locales ni claves. Instalar
  dependencias antes de trabajar sin Internet. Incluye manifest SHA256 por archivo.
- `REAKT-0.2.0-debug.apk`: **COMPILADO** con JDK17/NDK27.0.12077973; paquete
  `ar.edu.reakt`, versión0.2.0/código2, Android mínimo6.0/API23, target35.
  Universal: arm64-v8a, armeabi-v7a, x86 y x86_64. Aproximadamente199MiB.
- Archivos `.sha256` externos para comprobar ZIP/APK. En el cloud están en
  `/workspace/exports/`; copiar al colegio los archivos descargados, no esa ruta.

APK debug con firma v1/v2 verificada, **sin credenciales Supabase configuradas**:
funciona como cliente de entrenamiento/almacenamiento local; habilitar nube requiere
configuración pública y reconstruir. No hay validación en teléfono desde este entorno.
No es publicación Play Store ni APK release de producción. Recompilar en otra PC
puede cambiar firma debug: resguardar historial JSON y revisar antes de desinstalar.
La exportación no incluye un restaurador automático.

SHA256 APK: `a6323ae514e46d27e13106dffe703a009d2159fd30004020a200bd851bdb3201`.


## Proyecto Supabase y autorización

URL aportada por el usuario: `https://hvaoezcsgqepcttaznof.supabase.co`.
Se intentó Auth health y raíz REST; el proxy devuelve403 antes de obtener respuesta
del servicio. No se estableció una conexión SQL ni se inspeccionaron tablas remotas.

La migración `backend/migrations/20261022_001_reakt_mvp.sql` ya tiene aprobación
expresa **tras inspección, si no hay conflictos**. La aprobación no habilita saltar
esa inspección. No se aplicó ni se creó usuario remoto por falta de acceso.
`backend/inspect-readonly.sql` prepara la inspección metadata sin modificar datos.

Se guardaron en el draft el dominio exacto y SUPABASE_URL (no secreto), conservando
la autorización de storage.googleapis.com. Guardar draft no aplica ni publica:
revisar/guardar ajustes en configuración del entorno y publicar el entorno cuando
corresponda. Aún hace falta conectar herramientas Supabase para operar el proyecto.
No enviar contraseñas, service_role ni tokens administrativos por chat.

## Qué hacer mañana

Seguir **historial-entrega.md**, en este orden:

1. Descargar la entrega actual o actualizar main y verificar el commit
   “Cambios mayores, progreso considerable”. Preparar herramientas con Internet y conservar copia.
2. Identificar placas y station MAC, verificar GPIO y configurar roles locales.
3. Probar gateway/nodo/pulsador desde el panel del navegador, sin necesitar Android.
4. Instalar/probar la app Android y verificar historial antes de agregar nube.
5. Inspeccionar Supabase, aplicar solo si compatible y ensayar sincronización/RLS.
6. Segundo nodo y diez sesiones físicas cuando el primero sea estable. La reacción
   visual queda pendiente hasta conseguir/verificar LEDs y su alimentación.

Completar `registro-pruebas-colegio.md` con resultados reales y conservar JSON/logs.
Sin cables de datos, Wi-Fi o permisos de instalación, terminar primero esos
prerrequisitos; el simulador permite avanzar con software, sin afirmar prueba física.

## Documentación incluida

- historial-entrega.md: instrucciones Windows/colegio y alternativas.
- mvp-installation.md: Arduino, Flutter, pinout propuesto y configuración segura.
- packet-protocol.md: contrato compartido, ACK, límites y fallos.
- mvp-physical-tests.md y registro-pruebas-colegio.md: matriz y planilla vacía.
- mvp-school-report.md: informe técnico para la escuela.
- implementation-log.md y testing.md: historial de comandos, fallos y evidencia.
- ../backend/README.md: cambios SQL autorizados condicionalmente y riesgos.

## Límites de esta entrega

No se declararon pruebas físicas, fabricación, consumo, precisión temporal humana,
Supabase real. La publicación del código fue autorizada en la continuación;
ver historial-entrega.md. No se inventaron MAC, GPIO validados ni claves.
Entrenamiento funciona por diseño sin Internet; validación física todavía necesaria.
El panel es herramienta de banco, no reemplaza la app ni sincroniza Supabase.
Los datos del simulador/test son sintéticos y no cuentan como diez sesiones físicas.


---

## Documento 4: historial-entrega.md

# Mañana en el colegio — viernes 23 de octubre de 2026

> Guía histórica de preparación. Para el estado integrado y el orden vigente usar
> [PROBAR-HOY.md](PROBAR-HOY.md): APK 0.3.0 publicado, Supabase aplicado y nodo con
> salida digital opcional. Las secciones antiguas de SDK/migración no deben repetirse.

## Objetivo alcanzable con lo que tienen

Con **dos ESP32 y un pulsador** pueden comprobar programación, MAC reales,
ESP-NOW bidireccional, ACK, antirrebote y llegada de eventos al cliente. Si hay
una tercera placa, el segundo nodo queda para después. No tienen WS2812B ni su
alimentación: no conectar componentes sustitutos ni presentar tiempos como
reacción visual. Sin cables de datos/conexión adecuados, limitarse a software y
programación; no improvisar contactos eléctricos.

Primer documento a abrir: `Docs/historial-entrega.md`. Describe los resultados de
esta entrega. Este documento es el procedimiento; los casilleros vacíos no son
pruebas realizadas.

## Qué llevar y descargar antes

- El **ZIP de la entrega actual**, extraído en una carpeta con permisos de escritura.
  Para obtener el código desde GitHub, actualizar main y verificar el commit con
  mensaje “Cambios mayores, progreso considerable”. El ZIP es otra copia de la entrega.
  Conservar copia del ZIP en otro medio. Abrir la carpeta REAKT en VS Code.
- Dos placas identificadas, cables USB **de datos**, pulsador y conexiones adecuadas.
  Revisar con docente el modelo real y pinout. Teléfono Android/cable de datos si
  van a probar la app. No asumir que la computadora tiene Wi-Fi: comprobarlo.
- Arduino IDE2, core ESP32 de Espressif2.0.17, Adafruit NeoPixel1.12.3,
  WebSockets2.6.1 (Links2004), ArduinoJson6.21.5. Instalar con Internet.
- Python3 para el panel del navegador. Flutter3.29.3/Dart3.7.2, Android Studio/SDK
  y JDK17 **completo, con javac**, para desarrollar Android. NDK27.0.12077973
  está fijado en el proyecto; el primer build también puede instalar CMake3.22.1. Si no hay permisos para drivers/software,
  pedir asistencia al docente o administrador; no intentar evadir restricciones.
- Credenciales de Wi-Fi de banco guardadas localmente. Para nube: acceso propio
  al proyecto Supabase reakt y al usuario de pruebas, nunca una clave service_role
  en la app. No llevar credenciales dentro del ZIP ni en un repositorio público.

**Prioridad práctica:** configurar herramientas con Internet primero; recién
después cambiar la red Wi-Fi al AP de la gateway, que no ofrece Internet.

## 1. Programar e identificar placas

1. Abrir `firmware/gateway/REAKT_Gateway/REAKT_Gateway.ino` en Arduino IDE.
2. Copiar `firmware/libraries/ReaktCore` al directorio `libraries/ReaktCore` del
   sketchbook Arduino. Instalar las bibliotecas versionadas arriba.
3. Seleccionar la placa real (destino compilado de referencia: ESP32 Dev Module
   para WROOM-32) y su puerto. Si no aparece puerto: verificar cable de datos,
   driver oficial que corresponda al conversor USB de la placa y permisos.
4. Compilar/cargar configuración inicial y abrir monitor a **115200 baud**. Anotar
   la **station MAC** del gateway, no la del SoftAP. Cerrar monitor para otra carga.
5. Hacer lo mismo con `firmware/nodes/REAKT_Node/REAKT_Node.ino` en la segunda
   placa. Etiquetar físicamente gateway/nodo1 para no intercambiar roles.
6. Crear `LocalConfig.h` junto a cada sketch copiando su ejemplo. Gateway: contraseña
   propia >=12 caracteres y MAC real de nodo1. Nodo1: MAC station real del gateway,
   ID1. Dejar nodo2 sin configurar si no está disponible.
7. GPIO18 significa la señal GPIO, no la posición física18 del conector.
   El docente debe verificar GPIO18/pulsador y el modelo real. Solo después poner
   `REAKT_HARDWARE_VALIDATED 1`. Mantener **REAKT_LED_ENABLED 0**: hoy no tienen LEDs.
   Pulsador NA entre GPIO verificado y GND, con pull-up interno; nunca aplicar 5V al GPIO.
   En un pulsador de cuatro patas, identificar contactos correctos, no adivinarlos.
8. Recompilar y cargar ambos roles. Guardar logs de inicio. Ambos usan canal6.
   Si falla radio/peer, revisar las station MAC y configuración; no inventarlas.

## 2. Probar de inmediato con navegador, sin instalar Android

Requiere computadora con Wi-Fi conectada al AP y Python3. Este es un instrumento
de diagnóstico, no una sustitución de Flutter ni una integración Supabase.

Desde la raíz REAKT en PowerShell:

```powershell
py -m http.server 8000 --bind 127.0.0.1 --directory tools/web-diagnostics
```

Si el comando `py` no existe pero Python está instalado, usar `python`. Abrir en
el navegador la dirección local que muestra el servidor, puerto8000. Mantener
la terminal abierta. El servidor expone solo el panel, no archivos de configuración.

1. Conectar la computadora al Wi-Fi **REAKT-MVP** con la contraseña local.
2. En el panel dejar gateway `ws://192.168.4.1:81` y pulsar **Conectar**.
3. Verificar snapshot idle. Pulsar **Prueba manual · 5 s** y accionar el pulsador.
   Esperado: un hit, un evento e ID estable, sin duplicarse al mantenerlo presionado.
   El instante visual del navegador no define la medición de reacción: hoy no hay LEDs.
4. Repetir sin pulsar: esperado miss al vencer. Pulsar/mantener/liberar y repetir
   para verificar antirrebote y rearme. Confirmar por monitor serie del nodo.
5. Probar diez rondas como ensayo de comunicaciones. Sin LEDs, documentarlo como
   banco sin estímulo físico, no entrenamiento humano validado.
6. Desconectar/reconectar cliente; recuperar snapshot mientras no se reinicie la
   gateway ni se comience otra sesión. Pulsar **Exportar JSON** y guardar el archivo
   con fecha/placas usadas. Capturar también logs y errores, no solo aciertos.
7. Desconectar alimentación del nodo durante una sesión: esperado interrupción por
   comunicación, sin inventar un resultado del usuario. Después reiniciar sesión.

Si el navegador informa bloqueo de red privada/mixed content, usar el panel HTTP
local, no un sitio HTTPS público. Revisar permisos del navegador para ese origen
local con el docente. Si la PC no tiene Wi-Fi, usar la app Android o preparar las
herramientas y el simulador; no afirmar comunicación con la gateway sin conectarla.

## 3. App Android

Si esta entrega incluye un APK probado en compilación, consultar su ubicación en
historial-entrega.md. Compilar un APK no significa que fue probado en ese teléfono.
Para instalarlo, autorizar depuración/instalación mediante el procedimiento del
colegio. No borrar datos de una instalación anterior que tenga sesiones sin exportar.

Para desarrollar desde PowerShell, dentro de `app/`:

```powershell
flutter --version
flutter doctor -v
flutter pub get --enforce-lockfile
flutter analyze
flutter test
flutter devices
flutter run
```

Resolver licencias/SDK desde Android Studio y `flutter doctor --android-licenses`
según las indicaciones oficiales. El primer build necesita Internet. Luego:

1. Conectar teléfono a REAKT-MVP; mantener esa red aunque no tenga Internet.
2. Abrir app, conectar gateway, verificar estado. Probar manual, mantener pulsación,
   timeout, detener sesión y reconectar. Un fallo de disco no debe impedir detener.
3. Cerrar/reabrir y revisar **historial guardado**. Una sesión en curso tras reiniciar
   gateway no se convierte automáticamente en completada.
4. Usar **Copiar historial JSON** y pegarlo en un archivo guardado antes de cambiar
   de instalación. Es exportación, no un restaurador automático. APKs debug de distintas
   computadoras pueden tener firmas diferentes: si Android rechaza la actualización,
   detenerse y revisar con el responsable; no borrar datos como primer intento.
5. Volver a Internet al terminar para Auth y sincronización. La nube no se necesita
   para realizar las pruebas locales.

No ejecutar `flutter create --overwrite` sobre este proyecto ni regenerar pubspec.
Conservar el lock. Si el build falla, guardar la salida y corregir el error concreto;
no desactivar TLS, checksums ni RLS para conseguir un resultado aparente.

## 4. Supabase, cuando haya acceso

Proyecto indicado: `https://hvaoezcsgqepcttaznof.supabase.co`.
La autorización existente permite aplicar la migración preparada **tras inspección
sin conflictos**. No se recibió acceso administrativo en esta sesión ni se aplicó.

1. Abrir el proyecto correcto en el dashboard. Ejecutar primero
   `backend/inspect-readonly.sql` en SQL Editor y revisar metadata/RLS/tablas.
2. Si los nombres propuestos ya existen o hay incompatibilidades, parar solamente
   la migración y revisar la adaptación; no borrar tablas ni desactivar RLS.
3. Si la inspección confirma compatibilidad, el responsable con acceso puede aplicar
   `backend/migrations/20261022_001_reakt_mvp.sql`, ya autorizado condicionalmente.
4. Crear/invitar usuario de pruebas con el flujo Auth existente y completar la
   confirmación de correo cuando corresponda. No usar el password administrativo
   del proyecto como contraseña de la app. No guardar contraseñas en Markdown.
5. Copiar `app/supabase-public.example.json` como `supabase-public.json`. La URL ya
   está; completar solo clave pública anon/publishable de cliente, jamás service_role.
6. Desde app: `flutter run --dart-define-from-file=supabase-public.json`.
7. Iniciar sesión con Internet, entrenar sin Internet, volver a una red con Internet
   y sincronizar. Repetir: no debe aumentar cantidad de sesiones/eventos duplicados.
8. Verificar que otro usuario no vea ni cambie esos registros. Si falla, conservar
   SQLite y corregir autorización; no saltarse las políticas.

## 5. Sin placas conectadas o mientras instalan software

Se puede ensayar el flujo del panel contra un simulador, claramente identificado:

```powershell
py -m pip install websockets==15.0.1
py tools/mock_gateway.py
```

Abrir otro terminal para el servidor del panel. En el panel usar el endpoint local
puerto8765 que indica el simulador. Sus reacciones de250ms son datos sintéticos.
El simulador no necesita pulsador, no prueba ESP-NOW y no reemplaza evidencia física.

## Orden recomendado de trabajo

1. Herramientas y cables; conservar copia de la entrega.
2. Dos placas: MAC/configuración/cargas.
3. Gateway↔nodo↔pulsador con panel, guardar JSON/logs.
4. App Android con el mismo enlace y persistencia local.
5. Supabase y sincronización si hay acceso y esquema compatible.
6. Segundo nodo solo después de estabilizar el primero.

Usar `Docs/registro-pruebas-colegio.md` para registrar lo que realmente sucedió.
Los LEDs, su fuente y validación eléctrica siguen pendientes para el estímulo visual.


---

## Documento 5: historial-entrega.md

# Prompt para retomar REAKT en el colegio — 23/10/2026

Copiar el bloque siguiente en la sesión conectada a la computadora. El acceso real
será el que expongan las herramientas y permisos; no asumir acceso total por texto.
No incluir contraseñas ni tokens en el mensaje.

```text
Continuá como ingeniero principal del MVP REAKT en esta computadora del colegio.
Repositorio: cotyolmedo/REAKT, main. La entrega tiene el commit con mensaje exacto
“Cambios mayores, progreso considerable”. Primero verificá Git, el checkout y las
herramientas disponibles. No sobrescribas cambios locales ni hagas reset/force push.

Leé AGENTS.md, Docs/historial-entrega.md, Docs/historial-entrega.md,
Docs/implementation-log.md, Docs/packet-protocol.md y
Docs/historial-entrega.md. No reinicies el trabajo desde una auditoría antigua.
La bitácora contiene intentos fallidos ya corregidos; el estado final es la referencia.

Objetivo: Flutter Android → WebSocket local → gateway ESP32 WROOM-32 → ESP-NOW →
uno o dos nodos → pulsador/WS2812B → gateway → Flutter → SQLite → Supabase.
Gateway coordina entrenamiento; nodo mide reacción con reloj monotónico. Sin delay().
No inventes MAC ni pinout verificado. GPIO18 y GPIO23 son propuestas por comprobar.
Hasta ahora solo tenemos placas y pulsador: LED_ENABLED debe seguir en0 hasta
conseguir y validar LEDs, alimentación y adaptación de nivel. Preguntá únicamente
por componentes o conexiones que no puedas comprobar y bloqueen una prueba concreta.

Ya se logró: firmware nodo/gateway compilado con Arduino-ESP32 2.0.17; protocolo
CRC/ACK/reintentos/dedup; pruebas C++ y diez sesiones simuladas; app con reconexión,
SQLite, exportación JSON, Auth/sync;17tests Flutter y analyze aprobados;11tests SQL
locales; panel de banco Chromium probado; APK debug0.2.0 compilado y firmado.
No se probó hardware, Android físico ni Supabase remoto. No confundas simulación con
mediciones reales. Los SDK de /workspace/tools pertenecen al cloud anterior:
no asumas que existen aquí. Prepará Flutter3.29.3/Dart3.7.2, JDK17 completo con
javac, Android SDK35/NDK27.0.12077973 y dependencias según el SO/permisos reales.
Usá app/pubspec.lock; no regeneres el proyecto ni reemplaces código funcional.

Prioridad1: intentar conexión e inspección de Supabase reakt,
URL https://hvaoezcsgqepcttaznof.supabase.co.
El conector anterior no exponía herramientas y el proxy devolvía CONNECT403.
Comprobá ahora herramientas conectadas, red y nombres/presencia de credenciales,
sin imprimir valores. Reutilizá acceso existente. No pidas secretos por chat.
Podés usar backend/inspect-readonly.sql para metadata del proyecto correcto.

YA AUTORICÉ aplicar backend/migrations/20261022_001_reakt_mvp.sql TRAS INSPECCIÓN
Y SOLO SI NO HAY CONFLICTOS. No vuelvas a pedirme autorización para ese mismo
cambio compatible. Si encontrás conflictos o necesitás otro cambio estructural/de
seguridad, prepará el cambio revisable y pedí aprobación específica. No borres datos,
no desactives RLS y nunca uses service_role/secret en Flutter. Verificá identidad
real del proyecto antes de cualquier escritura. Prepará/creá el usuario de pruebas
con el flujo Auth autorizado, sin inventar credenciales ni publicarlas.

Configurá la app con URL y clave pública en supabase-public.json local ignorado,
partiendo del ejemplo. Probá Auth, sesión offline, reconexión a Internet, upserts
idempotentes, reintentos y aislamiento con otro usuario. Si falta acceso remoto,
continuá con SQLite, repositorio simulado y pruebas de banco mientras se resuelve.

Prioridad2: herramientas, drivers oficiales, USB y placas. Identificá puertos y
station MAC reales, roles y configuración local. Antes de cargar firmware,
confirmá qué placa/puerto corresponde a gateway y nodo; no flashees a ciegas.
Verificá el GPIO del pulsador con el circuito real. Probá primero un nodo:
ACK, pulsación única, mantener/soltar, timeout, detener, pérdida de radio y recuperación.
El panel tools/web-diagnostics permite avanzar sin Android y exporta evidencia JSON.
Después instalá/probá Flutter en el teléfono, almacenamiento tras reiniciar y nube.
El APK debug de otra computadora puede tener firma distinta: resguardá historial
antes de cambiar de instalación y no desinstales ni borres datos automáticamente.

Avanzá de forma autónoma por todo lo autorizado, sin detenerte al finalizar cada
fase. Actualizá bitácora, testing y registro-pruebas-colegio.md con comandos,
resultados y evidencia real. Separá IMPLEMENTADO/COMPILADO/PROBADO/PENDIENTE DE
HARDWARE/BLOQUEADO. Meta:10sesiones físicas consecutivas sin fallos críticos;
si faltan LEDs, clasificá el ensayo como comunicaciones/pulsador sin estímulo visual.

Pedí aprobación antes de nuevos cambios importantes de arquitectura, cambios
estructurales/de seguridad Supabase fuera de lo ya autorizado, gastos, destrucción
o eliminación sin respaldo verificable. La autorización de push de ayer era para
la entrega de ayer: no publiques nuevos commits ni merges sin que lo autorice.
Continuá tareas independientes mientras falta un permiso. Al terminar, dejá resumen,
verificaciones, bloqueos concretos y próximos pasos. Fecha límite global:6/11/2026.
```


---

## Documento 6: historial-entrega.md

# Resumen de entrega — 22/10/2026

## Código y validación

- Firmware de gateway y uno/dos nodos WROOM-32 compilado con Arduino-ESP322.0.17.
- Protocolo compartido32bytes, CRC, ACK, reintentos y deduplicación; pulsador con
  debounce, reloj monotónico, LED opcional. WebSocket y entrenamiento en gateway.
- Flutter Android con conexión/reconexión, métricas, SQLite, exportación JSON,
  cliente Auth y sincronización diferida.17tests y analyze aprobados.
- APK debug0.2.0, paquete ar.edu.reakt, minSdk23/target35, firma verificada.
  Sin credenciales Supabase configuradas, sin prueba en teléfono físico.
- Once pruebas PostgreSQL aislado aprobadas para migración/RLS/inspección metadata.
- Simulación C++ de diez sesiones con pérdidas; panel de diagnóstico navegador
  probado con persistencia y exportación. No equivalen a validación física.

## Pendientes

Supabase remoto no fue inspeccionado ni modificado: conector sin herramientas y
proxy CONNECT403. Proyecto indicado por el usuario:
https://hvaoezcsgqepcttaznof.supabase.co. Autorización vigente para aplicar la
migración preparada tras inspección y solo sin conflictos; no requiere repetirse.
Faltan Auth real, esquema remoto compatible, persistencia/sync y RLS remotos.

Solo hay placas y pulsador. GPIO/MAC/cargas deben verificarse físicamente. LEDs y
alimentación faltan; salida LED deshabilitada. Falta prueba de radio, Android real
y diez sesiones físicas. No presentar tiempos sin LEDs como reacción visual validada.

## Git y entrega

El usuario autorizó el commit y push de esta entrega con el mensaje exacto:
`Cambios mayores, progreso considerable`.
Base anterior: `840c9b30bd9f1d3e5496ddac2a06956cbe06e3a9`.
El identificador de entrega se obtiene con `git log -1 --oneline` en main actualizado.
Código, lock, pruebas y documentación entran al commit; SDKs, builds, claves y
configuraciones locales quedan fuera. El APK se descarga aparte del código.

Para comparar con el estado anterior puede abrirse ese commit sin mover main.
Si se necesita deshacer una entrega ya compartida, preferir un revert revisado que
conserve el historial; cambiar de commit localmente no revierte la base de datos
ni el firmware cargado. No se necesita force push para conservar esta referencia.

## Mañana

Abrir `historial-entrega.md`, conservar evidencia en
`registro-pruebas-colegio.md` y copiar el prompt de `historial-entrega.md`.
Dar acceso a la computadora no garantiza acceso a Supabase, drivers, puertos o
permisos administrativos: comprobar cada capacidad y avanzar con las disponibles.
La guía permite empezar con el navegador antes de instalar Android.


---

## Distribución histórica 0.2.0

Los ZIP se retiraron del árbol actual. Se pueden recuperar desde la
[carpeta original en Git](https://github.com/cotyolmedo/REAKT/tree/c41c62d1c95877bccd2171884142ef7f0d4bb628/downloads).
La descarga vigente está en [Releases v0.3.1](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1).

Metadatos históricos de los ZIP/APK:

```json
{
  "REAKT-0.2.0-android-arm64.zip": {
    "zip_bytes": 7993847,
    "zip_sha256": "7c71283875e4418f17510c358be3e277ce284953a582617d5ec5be8c5e382ab2",
    "apk_file": "REAKT-liviano-arm64-v8a.apk",
    "apk_bytes": 17313186,
    "apk_sha256": "2e7e9e8b9a2e60feff1c042ed99e4805cca980d81c1ae896dfd686a6e2aed623"
  },
  "REAKT-0.2.0-universal-original.zip": {
    "zip_bytes": 83878149,
    "zip_sha256": "92bdd7d5e82c9cb5f18adf4e17f8ac37c1e04f96a5c9600614f72d8d1366d816",
    "apk_file": "REAKT-0.2.0-debug.apk",
    "apk_bytes": 208433007,
    "apk_sha256": "a6323ae514e46d27e13106dffe703a009d2159fd30004020a200bd851bdb3201"
  }
}
```

```text
7c71283875e4418f17510c358be3e277ce284953a582617d5ec5be8c5e382ab2  REAKT-0.2.0-android-arm64.zip
92bdd7d5e82c9cb5f18adf4e17f8ac37c1e04f96a5c9600614f72d8d1366d816  REAKT-0.2.0-universal-original.zip
```
