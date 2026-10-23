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
- [x] Diagnóstico MAC corregido, ambos roles cargados y hashes/arranque comprobados.
- [x] Usuario armó nodo GPIO18/23 con pulsadorNA y LED común con resistencia.
- [x] Primera sesión física: LED/pulsador/acierto observado por usuario y hit1/miss0 en serial.
- [x] Usuario confirmó mantener sin duplicados, timeout5s, stop/LED apagado e historial tras reapertura.
- [x] Serie confirmó Cancelada con objetivo desactivado y sin errores de radio registrados.
- [x] Usuario confirmó doble sincronización sin duplicados; SQL remoto:11sesiones/11resultados/28eventos, sin sesiones sin resultado.
- [x] Integración y banco básico cerrados; límites extendidos documentados en Docs/banco-2026-10-23.md.
