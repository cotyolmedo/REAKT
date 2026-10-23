# Integrar el repositorio — 23/10/2026

## Objetivo
Unificar app publicada, firmware MVP y guías actuales en main, preservando fuentes
locales e historial sin publicar configuraciones privadas.

## Estado inicial
main local divergente (6 propios, 2 remotos); APK en codex/android-demo-v0.3.0;
firmware de banco en codex/colegio-mvp-20261023; app equivalente guardada también
en codex/guardar-app-local-20261023. Gateway raíz modificado con otro proyecto.

## Requisitos y restricciones
No cambiar protocolo/esquema, GPIO ni MAC. No declarar pruebas físicas realizadas.
Respaldo local del archivo ajeno; sin claves en Git. Sin force push ni borrar ramas.

## Diseño y pasos
Integrar sobre la rama Android (descendiente de origin/main), fusionar colegio,
conservar ambas bitácoras y crear PROBAR-HOY. Validar app/firmware/herramientas,
publicar rama y avanzar main normalmente. Reubicar checkout raíz en main actualizado
con respaldo previo de cambios ajenos y rama histórica local.

## Validación
Comparación de código Flutter con ambas ramas, analyze/test, compilaciones Arduino
de nodo Off/Digital y gateway, sintaxis de herramientas, diff/check y revisión de
archivos secretos excluidos. Registrar resultados en Docs/testing.md antes de cerrar.

## Documentación y riesgos
README y PROBAR-HOY son entradas actuales. Historiales conservados; respaldo
PILLDROP local con SHA256 comprobado. No publicar configuraciones privadas.

## Estado
- [x] Fusionar colegio en rama Android y conservar ambas bitácoras.
- [x] Flutter21tests/analyze, simulador2tests y tres compilaciones Arduino aprobados.
- [x] Guías/enlaces y exclusiones revisados.
- [x] Integración publicada en main2e50b0c; copia principal sincronizada y limpia.
- [x] Android CI de main aprobado (run40010186970); sin publicar otro APK.
- [x] Identificar y respaldar gatewayCOM4 y nodoCOM19 (4MB cada uno).
- [x] Gateway cargado, hashes verificados y app conectada según confirmación del usuario.
- [~] Corregir diagnóstico MAC al arranque con core3.x y cargar versión final en ambos roles.
- [~] Usuario arma nodo GPIO18/23 con pulsadorNA y LED común con resistencia.
- [ ] Probar radio/LED/pulsador desde app; registrar lo observado, sin inventar métricas.
