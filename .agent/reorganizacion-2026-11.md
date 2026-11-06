# Auditoría y plan de reorganización — 06/11/2026

## Referencias y recuperación

- `origin/main`: `c41c62d1c95877bccd2171884142ef7f0d4bb628`.
- Rama de trabajo: `chore/reorganizacion-2026-11`, creada desde ese SHA.
- Etiqueta local de recuperación: `respaldo/reorganizacion-main-20261106`, verificada con `git rev-parse` antes de publicar.
- El checkout inicial `work` estaba limpio y apuntaba al mismo SHA que `main`.
- No se eliminarán ramas, etiquetas, Releases ni objetos históricos.

| Rama remota | SHA | Commits propios frente a main | Criterio |
|---|---|---:|---|
| `main` | `c41c62d` | 0 | Base inalterada |
| `codex/piezo-io34-diagnostics-20261106` | `9e3285d` | 3 | Integrar código y conservar informes; revisar commits documentales posteriores |
| `cleanup/final-files-2026-11-05` | `ab21e1b` | 1 | Aprovechar correcciones puntuales; rechazar eliminación de evidencia, ensayos y workflows |
| `codex/limpieza-repositorio` | `0aa7225` | 2 | Revisar rutas web; rechazar eliminación masiva de documentación y planes |
| `codex/guardar-app-local-20261023` | `c74d54e` | 1 | Histórica; su contenido funcional ya figura en main |
| `codex/integracion-reakt-20261023` | `2e50b0c` | 0 | Histórica, incorporada |
| `codex/android-demo-v0.3.0` | `19a6334` | 0 | Histórica, incorporada |

Los conteos son `git rev-list origin/main..rama`. Los archivos históricos y binarios siguen recuperables por Git; esto no equivale a un respaldo externo.

## Inventario de impacto

- 145 archivos rastreados al inicio, incluidos cuatro workflows, dos sketches históricos en `tests/historicas/`, pruebas automáticas en `tests/`, dos HTML principales y dos ZIP 0.2.0 en `downloads/`.
- `platformio.ini` depende de `firmware/` y de `main.cpp` en gateway/nodo.
- Flutter depende de `app/lib`, `app/test` y recursos bajo `app/assets/brand`.
- Pages copia `REAKT_webv2.html`, `manifest.webmanifest` y `assets/`; el enlace público histórico `/REAKT_webv2.html` debe conservarse.
- Los HTML usan rutas relativas `assets/brand`, `assets/app`, `assets/team`; se verificarán tras mover el sitio.
- Los ZIP históricos suman cerca de 88 MB; sus enlaces públicos pueden existir fuera del repositorio. Se conservarán salvo distribución alternativa comprobada.
- `docs/` contiene estado vigente y documentación de octubre. Se moverá conservando el contenido; los informes fechados irán al archivo histórico.

## Orden y controles

1. Integrar piezo desde el commit funcional de la rama especializada, sin declarar prueba física nueva.
2. Mover ensayos históricos, documentación y web con `git mv`; reparar rutas y enlaces.
3. Preservar binarios y workflows; actualizar solo rutas cuyo cambio sea necesario.
4. Ejecutar pruebas disponibles, revisar referencias rotas, secretos y diffs; registrar resultados reales.
5. Proponer refactor Flutter en otra rama después del PR estructural, sin mezclarla aquí.
