# Informe técnico de reorganización — 06/11/2026

## A. Resumen ejecutivo

Se integró el código vigente del detector piezoeléctrico, se conservaron los ensayos
con pulsador como historia y se ordenaron documentación, recursos y sitio web.
La rama independiente preserva los ZIP 0.2.0 y los cuatro workflows. La validación
física del piezo, el montaje final y la refactorización Flutter siguen pendientes.

## B. Estado inicial y final

Base: `origin/main` en `c41c62d1c95877bccd2171884142ef7f0d4bb628`, checkout
inicial limpio. Rama: `chore/reorganizacion-2026-11`. La etiqueta local
`respaldo/reorganizacion-main-20261106` apunta al SHA base. Había 145 archivos
rastreados. El diff completo y su número final de rutas se obtienen con
`git diff --name-status -M origin/main...HEAD`; Git detecta los movimientos.
`main` no se modificó. La nueva estructura usa `docs/` por subsistema,
`tests/historicas/`, `web/`, `assets/marca/`, `assets/aplicacion/` y
`assets/equipo/`. Se conservan `app/`, `firmware/`, `backend/`, `hardware/`,
`tools/`, `tests/` y las rutas obligatorias de PlatformIO y Flutter.

## C. Ramas

| Rama remota | SHA abreviado | Exclusivos | Clasificación y recomendación |
|---|---|---:|---|
| `main` | `c41c62d` | 0 | Base; conservar |
| `codex/piezo-io34-diagnostics-20261106` | `9e3285d` | 3 | Código integrado selectivamente; revisar y conservar informes posteriores hasta cerrar validación |
| `cleanup/final-files-2026-11-05` | `ab21e1b` | 1 | Limpieza selectiva; conservar por ahora, no aplicar borrados masivos |
| `codex/limpieza-repositorio` | `0aa7225` | 2 | Histórica; conservar hasta comparar el PR; no aplicar borrados de bitácoras |
| `codex/guardar-app-local-20261023` | `c74d54e` | 1 | Trabajo funcional ya representado en main; candidata a archivar luego |
| `codex/integracion-reakt-20261023` | `2e50b0c` | 0 | Incorporada; candidata a eliminar posteriormente |
| `codex/android-demo-v0.3.0` | `19a6334` | 0 | Incorporada; candidata a eliminar posteriormente |

Ninguna rama remota fue eliminada. Las ramas con commits exclusivos conservan sus
referencias remotas. La recomendación de eliminación requiere revisión humana.

## D. Archivos

- Creados: `.agent/reorganizacion-2026-11.md`, este informe y los componentes
  `Piezo.h`, `PiezoInput.h`, `SampleClock.h`, `tests/piezo_test.cpp`, además de dos
  guías de piezo incorporadas desde la rama especializada.
- Modificados: nodo ESP32, configuración local de ejemplo, scripts de compilación
  y pruebas, `AGENTS.md`, `README.md`, enlaces Markdown y `pages.yml`.
- Movidos: documentos de `Docs/` a `docs/`, sketches de `Tests/` a
  `tests/historicas/`, HTML y manifest a `web/`, recursos compartidos a nombres
  españoles. `Docs/README.md` se reemplazó por un índice actualizado en `docs/README.md`.
- Archivados: informes y guías fechados de octubre en `docs/archivo/2026-10/`;
  también el prototipo `REAKT_web.html`.
- Eliminados definitivamente: ninguno. Los dos ZIP 0.2.0 siguen en `downloads/`.

## E. Documentación

El índice `docs/README.md` enlaza inicio, arquitectura, especificaciones, firmware,
aplicación, backend, hardware, validación, historial y archivo. `AGENTS.md` y el
README raíz distinguen piezo vigente del banco anterior con pulsador y la ampliación
futura a cinco nodos. Los informes anteriores retienen sus fechas y resultados.
Quedan por decidir pinout eléctrico final, protección ADC, montaje piezo y si el
pulsador satisface requisitos escolares; no se reinterpretó evidencia anterior.

## F. Firmware

Se integró el commit funcional `0fc6e1a` de la rama piezo. El nodo usa la entrada
ADC propuesta IO34, umbral inicial 600 y LED propuesto IO33, con compuertas de
validación y pruebas sintéticas. El gateway y el protocolo radio/WebSocket no se
modificaron. `firmware/gateway/main.cpp` y `firmware/nodes/main.cpp` siguen en su
ruta para PlatformIO. El banco con pulsador GPIO18/LED23 es histórico. No hubo
validación física nueva ni afirmación de que el circuito piezo sea seguro.

## G. Web y Android

`web/index.html` es la fuente del sitio; `pages.yml` copia los recursos compartidos
y genera también `/REAKT_webv2.html` para enlaces públicos antiguos. Las rutas
relativas de la fuente y del paquete Pages fueron verificadas localmente. El
workflow Android, el de Releases y el verificador de APK se conservaron sin
publicación nueva. La compilación Android requiere Flutter y SDK, no instalados en
este entorno. Los APK publicados previamente no se alteraron.

## H. Pruebas

| Comando o comprobación | Estado | Resultado o límite |
|---|---|---|
| `git diff --check` | APROBADO | Sin espacios o conflictos de diff |
| `./tools/test-core.sh` | APROBADO | Protocolo, 10 sesiones sintéticas y detector piezo |
| `python3 tests/test_mock_gateway.py` | APROBADO | 2 pruebas |
| `python3 tests/test_browser_diagnostics.py` | APROBADO | Navegador, WebSocket, historial y JSON |
| `/tmp/reakt-audit-venv/bin/python tests/test_backend.py` | APROBADO | 11 pruebas PostgreSQL locales |
| `python3 tools/export-school-package.py --output /tmp/reakt-reorganizacion-auditoria.zip` | APROBADO | 169 entradas verificadas en ZIP fuera del repositorio |
| `cd downloads && sha256sum -c SHA256SUMS.txt` | APROBADO | Dos ZIP históricos íntegros |
| Enlaces Markdown y rutas web, HTML, manifest, paquete Pages | APROBADO | Cero enlaces locales rotos; 20 referencias web comprobadas en fuente y publicación simulada |
| PlatformIO gateway/nodo | NO EJECUTADO COMPLETO | Descarga de `espressif32@6.9.0` no terminada; no se obtuvo compilación |
| `flutter analyze`, `flutter test`, APK | NO EJECUTADO | Flutter/Android SDK no disponibles en este entorno |
| Pruebas físicas | NO EJECUTADO | No hay hardware conectado aquí |

El ensayo del workflow Pages reproduce la preparación de archivos; no equivale a
un despliegue real de GitHub Pages. Los tests de PostgreSQL son locales.

## I. Commits

Consultar `git log --oneline origin/main..HEAD`. Se separaron la integración piezo,
el inventario inicial, los movimientos estructurales y este cierre de validación.

## J. Riesgos y pendientes

GitHub GraphQL respondió `Forbidden` al consultar Releases, por lo que no se pudo
verificar distribución alternativa para los ZIP 0.2.0 y se conservaron. Los
documentos archivados mencionan rutas y estados históricos por trazabilidad.
Las pruebas sintéticas del piezo no sustituyen medición de señal, protección
eléctrica ni ensayo de diez sesiones físicas. Las dependencias PlatformIO/Flutter
deben instalarse para cerrar compilaciones. No se escribieron secretos ni MAC.

## K. Refactorización Flutter

Segunda fase en rama y PR independientes después de revisar la estructura. Orden:
extraer inicialización desde `app/lib/main.dart`; luego navegación y tema;
pantallas Inicio, Entrenar, Historial, Progreso y Perfil; componentes y modelos;
finalmente servicios locales, sync Supabase y gateway. Conservar `app/lib/main.dart`,
`app/test/`, rutas de recursos, API y apariencia. Aceptación: `flutter analyze`,
`flutter test`, build APK, comparación visual y datos locales/sync sin regresiones.

## L. Próximas acciones

Revisar el diff de la rama frente a `main`, sus movimientos y los resultados de
CI del PR. En una máquina con PlatformIO/Flutter, compilar ambos objetivos y APK.
Si el PR está aprobado, fusionarlo mediante la interfaz de GitHub sin reescribir
historial. Solo después de verificar main y las referencias exclusivas, decidir
el archivo o eliminación de ramas redundantes; nunca borrar Releases ni binarios
sin distribución alternativa verificada.
