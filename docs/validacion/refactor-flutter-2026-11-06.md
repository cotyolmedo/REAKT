# Refactorización Flutter, fase independiente — 06/11/2026

## Alcance

Rama `refactor/flutter-modular-2026-11`, basada en la rama de reorganización
`chore/reorganizacion-2026-11`. No se modificó `main`, el protocolo, SQLite,
Supabase ni las pantallas visibles.

`app/lib/main.dart` conserva el punto de entrada público e importa cinco módulos
`part`: inicio, `ReaktApp`, tema, destinos de navegación y pantalla de
entrenamiento. Los componentes y modelos de presentación y los servicios siguen
en sus archivos anteriores. Esta etapa separa las responsabilidades principales
sin cambiar `ReaktApp` ni `TrainingPage`, que las pruebas importan desde `main.dart`.

El workflow Android se ejecutará también para pull requests que modifiquen `app/`.
Su trabajo de publicación solo corre para `workflow_dispatch`, por lo que un PR no
crea una Release.

## Evidencia y límites

| Verificación | Estado | Resultado |
|---|---|---|
| Reconstrucción textual del `main.dart` anterior | APROBADO | El cuerpo anterior coincide exactamente tras devolver las expresiones extraídas de tema y navegación |
| Cinco rutas `part of` y archivos | APROBADO | Todos apuntan a la biblioteca `main.dart` |
| Parser Dart y YAML | APROBADO | Cero errores sintácticos en `app/lib/**/*.dart` y workflow Android |
| `git diff --check` | APROBADO | Sin errores de whitespace |
| `flutter analyze` | NO EJECUTADO | Flutter SDK ausente en este entorno |
| `flutter test` | NO EJECUTADO | Flutter SDK ausente en este entorno |
| `flutter build apk` | NO EJECUTADO | Flutter/Android SDK ausentes en este entorno |
| Comparación visual en dispositivo | NO EJECUTADO | Sin dispositivo ni SDK |

El parser confirma sintaxis, no resuelve tipos ni ejecuta widgets. El PR de esta
rama debe comprobar analyze, test y build antes de fusionarse. El workflow existente
usa variables públicas de Supabase configuradas en GitHub; nunca se copiaron a Git.

## Continuación

Tras validar este corte, una fase posterior puede extraer cada pantalla de la
clase de estado mediante constructores y callbacks explícitos. Esa extracción
requiere pruebas Flutter y comparación visual por pantalla, especialmente al
compartir `GatewayLink`, historial, navegación y autenticación. No se introdujo
una capa nueva que altere su ciclo de vida sin poder ejecutar esas pruebas.
