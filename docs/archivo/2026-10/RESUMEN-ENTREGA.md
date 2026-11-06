# Resumen de entrega — 22/10/2026

## Código y validación

- Firmware de gateway y uno/dos nodos WROOM-32 compilado con Arduino-ESP322.0.17.
- Protocolo compartido32bytes, CRC, ACK, reintentos y deduplicación; pulsador con
  debounce, reloj monotónico, LED opcional. WebSocket y entrenamiento en gateway.
- Flutter Android con conexión/reconexión, métricas, SQLite, exportación JSON,
  cliente Auth y sincronización diferida.17tests y analyze aprobados.
- APK debug0.2.0, paquete ar.edu.reakt, minSdk23/target35, firma verificada.
  Sin credenciales Supabase configuradas, sin prueba en teléfono físico.
- Once pruebas PostgreSQL aislado aprobadas para migración/RLS/inspección metadata.
- Simulación C++ de diez sesiones con pérdidas; panel de diagnóstico navegador
  probado con persistencia y exportación. No equivalen a validación física.

## Pendientes

Supabase remoto no fue inspeccionado ni modificado: conector sin herramientas y
proxy CONNECT403. Proyecto indicado por el usuario:
https://hvaoezcsgqepcttaznof.supabase.co. Autorización vigente para aplicar la
migración preparada tras inspección y solo sin conflictos; no requiere repetirse.
Faltan Auth real, esquema remoto compatible, persistencia/sync y RLS remotos.

Solo hay placas y pulsador. GPIO/MAC/cargas deben verificarse físicamente. LEDs y
alimentación faltan; salida LED deshabilitada. Falta prueba de radio, Android real
y diez sesiones físicas. No presentar tiempos sin LEDs como reacción visual validada.

## Git y entrega

El usuario autorizó el commit y push de esta entrega con el mensaje exacto:
`Cambios mayores, progreso considerable`.
Base anterior: `840c9b30bd9f1d3e5496ddac2a06956cbe06e3a9`.
El identificador de entrega se obtiene con `git log -1 --oneline` en main actualizado.
Código, lock, pruebas y documentación entran al commit; SDKs, builds, claves y
configuraciones locales quedan fuera. El APK se descarga aparte del código.

Para comparar con el estado anterior puede abrirse ese commit sin mover main.
Si se necesita deshacer una entrega ya compartida, preferir un revert revisado que
conserve el historial; cambiar de commit localmente no revierte la base de datos
ni el firmware cargado. No se necesita force push para conservar esta referencia.

## Mañana

Abrir `GUIA-COLEGIO-2026-10-23.md`, conservar evidencia en
`registro-pruebas-colegio.md` y copiar el prompt de `PROMPT-PARA-MANANA.md`.
Dar acceso a la computadora no garantiza acceso a Supabase, drivers, puertos o
permisos administrativos: comprobar cada capacidad y avanzar con las disponibles.
La guía permite empezar con el navegador antes de instalar Android.
