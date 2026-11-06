# REAKT

Proyecto integrador de entrenamiento interactivo de la E.E.S.T. N.º 4. Fecha objetivo de entrega: **6 de noviembre de 2026**.

**Versión de aplicación vigente: 0.3.1+4 (Android 7+).** [Descargar APK 0.3.1](https://github.com/cotyolmedo/REAKT/releases/download/v0.3.1/REAKT-0.3.1-android.apk) · [Release y verificación](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1) · [Sitio web](https://cotyolmedo.github.io/REAKT/).

## Arquitectura

Flutter Android ↔ WebSocket local ↔ ESP32 WROOM-32 gateway ↔ ESP-NOW ↔ uno o dos nodos ESP32 en el MVP. La ampliación propuesta a cinco nodos, LEDs WS2812B y batería recargable aún no está validada.

## Carpetas principales

- `app/`: app Flutter 0.3.1, proyecto Android y pruebas.
- `firmware/`: gateway, nodo y biblioteca compartida. Los `main.cpp` son puentes para PlatformIO, no versiones anteriores.
- `backend/`: migración SQL, autorización y pruebas de RLS.
- `hardware/`: diseños conceptuales CAD/PCB, no validados para fabricación.
- `tests/`: pruebas automatizadas vigentes; `tools/`: herramientas de compilación y diagnóstico.
- `assets/`: recursos de marca y capturas; `Docs/`: documentación técnica, evidencia y documentos históricos de entrega.
- `REAKT_webv2.html`: única fuente de la web pública, publicada por GitHub Pages.

Los recursos de marca en `assets/brand/` y `app/assets/brand/` se duplican intencionalmente porque web y Flutter los empaquetan por separado. Los APK antiguos ya no están almacenados en `downloads/`; la distribución vigente se hace desde GitHub Releases. Las versiones anteriores siguen recuperables mediante el historial de Git.

## Estado verificado y pendientes

El informe de banco registra una sesión real con un gateway, un nodo, pulsador en GPIO18 y LED común en GPIO23, y sincronización Android con Supabase de 11 sesiones/11 resultados/28 eventos. Se documentaron 21 tests Flutter aprobados en la publicación anterior. La release 0.3.1 pasó análisis, tests, compilación Android y comprobación de firma en CI, según [evidencia del 30/10](Docs/android-release-2026-10-30.md).

Siguen pendientes las diez sesiones físicas consecutivas, la prueba de aislamiento entre dos cuentas reales, la ampliación de nodos, el LED WS2812B, la alimentación recargable y la validación de PCB/CAD. No confundir simulaciones con mediciones físicas.

## Empezar y desarrollar

- [Guía vigente de pruebas](Docs/PROBAR-HOY.md) y [montaje de protoboard](Docs/MVP-PROTOBOARD.md).
- [Instalación y pinout](Docs/mvp-installation.md) · [protocolo](Docs/packet-protocol.md) · [pruebas físicas](Docs/mvp-physical-tests.md).
- [Aplicación Android](app/README.md) · [firmware](firmware/README.md) · [backend](backend/README.md) · [documentación](Docs/README.md).
- Tests locales: `./tools/test-core.sh`, `python3 tests/test_mock_gateway.py`, `python3 tests/test_backend.py` (dependencias/servicios según documentación). En `app/`: `flutter analyze` y `flutter test`.

No poner credenciales ni MAC reales en Git. Leer [AGENTS.md](AGENTS.md) antes de modificar subsistemas.
