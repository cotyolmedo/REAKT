# REAKT Testing Strategy

## Publicación Android y Supabase remoto — 2026-10-23

- Usuario autorizó generar APK y subirlo a GitHub. Rama aislada `codex/android-demo-v0.3.0`; commit de app/workflow `462b853`. Los cambios locales de firmware/PCB no se incluyeron.
- Configuración de compilación mediante variables GitHub Actions: URL de `hvaoezcsgqepcttaznof` y clave pública anon verificada por rol/ref del JWT, sin secretos privilegiados ni sesión de usuario.
- Supabase remoto: Auth settings HTTP200, REST anónimo HTTP401 para las tres tablas, RLS habilitado y nueve políticas con `auth.uid() = user_id`, SELECT/INSERT/UPDATE para authenticated, sin DELETE.
- Reejecutado `backend/remote-rls-smoke.sql` de la base funcional contra el proyecto remoto: escrituras/lecturas, idempotencia, restricciones y aislamiento aprobados bajo rol authenticated con subject de usuario confirmado. Es prueba transaccional SQL, no login de teléfono ni segundo login real. ROLLBACK completado; consulta posterior: cero sesiones/resultados/eventos sintéticos.
- Usuario confirmó que las placas todavía no están configuradas. Endpoint `192.168.4.1:81` no accesible desde esta PC. Conexión física BLOQUEADA por firmware/montaje; no afirmar entrenamiento real conectado. La app queda configurada para el gateway MVP y dispone de pruebas WebSocket locales.
- Intento inicial detectó desborde de cabecera sin fuentes de vista previa: corregido con acción de conectividad compacta. Suite local estándar sin captura: 21 pruebas aprobadas. Intento siguiente confirmó incompatibilidad de Gradle heredado con Flutter 3.47.4.
- Android actualizado a Gradle 8.14.3 (checksum oficial), AGP 8.11.1/Kotlin 2.2.20 y minSdk24. Un intento posterior detectó heap agotado en Jetifier sobre Flutter x86_64: se retira la conversión legacy (dependencias AndroidX) y se asignan 4 GiB/2 workers a Gradle.
- **APK COMPILADO Y PUBLICADO** desde `a6985d2f1846259dbcdbdc0f9df46262784c4a8f`; workflow https://github.com/cotyolmedo/REAKT/actions/runs/39965490097 completado con success. Análisis, 21 pruebas, compilación debug universal y `apksigner verify --verbose` aprobados.
- Release pública de demostración: https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.0-demo.4.1. APK 154267345 bytes, SHA256 `ab2f646c77047784e8a22944a3edfe1f0467f3346a7ebb7408782c33f920c072`. Incluye BUILD-INFO, SHA256SUMS y verificación de firma. No equivale a prueba Android física ni login/sincronización desde el teléfono.
- Verificación posterior del archivo publicado: https://github.com/cotyolmedo/REAKT/actions/runs/39967134053 completado con success. Se descargó el APK desde su URL pública, se cotejó SHA256, se verificó firma y se comprobó dentro del kernel compilado la URL/clave pública Supabase y `ws://192.168.4.1:81`. La descarga local lenta quedó como `.apk.partial`, no se ofrece como APK terminado.

## Adaptación Flutter al demo — 2026-10-23

- Flutter 3.47.4 / Dart 3.13.3 en Windows; dependencias resueltas y lock actualizado según SDK instalado.
- `flutter analyze`: sin incidencias (repetido al cierre).
- `flutter test --dart-define=REAKT_CAPTURE_UI=true --reporter compact`: **21 pruebas aprobadas**. Incluye contrato, SQLite/reapertura, deduplicación/reconexión, protección por fallo de disco, outbox con remoto simulado, exportación, UI desconectada y WebSocket real local de prueba.
- La prueba UI envía `manual` y luego `start` con selección real de 20 rondas/3000 ms, verifica recepción y guardado del snapshot retornado. No equivale a una prueba física ESP32.
- Navegación Inicio/Entrenar/Historial/Progreso/Perfil probada a 320, 390 y 800 px; historial expandible, precisión/reacción derivadas de fixture y progreso vacío sin números ficticios. Se corrigió colisión de PageStorage entre desplazamiento/detalles durante estas pruebas.
- Capturas Flutter a 390x844 generadas en `.school-work/flutter-preview/` con datos sintéticos y fuentes Windows solo en el entorno de pruebas. No son mediciones del hardware.
- `flutter build apk --debug`: **bloqueado**, salida `No Android SDK found`. `flutter doctor -v` confirma falta del SDK; no se instaló toolchain ni se produjo APK de esta versión.
- Pendientes: prueba en teléfono Android, radio/LED/pulsador y firmware compatible con contrato MVP remoto; Supabase/Auth/RLS remoto. No se ejecutó un build ni una prueba iOS/web.
- Los estados anteriores de este documento se mantienen como evidencia histórica; no describen la verificación de la adaptación actual.

## Verificación de la interfaz Flutter — 2026-10-09

- Estado: UNVERIFIED.
- Se revisó estáticamente la estructura de `app/`.
- No fue posible ejecutar `flutter analyze` ni `flutter test` porque el SDK de Flutter no está disponible en este entorno.
- Falta validar el renderizado en Android/iOS y conectar datos reales cuando se defina la interfaz app↔gateway.

## Testing philosophy

Testing must progress from isolated components to complete system integration.

## Firmware tests

### ESP32 ↔ ESP32-C3

Verify:

- node discovery/addressing
- packet transmission
- packet reception
- invalid packets
- lost packets
- timeout behavior
- multiple nodes
- simultaneous events where applicable

### Sensors

For every sensor:

- idle state
- activation
- false trigger behavior
- expected range
- electrical limits

### Actuators

Verify:

- correct output
- timing
- repeated activation
- failure/recovery behavior

## Application tests

Verify:

- screen navigation
- session configuration
- connection states
- malformed data handling
- result visualization
- backend errors
- offline/disconnected behavior where applicable

## Backend tests

Verify:

- schema constraints
- inserts
- reads
- updates
- authorization
- invalid data
- failure handling

## Integration tests

At minimum:

```text
Flutter
  ↓
Gateway
  ↓
ESP32-C3
  ↓
Gateway
  ↓
Flutter
  ↓
Supabase
```

Test both normal operation and communication failures.

## Evidence

When a requirement depends on physical hardware:

- record test conditions
- record expected result
- record actual result
- record date/version when useful
- store photo/video evidence when required by school documentation

Codex must never fabricate physical test results.

## Web REAKT — auditoría Apple

- Se verificaron estáticamente los metadatos Apple, `viewport-fit=cover`, safe areas, navegación móvil y manifest de `REAKT_web.html` el 2026-10-09.
- La verificación visual en Safari sobre iPhone/iPad y el modo Home Screen queda pendiente porque no hay dispositivo Apple disponible en este entorno.
- El detalle de cada cambio está documentado en `cambios pagina.md`.

## PCB V0.1 verification

- KiCad 9 CLI DRC ran on `hardware/pcb/reakt-nodo/reakt-nodo.kicad_pcb` on 2026-10-09.
- Result: file parsed; 0 unconnected pads; 14 silkscreen/library warnings; exit code 0 because violation exit mode was not requested.
- ERC, schematic parity, fabrication review, 3D fit and physical tests: pending because the real component variants and power architecture are TBD.
