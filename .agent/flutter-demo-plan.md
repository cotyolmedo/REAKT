# Adaptación Flutter al demo Impacto

## Objective
Adaptar REAKT Android al inicio y navegación del demo Jotform, conservando entrenamiento, SQLite, exportación y sincronización existentes.

## Current state
La copia local contenía un shell estático. GitHub `cotyolmedo/REAKT`, `main` en `3f34294`, contiene el MVP funcional. Se recuperaron exclusivamente archivos `app/`, comprobando sus hashes Git contra esa referencia; los cambios locales de firmware se conservan.

## Requirements
Inicio, Entrenamiento, Historial, Progreso y Perfil; acciones conectadas; métricas derivadas de snapshots; configuración dentro del contrato MVP; errores y desconexión visibles.

## Constraints
Sin credenciales nuevas, sin cambios radio/backend, sin commit/push. Cinco nodos en arquitectura prevista; MVP remoto admite hasta dos. No afirmar presencia de nodos a partir de peers configurados.

## Design
Conservar GatewayLink, LocalStore, TrainingSnapshot y CloudSync. Presentación oscura/bordó/roja, tarjetas y acción principal inspiradas en el demo. Las otras páginas del demo requieren autenticación Jotform: se implementan según el flujo REAKT documentado.

## Implementation steps
- [x] Leer documentación y recuperar base remota verificada.
- [x] Inspeccionar inicio y menú del demo en navegador.
- [x] Implementar navegación y presentación conectadas a servicios existentes.
- [x] Analizar, ejecutar tests e intentar compilación Android.
- [x] Documentar evidencia y límites.

## Validation
Flutter analyze, pruebas existentes de contrato/SQLite/gateway y pruebas UI de navegación, configuración, estados vacíos y comandos WebSocket. Compilación si toolchain Android disponible.

## Documentation changes
app/README.md, Docs/app.md, decisions.md, roadmap.md y testing.md.

## Risks and rollback
La base local del firmware es anterior al contrato remoto; no mezclar versiones durante pruebas físicas. Revertir únicamente archivos de esta adaptación si se requiere; no tocar cambios ajenos. El demo no da acceso anónimo a Entrenamiento.

## Status
Implementación y pruebas locales completas: analyze sin incidencias y 21 tests aprobados. APK bloqueado por Android SDK ausente. Sin validación física ni nube remota. Ver Docs/testing.md.
