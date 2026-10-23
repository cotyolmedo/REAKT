# REAKT Flutter 0.3

App Android adaptada al [demo Impacto](https://app.jotform.com/262674524369669): fondo oscuro/bordó, tarjetas negras y acciones rojas. Inicio, Entrenar, Historial, Progreso y Perfil. Se inspeccionaron el inicio y menú públicos el 23/10/2026; Entrenamiento redirige al login Jotform. La cabecera usa degradado e icono Material en lugar de redistribuir la foto del demo.

Base funcional recuperada de [cotyolmedo/REAKT](https://github.com/cotyolmedo/REAKT/tree/3f34294/app), verificando hashes. Conserva WebSocket, SQLite, exportación JSON y Supabase Auth/outbox. No se modificó firmware ni se desplegó backend.

## Ejecutar

SDK verificado: Flutter 3.47.4 / Dart 3.13.3 (`.fvmrc`). Mínimo Flutter 3.35 / Dart 3.9 por las APIs actuales de presentación. Lock resuelto con el SDK verificado.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --debug
```

Android requiere SDK/NDK/JDK compatibles con `android/`. En esta PC no se encontró Android SDK: no se generó APK nuevo. No hay scaffold ni validación iOS/web/Windows; las pruebas de widgets corren en Windows con SQLite FFI.

## Uso

1. Abrí Iniciar entrenamiento y conectá el teléfono al Wi-Fi del gateway MVP.
2. Confirmá el endpoint (`ws://192.168.4.1:81`) y conectá. Se exige snapshot válido, no basta abrir el socket.
3. Elegí 5/10/20/30/50 rondas y 0,5/1/1,5/3/5 segundos. Iniciá Reflejos, probá una ronda manual de 5 segundos o detené la sesión activa.
4. Revisá métricas e historial desplegable. Exportá JSON antes de cambiar de instalación; no se implementó importación.
5. Progreso agrega solo sesiones completadas: precisión por aciertos/fallos y reacción ponderada por eventos de acierto. Sin datos muestra `—`; no inventa velocidad, resistencia ni rachas.
6. Perfil conserva login y sincronización. Sin nube configurada permite entrenamiento y almacenamiento locales.

## Compatibilidad

La arquitectura prevista tiene cinco nodos, pero **el contrato MVP remoto admite dos peers**. El firmware local conserva cambios previos ajenos a esta adaptación: comprobar compatibilidad antes de una prueba física. `nodes` son peers configurados, no presencia confirmada. Ver [contrato MVP](https://github.com/cotyolmedo/REAKT/blob/3f34294/Docs/packet-protocol.md).

Los demás modos quedan pendientes. El contrato terminal no distingue manual/reflejos: el historial lo llama «Sesión».

Supabase usa `SUPABASE_URL` y `SUPABASE_ANON_KEY` por `--dart-define` o archivo público excluido de Git. Nunca agregar service_role ni contraseñas al código. Se conserva la advertencia de asignación de sesiones sin propietario a la cuenta al sincronizar. Tablas/RLS y pruebas remotas siguen siendo requisitos externos.

Evidencia en `../Docs/testing.md`. La opción de tests `--dart-define=REAKT_CAPTURE_UI=true` genera capturas con datos sintéticos en `../.school-work/flutter-preview/`; usa fuentes Windows únicamente para esa captura opcional.
