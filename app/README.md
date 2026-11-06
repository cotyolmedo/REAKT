# REAKT Flutter 0.3.1

Aplicación Android de entrenamiento REAKT: Inicio, Entrenar, Historial, Progreso y Perfil. Incluye WebSocket local, SQLite, exportación JSON y sincronización autenticada con Supabase. La versión **0.3.1+4** incorpora la identidad visual original en cabecera, inicio e icono Android.

## Versión vigente

- [Descargar APK 0.3.1](https://github.com/cotyolmedo/REAKT/releases/download/v0.3.1/REAKT-0.3.1-android.apk) · [Release oficial y SHA256](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1) · [Informe de publicación](../Docs/android-release-2026-10-30.md).
- Android 7.0/API24+, Flutter 3.47.4 (archivo `.fvmrc`), Dart 3.13.3, JDK 17. El APK publicado es debug y su firma puede diferir de anteriores: exportar historial JSON antes de reemplazar una instalación; no desinstalar sin preservar los datos.
- CI aprobó `flutter analyze`, tests, compilación Android y verificación de firma para la release 0.3.1. Esto no equivale a validar físicamente todo el hardware.

## Desarrollo

Desde `app/`:

```sh
flutter pub get --enforce-lockfile
flutter analyze --no-pub
flutter test --no-pub
flutter run
flutter build apk --debug
```

Para compilar una APK con nube, usar variables públicas `SUPABASE_URL` y `SUPABASE_ANON_KEY` con `--dart-define` o archivo local excluido de Git; nunca incorporar `service_role` ni contraseñas. La release publicada contiene la configuración pública. La compilación publicada se hizo en GitHub Actions.

## Uso

1. Conectar el teléfono al Wi-Fi `REAKT-MVP` del gateway y confirmar `ws://192.168.4.1:81`. Esperar un snapshot válido antes de enviar órdenes.
2. Elegir 5/10/20/30/50 rondas, con 0,5/1/1,5/3/5 segundos. Entrenar o hacer prueba manual y detener cuando corresponda.
3. Consultar métricas, historial y progreso; exportar JSON antes de actualizar. Actualmente no hay importador.
4. Para sincronizar, volver a una red con Internet, iniciar sesión desde Perfil y sincronizar. No se requieren claves privadas en Android.

## Compatibilidad y pendientes

La arquitectura futura contempla cinco nodos; el protocolo MVP actual admite **uno o dos peers**. Firmware de gateway y nodo comparten contrato, y la salida del nodo admite LED deshabilitado, LED digital o WS2812B. Siguen pendientes pruebas físicas extendidas, validación de WS2812B/batería y aislamiento Supabase con dos cuentas reales. El historial llama «Sesión» al modo del contrato terminal.

Ver [guía operativa](../Docs/PROBAR-HOY.md), [protocolo](../Docs/packet-protocol.md) y [evidencia](../Docs/testing.md).
