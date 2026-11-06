# REAKT

Entrenamiento interactivo de la E.E.S.T. N.º 4: **Flutter Android → WebSocket
local → gateway ESP32 → ESP-NOW → nodos con pulsador**.

## Usar el sistema

1. [Descargar APK 0.3.1 y checksums](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1).
2. Seguir la [guía de puesta en marcha](Docs/PROBAR-HOY.md).
3. Montar el [banco de pruebas](Docs/MVP-PROTOBOARD.md) y registrar los
   [resultados físicos](Docs/mvp-physical-tests.md).

[Web del proyecto](https://cotyolmedo.github.io/REAKT/) ·
[Documentación](Docs/README.md) ·
[Evidencia de la versión 0.3.1](Docs/android-release-2026-10-30.md)

## Estructura

| Ruta | Contenido |
|---|---|
| `app/` | Aplicación Flutter para Android |
| `firmware/` | Gateway, nodos y biblioteca compartida |
| `backend/` | Migración SQL, RLS y herramientas de inspección |
| `hardware/` | CAD y PCB conceptuales; pendientes de validación |
| `tests/` | Pruebas de software; `historical/` conserva ensayos antiguos |
| `tools/` | Compilación, simulación, diagnóstico y exportación |
| `Docs/` | Guías, requisitos, decisiones y evidencia |
| `index.html`, `assets/`, `manifest.webmanifest` | Sitio público |
| `.github/`, `.agent/`, `.codex/` | Automatización y desarrollo |

## Estado comprobado

El banco con un gateway y un nodo tuvo sesiones manuales desde Android.
La sincronización con Supabase fue comprobada; diez sesiones físicas completas,
aislamiento con dos cuentas reales, WS2812B y alimentación recargable siguen
pendientes. El MVP contempla uno o dos nodos; cinco nodos es una ampliación.
La versión 0.3.1 actualiza la marca visual; no demuestra nuevas pruebas físicas.

## Desarrollo

Leer [AGENTS.md](AGENTS.md) y la [documentación](Docs/README.md).
Las instrucciones de cada componente están en su README.

- Firmware/simulación: `./tools/test-core.sh`.
- Contrato WebSocket: `python3 tests/test_mock_gateway.py`.
- Migración y RLS local: `python3 tests/test_backend.py` (pgserver en Linux).
- Flutter: seguir [app/README.md](app/README.md).

Dependencias Python en `tools/requirements-dev.txt`. Configuración local y claves
se mantienen fuera de Git. Los binarios se distribuyen en Releases; las entregas
antiguas y planes se agrupan en [el historial](Docs/historial-entrega.md).
