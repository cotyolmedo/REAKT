# Prompt para retomar REAKT en el colegio — 23/10/2026

Copiar el bloque siguiente en la sesión conectada a la computadora. El acceso real
será el que expongan las herramientas y permisos; no asumir acceso total por texto.
No incluir contraseñas ni tokens en el mensaje.

```text
Continuá como ingeniero principal del MVP REAKT en esta computadora del colegio.
Repositorio: cotyolmedo/REAKT, main. La entrega tiene el commit con mensaje exacto
“Cambios mayores, progreso considerable”. Primero verificá Git, el checkout y las
herramientas disponibles. No sobrescribas cambios locales ni hagas reset/force push.

Leé AGENTS.md, Docs/RESUMEN-ENTREGA.md, Docs/ESTADO-FINAL-MVP.md,
Docs/implementation-log.md, Docs/packet-protocol.md y
Docs/GUIA-COLEGIO-2026-10-23.md. No reinicies el trabajo desde una auditoría antigua.
La bitácora contiene intentos fallidos ya corregidos; el estado final es la referencia.

Objetivo: Flutter Android → WebSocket local → gateway ESP32 WROOM-32 → ESP-NOW →
uno o dos nodos → pulsador/WS2812B → gateway → Flutter → SQLite → Supabase.
Gateway coordina entrenamiento; nodo mide reacción con reloj monotónico. Sin delay().
No inventes MAC ni pinout verificado. GPIO18 y GPIO23 son propuestas por comprobar.
Hasta ahora solo tenemos placas y pulsador: LED_ENABLED debe seguir en0 hasta
conseguir y validar LEDs, alimentación y adaptación de nivel. Preguntá únicamente
por componentes o conexiones que no puedas comprobar y bloqueen una prueba concreta.

Ya se logró: firmware nodo/gateway compilado con Arduino-ESP32 2.0.17; protocolo
CRC/ACK/reintentos/dedup; pruebas C++ y diez sesiones simuladas; app con reconexión,
SQLite, exportación JSON, Auth/sync;17tests Flutter y analyze aprobados;11tests SQL
locales; panel de banco Chromium probado; APK debug0.2.0 compilado y firmado.
No se probó hardware, Android físico ni Supabase remoto. No confundas simulación con
mediciones reales. Los SDK de /workspace/tools pertenecen al cloud anterior:
no asumas que existen aquí. Prepará Flutter3.29.3/Dart3.7.2, JDK17 completo con
javac, Android SDK35/NDK27.0.12077973 y dependencias según el SO/permisos reales.
Usá app/pubspec.lock; no regeneres el proyecto ni reemplaces código funcional.

Prioridad1: intentar conexión e inspección de Supabase reakt,
URL https://hvaoezcsgqepcttaznof.supabase.co.
El conector anterior no exponía herramientas y el proxy devolvía CONNECT403.
Comprobá ahora herramientas conectadas, red y nombres/presencia de credenciales,
sin imprimir valores. Reutilizá acceso existente. No pidas secretos por chat.
Podés usar backend/inspect-readonly.sql para metadata del proyecto correcto.

YA AUTORICÉ aplicar backend/migrations/20261022_001_reakt_mvp.sql TRAS INSPECCIÓN
Y SOLO SI NO HAY CONFLICTOS. No vuelvas a pedirme autorización para ese mismo
cambio compatible. Si encontrás conflictos o necesitás otro cambio estructural/de
seguridad, prepará el cambio revisable y pedí aprobación específica. No borres datos,
no desactives RLS y nunca uses service_role/secret en Flutter. Verificá identidad
real del proyecto antes de cualquier escritura. Prepará/creá el usuario de pruebas
con el flujo Auth autorizado, sin inventar credenciales ni publicarlas.

Configurá la app con URL y clave pública en supabase-public.json local ignorado,
partiendo del ejemplo. Probá Auth, sesión offline, reconexión a Internet, upserts
idempotentes, reintentos y aislamiento con otro usuario. Si falta acceso remoto,
continuá con SQLite, repositorio simulado y pruebas de banco mientras se resuelve.

Prioridad2: herramientas, drivers oficiales, USB y placas. Identificá puertos y
station MAC reales, roles y configuración local. Antes de cargar firmware,
confirmá qué placa/puerto corresponde a gateway y nodo; no flashees a ciegas.
Verificá el GPIO del pulsador con el circuito real. Probá primero un nodo:
ACK, pulsación única, mantener/soltar, timeout, detener, pérdida de radio y recuperación.
El panel tools/web-diagnostics permite avanzar sin Android y exporta evidencia JSON.
Después instalá/probá Flutter en el teléfono, almacenamiento tras reiniciar y nube.
El APK debug de otra computadora puede tener firma distinta: resguardá historial
antes de cambiar de instalación y no desinstales ni borres datos automáticamente.

Avanzá de forma autónoma por todo lo autorizado, sin detenerte al finalizar cada
fase. Actualizá bitácora, testing y registro-pruebas-colegio.md con comandos,
resultados y evidencia real. Separá IMPLEMENTADO/COMPILADO/PROBADO/PENDIENTE DE
HARDWARE/BLOQUEADO. Meta:10sesiones físicas consecutivas sin fallos críticos;
si faltan LEDs, clasificá el ensayo como comunicaciones/pulsador sin estímulo visual.

Pedí aprobación antes de nuevos cambios importantes de arquitectura, cambios
estructurales/de seguridad Supabase fuera de lo ya autorizado, gastos, destrucción
o eliminación sin respaldo verificable. La autorización de push de ayer era para
la entrega de ayer: no publiques nuevos commits ni merges sin que lo autorice.
Continuá tareas independientes mientras falta un permiso. Al terminar, dejá resumen,
verificaciones, bloqueos concretos y próximos pasos. Fecha límite global:6/11/2026.
```
