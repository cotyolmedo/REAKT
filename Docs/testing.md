# Estrategia y registro de pruebas REAKT

## Referencia actual — 23/10/2026

Verificación de integración ejecutada en Windows: Flutter3.47.4 con
`pub get --enforce-lockfile`, `analyze --no-pub` sin problemas y21tests aprobados;
simulador WebSocket2tests aprobados en venv con websockets15.0.1. Arduino core3.3.4:
nodo Off887975bytes/44792RAM, Digital888275/44792, gateway929487/48324;
compilaciones exit0, sin carga en esta verificación. WebSockets2.7.2,
ArduinoJson7.4.3 y ReaktCore local. Sintaxis Node/PowerShell, enlaces de entrada,
diff/check y exclusión de configuraciones locales comprobados. Código Flutter
productivo y tests idénticos a las ramas APK/guardado local; solo cambian sus guías.

La app 0.3.0 aprobó análisis y 21 pruebas; APK debug publicado con firma/SHA256,
configuración Supabase y endpoint gateway comprobados dentro del archivo descargado.
Evidencia y workflows: [publicación Android](android-release-2026-10-23.md).
RLS remoto fue probado con datos sintéticos revertidos; no es login desde teléfono
ni segundo login real. Circuito, radio, Android y diez sesiones físicas pendientes.
Las entradas inferiores son bitácora histórica. Para ejecutar: [PROBAR-HOY](PROBAR-HOY.md).

## Criterio

Avanzar de componentes aislados hacia integración. Una prueba solo se considera
aprobada si registra condiciones, versión, resultado esperado, resultado real y
evidencia cuando corresponda. No inferir validación física desde una revisión
estática o un archivo CAD.

## Matriz pendiente

### Firmware y ESP-NOW

- [ ] Compilar gateway y nodo para la placa ESP32 real; registrar versión del
  core.
- [ ] Verificar inicialización, transmisión y recepción con un nodo.
- [ ] Extender a cinco nodos.
- [ ] Probar límites, paquetes inválidos, cola llena, pérdidas, duplicados,
  orden, timeouts y recuperación.
- [ ] Probar coexistencia entre el transporte App ↔ gateway y el canal ESP-NOW.

### Pulsador NA

- [ ] Verificar GPIO y polaridad antes de habilitar `BUTTON_GPIO`.
- [ ] Confirmar un solo evento por pulsación y rearme tras liberación.
- [ ] Probar rebote, pulsaciones rápidas/prolongadas y vibración.
- [ ] Definir y medir el criterio de timestamp.

### WS2812B y alimentación

- [ ] Verificar estados visuales, nivel lógico, brillo y consumo máximo.
- [ ] Medir tensiones durante picos de LED y radio.
- [ ] Verificar protección, carga, temperatura y batería baja.
- [ ] Probar operación durante carga solo si existe un *power-path* diseñado.

### Aplicación

- [ ] Ejecutar `flutter analyze` y pruebas automatizadas.
- [ ] Validar navegación y renderizado en Android/iOS.
- [ ] Probar conexión, desconexión, datos inválidos y errores de backend.
- [ ] Sustituir datos de demostración solo cuando existan interfaces reales.

### Backend

- [ ] Probar migraciones, restricciones, CRUD, autenticación y RLS.
- [ ] Verificar que Flutter no use claves privilegiadas.
- [ ] Probar fallos de red y autorización.

### Integración

```text
Flutter → gateway → nodo (WS2812B)
Flutter ← gateway ← nodo (pulsador)
Flutter o servicio autorizado ↔ Supabase/PostgreSQL
```

Validar camino normal, desconexiones y recuperación antes de la exhibición.

## Evidencia existente

### Consolidación del repositorio — 2026-10-10

- `git diff --check`: completado sin errores de espacios en blanco.
- Revisión automatizada de enlaces Markdown locales: 0 enlaces rotos.
- Búsqueda fuera de `Tests/`: sin referencias a las antiguas rutas paralelas
  numeradas.
- Búsqueda en `firmware/`: sin llamadas a `delay()`.
- Búsqueda de patrones comunes de tokens JWT/API: sin coincidencias.
- Arduino CLI, PlatformIO, KiCad CLI y compilador C++ independiente: no
  disponibles; compilación de firmware y nuevo DRC no ejecutados.

### Flutter — 2026-10-09

- Revisión estática de `app/` realizada.
- `flutter analyze`, pruebas y renderizado quedaron sin ejecutar porque el SDK
  no estaba disponible en ese entorno.
- Estado: no verificado en dispositivo.

### Flutter — intento de verificación 2026-10-10

- El SDK fue detectado en el entorno, pero `flutter pub get`/`flutter analyze` y
  luego `flutter --version` no produjeron salida y agotaron los límites de 120 s
  y 30 s respectivamente.
- No se generó `pubspec.lock` ni se modificó `app/`.
- Estado: análisis aún pendiente; investigar la instalación del SDK antes de
  atribuir el timeout al proyecto.

### Prototipo web — 2026-10-09

- Revisión estática de metadatos Apple, `viewport-fit=cover`, safe areas,
  navegación móvil y manifest en `REAKT_web.html`.
- Safari en iPhone/iPad y modo Home Screen: pendientes.
- Detalle en `cambios pagina.md`.

### PCB V0.1 — 2026-10-09

- KiCad 9 CLI pudo analizar `hardware/pcb/reakt-nodo/reakt-nodo.kicad_pcb`.
- Informe guardado en `hardware/pcb/reakt-nodo/drc-v0.1.rpt`: cero pads sin
  conectar y advertencias esperables por footprints/serigrafía provisionales.
- Esto no constituye un DRC limpio de liberación.
- Esquemático, ERC, revisión de fabricación, encastre 3D y pruebas físicas:
  pendientes.

## Pruebas históricas

Los sketches en `Tests/` con ESP32-C3 o piezoeléctricos son antecedentes. No
validan los cinco nodos ESP32 con pulsador del diseño actual.

## Plantilla de evidencia

Registrar para cada ensayo:

- fecha y responsable;
- commit o versión de archivos;
- placa, componentes y conexiones reales;
- herramientas y configuración;
- procedimiento y resultado esperado;
- resultado real, mediciones y errores;
- fotos, video o logs cuando correspondan.

### MVP — 2026-10-22 (evidencia de esta ejecución)

| Verificación | Resultado real |
|---|---|
| `tools/test-core.sh` | 2 ejecutables C++ aprobados con ASan/UBSan: contrato y simulación10x10 con pérdidas/ACKs/duplicados |
| `python3 tests/test_mock_gateway.py` | 2 pruebas aprobadas, repetidas tras ajuste UUID |
| `/workspace/tools/venv/bin/python tests/test_backend.py` | 10 pruebas PostgreSQL aislado aprobadas; shim local auth.uid, NO Supabase remoto |
| `tools/compile-firmware-cloud.sh` | Nodo721561bytes flash/44220RAM y gateway767069flash/47712RAM; ambos exit0 |
| Variante nodo2 + LEDs habilitados | Compilación exitosa previa; no carga en placa ni validación de alimentación |
| Dart/Android XML | Siete archivos Dart pasaron parser sintáctico; XML Android parseado. No equivalen a analyzer/build |
| Metadatos de dependencias pub.dev | Pins existentes; sqflite2.4.2 requiere Dart>=3.7, manifiesto ajustado |
| `flutter pub get / analyze / test / build apk` | NO EJECUTADOS: SDK ausente; descarga storage.googleapis.com rechazada403 |
| Tests Dart | 10 escritos, NO EJECUTADOS (5 contrato,5 almacenamiento/sync) |
| `pio run -j 2` | Falló por registry PlatformIO bloqueado403; no se valida esa ruta de build |
| `git diff --check` | Aprobado |
| Supabase remoto/Auth/RLS | NO INSPECCIONADO/NO APLICADO; sin conector; aprobación condicional recibida |
| Radio/GPIO/LEDs/Android físico | NO EJECUTADO; usuario solo tiene placas y pulsador |

Logs locales ignorados por Git en `build/firmware-build.log` y
`build/node-led-variant.log`; herramientas verificadas en `/workspace/tools`.
No se deshabilitó TLS, firmas ni checksums. Las advertencias Arduino sobre
serial/mdns/dfu-discovery corresponden a utilidades de detección USB no instaladas;
no impidieron compilación. No se verifica upload desde este entorno.


### Continuación final — 2026-10-22 (sustituye bloqueos Flutter de la etapa anterior)

| Check | Resultado final |
|---|---|
| Flutter3.29.3/Dart3.7.2 + pub get frozen | APROBADO; pubspec.lock incluido |
| flutter analyze | APROBADO: No issues found |
| flutter test | 17 APROBADOS: contrato5, SQLite/sync/export6, enlace4, widgets2 |
| UI→WebSocket→SQLite | APROBADO con pantalla productiva y servidor de prueba; datos sintéticos |
| Exportación de historial de app | PROBADA en repositorio local; botón copia JSON, sin importación automática |
| Panel navegador | Chromium aprobado: orden manual, métricas, historial durable y export JSON |
| PostgreSQL local | 11 APROBADOS; añadido script de inspección read-only |
| Build APK final | APROBADO con JDK17 y NDK27.0.12077973,18.1s usando caché |
| Firma APK | apksigner verifica v1/v2; no prueba física ni publicación |
| Metadata APK | ar.edu.reakt, versionCode2, minSdk23/target35, arm64/armv7/x86/x86_64 |
| Supabase Auth/REST remoto | Proxy CONNECT403, servicio HTTP000; sin acceso SQL ni cambios remotos |
| Radio, GPIO y Android físico | PENDIENTES; LEDs/fuente no disponibles |

Problemas de setup corregidos: rutas de estado de HOME no escribibles, soname
SQLite faltante, proxy Java, JRE sin javac, NDK exigido por plugins. Se conservaron
TLS y comprobaciones oficiales. Primera descarga NDK27 con SDKManager falló;
archivo oficial verificado contra el índice Android instaló correctamente. No se
cambiaron hashes esperados ni se desactivaron verificaciones. Las primeras pruebas
widget de integración requerían avanzar fake microtasks entre IO real; harness
corregido y suite completa aprobada. Los logs locales permanecen en build/.

## Colegio 23/10/2026

PROBADO: aplicación de migración remota, tres tablas RLS/nueve políticas,
anon sin grants y authenticated sin DELETE; lectura autenticada sin filas propias.
PROBADO: lectura MAC ROM del gateway COM4 (30:c6:f7:92:d0:9c).
PENDIENTE: Auth/login real, upserts/aislamiento remoto con dos usuarios, GPIO/radio,
LED, Android físico, diez sesiones y compilaciones en esta PC.
Evidencia y diferencias de toolchain: [registro](CONTINUACION-COLEGIO-2026-10-23.md).

### Cierre posterior de software

Cuenta Auth confirmada y sesiones Auth presentes; smoke RLS remoto aprobado con
datos sintéticos revertidos (cero filas restantes). Auth API HTTP200 y anon REST
HTTP401. Analyze sin problemas y17tests aprobados en copia para Flutter3.47.4,
sin modificar lock de referencia. Compilaron gateway/core3.3.4 y nodo LED digital
y deshabilitado. No es prueba Android/radio/circuito.
[Resultados, comandos y límites](CIERRE-SOFTWARE-2026-10-23.md).
