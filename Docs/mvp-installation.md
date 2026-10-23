# Instalación y operación del MVP

> Entrada actual: [PROBAR-HOY.md](PROBAR-HOY.md). Esta guía conserva las versiones
> de firmware originales; para el banco con LED común ver [MVP-PROTOBOARD](MVP-PROTOBOARD.md).

## Estado y alcance

Firmware nodo/gateway compilado para ESP32 Dev Module, Arduino-ESP32 **2.0.17**.
No se cargó en una placa desde este entorno. Flutter 3.47.4: lock resuelto, análisis y 21 tests aprobados.
Estado actual del APK en android-release-2026-10-23.md. No considerar completa la integración física.

Actualmente hay placas y pulsador; faltan WS2812B y alimentación de LEDs. No
habilitar LED output hasta conseguirlos y verificar conexiones. Se puede probar
radio y pulsador primero. No confundir eventos simulados con mediciones físicas.

## Firmware en Arduino IDE 2

1. Instalar soporte oficial Espressif ESP32 **2.0.17** usando su índice:
   `https://espressif.github.io/arduino-esp32/package_esp32_index.json`.
2. Seleccionar **ESP32 Dev Module** para la WROOM-32/DevKitC verificada, 4 MB
   solo si coincide con la placa física. Registrar modelo y opciones de carga.
3. Instalar bibliotecas: Adafruit NeoPixel **1.12.3**, WebSockets (Links2004)
   **2.6.1**, ArduinoJson **6.21.5**.
4. Copiar `firmware/libraries/ReaktCore` a `libraries/ReaktCore` del sketchbook
   Arduino. Copiar no mover; mantener el código compartido de ambos sketches igual.
5. Abrir `firmware/gateway/REAKT_Gateway/REAKT_Gateway.ino` y
   `firmware/nodes/REAKT_Node/REAKT_Node.ino`. Compilar ambos. Configuración inicial
   compila pero no habilita radio de aplicación/GPIO: imprime MAC y bloqueo.
6. Cargar esa configuración inicial en cada placa; abrir monitor **115200 baud**,
   registrar las **station MAC** reales. Etiquetar las placas. No usar la MAC del AP.
7. Copiar los `LocalConfig.example.h` como `LocalConfig.h` en sus mismas carpetas.
   Son archivos ignorados por Git. Gateway: contraseña WPA2 propia de >=12
   caracteres, MAC de nodo1 y opcional nodo2. Nodo: MAC station del gateway,
   ID 1 o 2 diferente para cada placa. No inventar MAC ni poner passwords en Git.
8. Tras verificar el pulsador y el GPIO real, poner
   `REAKT_HARDWARE_VALIDATED 1`. Mantener `REAKT_LED_ENABLED 0` mientras no haya
   LEDs y fuente adecuados. Ambos usan canal 6; no conectarlos a otro router.
9. Recompilar y cargar cada rol en su placa. Verificar monitor serie. Los logs
   `stimulus ... LED=0` son estímulos **diagnósticos sin luz física**.

Sin pulsador conectado no habilitar un GPIO sin comprobarlo. Cambiar GPIO18/23
solo tras revisar pinout; son propuestas, no mediciones. Ver pinout abajo.

## Compilar en este cloud

`./tools/compile-firmware-cloud.sh` utiliza las herramientas verificadas conservadas
en `/workspace/tools` (Arduino CLI 1.2.2, GCC Xtensa 8.4.0, core 2.0.17 y ctags).
Produce `build/REAKT_Node/` y `build/REAKT_Gateway/`. Configuraciones por defecto
no son imágenes finales de hardware. Logs en `build/firmware-build.log`.
Las advertencias de discovery se deben a utilidades de detección USB no instaladas;
no impidieron compilar. No se verificó upload ni conexión serie desde este cloud.

Alternativa `pio run -j 2` con `platformio.ini` fija versiones. PlatformIO se instaló,
pero no pudo descargar el registry (403 en `api.registry.platformio.org` y
`dl.registry.platformio.org`). Esa ruta de build sigue **sin verificar**.
El build Arduino se obtuvo de fuentes oficiales GitHub, con SHA-256 del índice
Espressif y SHA-512 de ctags; no se deshabilitó TLS ni verificación de artefactos.

## Flutter Android

1. Para desarrollar instalar Flutter **3.47.4** (ver app/.fvmrc), JDK17 y Android
   SDK compatible; aceptar licencias con `flutter doctor --android-licenses`.
   Revisar `flutter doctor -v`. NDK **27.0.12077973** fijado por requisitos de plugins.
   Gradle wrapper 8.14.3 conserva checksum de distribución; AGP8.11.1/Kotlin2.2.20.
2. Desde `app/`: `flutter pub get --enforce-lockfile`, `flutter analyze`, `flutter test`,
   `flutter build apk --debug`. Conservar `pubspec.lock` incluido para reproducibilidad.
3. Con un teléfono Android USB habilitado para depuración: `flutter devices`,
   luego `flutter run`. El scaffold Android usa `ar.edu.reakt`, minSdk24 (Android7+); release
   signing queda fuera del MVP (no publicar sin una configuración propia).
4. Entrenamiento offline funciona sin definir Supabase. Para la nube usar URL
   HTTPS y clave **pública** anon/publishable del proyecto mediante
   `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` al ejecutar
   o compilar. Nunca usar service_role/secret. No se pide la contraseña en comandos.
5. Conectar teléfono al Wi-Fi `REAKT-MVP` con la contraseña local. Mantener esa
   red aunque Android avise que no tiene Internet. Usar gateway `ws://192.168.4.1:81`.
   La app espera snapshot válido antes de habilitar comandos.
6. Ejecutar prueba manual (una ronda, 5 s), luego reflejos (10 rondas, 1,5 s).
   Con LEDs ausentes, probar solo transporte/pulsación; los tiempos no validan
   reacción visual. La app muestra objetivos y diagnósticos recibidos.
7. Las sesiones se guardan en SQLite del teléfono. **Copiar historial JSON** permite
   guardar un respaldo legible antes de cambiar de instalación; no incluye importación
   automática. Firmas debug de distintos equipos pueden impedir actualizar el APK: no
   desinstalar ni borrar datos sin resguardo. Tras terminar, volver a una red
   con Internet, iniciar sesión del usuario de pruebas y sincronizar. La app intenta
   reintentar cada 20 s con usuario autenticado; el botón permite repetirlo.

**Limitaciones actuales:** pruebas físicas Android pendientes; ver estado del APK en
android-release-2026-10-23.md. Supabase remoto tiene migración aplicada,
cuenta confirmada y pruebas RLS revertidas; falta sincronización desde Android.
No volver a ejecutar la migración para usar el APK. Si el inicio de
Supabase falla, la app conserva entrenamiento local y permite reabrir con Internet.
Historial en curso tras reinicio de gateway queda local, sin inventar cierre ni
sincronizarlo como completado. No desinstalar/borrar datos de la app para solucionar
un problema de red: perdería SQLite. El sistema no incluye cifrado local adicional.

## Simulación sin placas

`python3 -m pip install -r tools/requirements-dev.txt` en un virtualenv, luego
`python3 tools/mock_gateway.py`. Android emulador usa `ws://10.0.2.2:8765`, no la
IP del AP. Genera reacciones sintéticas de 250 ms y lo marca en diagnostics/error.
No usar sus resultados como evidencia de hardware. El manifiesto Android permite
tráfico claro solo al AP y loopback/emulador; Supabase conserva HTTPS.

## Pinout propuesto, NO validado

```text
ESP32 GPIO18 ---- pulsador NA ---- GND (INPUT_PULLUP, sin tensión externa)
ESP32 GPIO23 ---- adaptador de nivel ---- resistencia serie ---- DIN LED1
Fuente 5 V regulada ------------------- +5V WS2812B x5
Fuente GND -------- ESP32 GND --------- GND WS2812B
LED1 DOUT -> LED2 DIN -> ... -> LED5 DIN
```

GPIO y orden resistencia/adaptador deben decidirse con el circuito real. Para
WS2812B a 5 V usar adaptador compatible de 3,3 V a 5 V y desacoplo adecuados según
la ficha de los componentes. No alimentar LEDs desde GPIO ni asumir que el
regulador 3V3 de la placa sirve como fuente LED. No montar baterías/cargadores
sin diseño de protección y power-path verificado. Hoy **no hay esos componentes**:
no construir ese circuito con conexiones sustitutas. La prueba actual puede usar
placas por USB y pulsador una vez confirmado el pinout de la WROOM-32.

## Entorno cloud preparado

Desde /workspace/REAKT: `. tools/cloud-env.sh`, luego `cd app`. Configura SDK,
JDK completo, cachés y estado en rutas escribibles; no reasigna HOME. Tests Linux
usan la biblioteca SQLite del sistema con soname local. `dart --suppress-analytics
format lib test` funciona sin intentar escribir analytics en HOME de solo lectura.
Fuera del cloud, usar las instalaciones locales normales de Flutter/JDK/SDK.
