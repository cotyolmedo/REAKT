# REAKT Android MVP

Cliente WebSocket con reconexión, entrenamiento coordinado por gateway, snapshots
validados, SQLite y outbox Supabase Auth. No contiene credenciales administrativas.

Ver [instalación completa](../Docs/mvp-installation.md),
[contrato](../Docs/packet-protocol.md) y [backend](../backend/README.md).

SDK de referencia Flutter 3.29.3 / Dart 3.7; Android minSdk23, Java17.
Desde esta carpeta: `flutter pub get`, `flutter analyze`, `flutter test`,
`flutter build apk --debug`, `flutter run`. Lock resuelto incluido, pub get y analyze aprobados. Quince tests Flutter aprobados,
incluyendo SQLite y UI/WebSocket con servidor de prueba. APK debug universal compilado y firmado. Artefactos y
limitaciones en ../Docs/ESTADO-FINAL-MVP.md. No hay prueba física Android ni iOS.

Sin Supabase configurado, conservar sesiones localmente. Con URL HTTPS y clave
pública mediante dart-define se habilita Auth. Contraseña de usuario solo en UI.
El repositorio remoto simulado `MemorySessionRemote` se usa en pruebas de fallo
parcial/reintentos, no suplanta Auth en la aplicación. Las pruebas Dart ya se ejecutaron y aprobaron. El servidor de prueba no valida
ESP-NOW ni el proyecto Supabase remoto.
