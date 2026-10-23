# Estado de entrega REAKT — 22/10/2026

Objetivo: llevar al colegio el viernes23/10 una base reproducible y comprobar
primero radio/pulsador. Fecha límite global: 6/11/2026.

## Resultados verificados

| Componente | Estado y evidencia |
|---|---|
| Nodo y gateway WROOM-32 | COMPILADOS con Arduino-ESP32 2.0.17; no cargados físicamente desde aquí |
| ACK, CRC, duplicados, debounce y tiempo | PROBADOS en C++ con ASan/UBSan |
| Diez sesiones con pérdidas | PROBADAS en simulación de componentes, no en placas |
| APK Android debug | COMPILADO y firma verificada; uso físico pendiente |
| Flutter 3.29.3/Dart3.7.2 | INSTALADO; lock resuelto, analyze sin errores |
| Flutter contrato/SQLite/sync/conexión/UI | 17 tests APROBADOS; UI real contra servidor WebSocket de prueba y SQLite |
| Panel de diagnóstico navegador | PROBADO en Chromium: orden manual, métrica, historial tras reload y exportación JSON |
| SQL/RLS propuesto | 11 tests APROBADOS en PostgreSQL aislado; incluye inspección solo lectura |
| Supabase remoto | BLOQUEADO: conector sin herramientas y proxy rechaza CONNECT403 al proyecto indicado |
| Prueba física de Android/radio/pulsador | PENDIENTE DE HARDWARE |
| Estímulo visual WS2812B | BLOQUEADO: el usuario solo tiene placas y pulsador; faltan LEDs/circuito/alimentación |

## Archivos entregados

- `REAKT-MVP-2026-10-22.zip`: código actual y Markdown finales, incluidos cambios
  de la entrega y lock. No incluye SDKs, configuraciones locales ni claves. Instalar
  dependencias antes de trabajar sin Internet. Incluye manifest SHA256 por archivo.
- `REAKT-0.2.0-debug.apk`: **COMPILADO** con JDK17/NDK27.0.12077973; paquete
  `ar.edu.reakt`, versión0.2.0/código2, Android mínimo6.0/API23, target35.
  Universal: arm64-v8a, armeabi-v7a, x86 y x86_64. Aproximadamente199MiB.
- Archivos `.sha256` externos para comprobar ZIP/APK. En el cloud están en
  `/workspace/exports/`; copiar al colegio los archivos descargados, no esa ruta.

APK debug con firma v1/v2 verificada, **sin credenciales Supabase configuradas**:
funciona como cliente de entrenamiento/almacenamiento local; habilitar nube requiere
configuración pública y reconstruir. No hay validación en teléfono desde este entorno.
No es publicación Play Store ni APK release de producción. Recompilar en otra PC
puede cambiar firma debug: resguardar historial JSON y revisar antes de desinstalar.
La exportación no incluye un restaurador automático.

SHA256 APK: `a6323ae514e46d27e13106dffe703a009d2159fd30004020a200bd851bdb3201`.


## Proyecto Supabase y autorización

URL aportada por el usuario: `https://hvaoezcsgqepcttaznof.supabase.co`.
Se intentó Auth health y raíz REST; el proxy devuelve403 antes de obtener respuesta
del servicio. No se estableció una conexión SQL ni se inspeccionaron tablas remotas.

La migración `backend/migrations/20261022_001_reakt_mvp.sql` ya tiene aprobación
expresa **tras inspección, si no hay conflictos**. La aprobación no habilita saltar
esa inspección. No se aplicó ni se creó usuario remoto por falta de acceso.
`backend/inspect-readonly.sql` prepara la inspección metadata sin modificar datos.

Se guardaron en el draft el dominio exacto y SUPABASE_URL (no secreto), conservando
la autorización de storage.googleapis.com. Guardar draft no aplica ni publica:
revisar/guardar ajustes en configuración del entorno y publicar el entorno cuando
corresponda. Aún hace falta conectar herramientas Supabase para operar el proyecto.
No enviar contraseñas, service_role ni tokens administrativos por chat.

## Qué hacer mañana

Seguir **GUIA-COLEGIO-2026-10-23.md**, en este orden:

1. Descargar la entrega actual o actualizar main y verificar el commit
   “Cambios mayores, progreso considerable”. Preparar herramientas con Internet y conservar copia.
2. Identificar placas y station MAC, verificar GPIO y configurar roles locales.
3. Probar gateway/nodo/pulsador desde el panel del navegador, sin necesitar Android.
4. Instalar/probar la app Android y verificar historial antes de agregar nube.
5. Inspeccionar Supabase, aplicar solo si compatible y ensayar sincronización/RLS.
6. Segundo nodo y diez sesiones físicas cuando el primero sea estable. La reacción
   visual queda pendiente hasta conseguir/verificar LEDs y su alimentación.

Completar `registro-pruebas-colegio.md` con resultados reales y conservar JSON/logs.
Sin cables de datos, Wi-Fi o permisos de instalación, terminar primero esos
prerrequisitos; el simulador permite avanzar con software, sin afirmar prueba física.

## Documentación incluida

- GUIA-COLEGIO-2026-10-23.md: instrucciones Windows/colegio y alternativas.
- mvp-installation.md: Arduino, Flutter, pinout propuesto y configuración segura.
- packet-protocol.md: contrato compartido, ACK, límites y fallos.
- mvp-physical-tests.md y registro-pruebas-colegio.md: matriz y planilla vacía.
- mvp-school-report.md: informe técnico para la escuela.
- implementation-log.md y testing.md: historial de comandos, fallos y evidencia.
- ../backend/README.md: cambios SQL autorizados condicionalmente y riesgos.

## Límites de esta entrega

No se declararon pruebas físicas, fabricación, consumo, precisión temporal humana,
Supabase real. La publicación del código fue autorizada en la continuación;
ver RESUMEN-ENTREGA.md. No se inventaron MAC, GPIO validados ni claves.
Entrenamiento funciona por diseño sin Internet; validación física todavía necesaria.
El panel es herramienta de banco, no reemplaza la app ni sincroniza Supabase.
Los datos del simulador/test son sintéticos y no cuentan como diez sesiones físicas.
