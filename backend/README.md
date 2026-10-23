# Supabase REAKT — esquema remoto aplicado y RLS verificado

Estado actualizado23/10/2026: conector operativo, migración aplicada tras inspección,
cuenta de prueba confirmada y pruebas remotas RLS transaccionales aprobadas.
La sincronización desde Android físico y un segundo login real siguen pendientes.
Los apartados siguientes conservan el procedimiento y la evidencia histórica;
el cierre actual está en [CIERRE-SOFTWARE](../Docs/CIERRE-SOFTWARE-2026-10-23.md).

## Cambio autorizado condicionalmente

**Aprobación recibida el 2026-10-22:** aplicar `migrations/20261022_001_reakt_mvp.sql` solo después de revisar
las tablas, políticas y migraciones existentes del proyecto correcto.
**Justificación:** persistir sesiones, métricas y eventos autenticados e idempotentes.
**Recursos:** tres tablas nuevas `public.reakt_sessions`, `reakt_results`,
`reakt_events`; índices, claves foráneas y nueve políticas RLS. No altera tablas
existentes ni elimina datos. Si ya existen los nombres, la transacción falla.
**Riesgos:** conflicto con un esquema existente, datos declarados por el cliente
(no prueba antifraude), copias locales sensibles sin cifrado de base de datos,
upserts independientes pueden dejar una sesión parcialmente sincronizada hasta
el siguiente reintento. No cambia los ajustes globales de Auth.
**Alternativas:** adaptar al esquema existente tras inspección, o mantener SQLite
sin nube. **Sin acceso/inspección:** entrenamiento y guardado local siguen disponibles;
la sincronización remota no se considera habilitada.

## Operación tras aprobación

1. Conectar Supabase, identificar inequívocamente el proyecto reakt y leer esquema,
   RLS, migraciones y configuración Auth. No copiar claves administrativas al cliente.
2. Revisar esta migración contra el estado real; presentar cualquier ajuste antes
   de aplicar cambios de estructura o seguridad.
3. Aplicar la transacción aprobada por el canal autorizado. Verificar RLS con dos
   usuarios y rol anónimo. Nunca deshabilitar RLS para superar un error.
4. Crear/invitar un usuario de pruebas mediante el flujo seguro de Auth existente;
   no incrustar correo/contraseña ni compartirlas en chat. Verificar inicio de sesión.
5. Compilar la app con URL HTTPS del proyecto y clave pública anon/publishable
   mediante `--dart-define`. La contraseña se introduce solo en el teléfono.
6. Ejecutar una sesión offline, volver a una red con Internet, iniciar sesión y
   sincronizar. Repetir sincronización; debe conservar cantidades e identidades.
7. Verificar aislamiento de cuentas, revocación, token expirado y fallo parcial.

Las sesiones sin dueño se asignan a la primera cuenta que las sincroniza; después
no pueden reasignarse desde la UI. Dispositivo escolar dedicado recomendado.
SQLite conserva los datos ante fallos de nube; `synced=1` solo se escribe al
terminar todos los upserts. El payload exacto forma parte del ACK local para no
marcar sincronizada una versión que cambió durante una petición.

## Continuación: proyecto identificado por el usuario

URL pública: https://hvaoezcsgqepcttaznof.supabase.co. Auth health y REST
root devolvieron rechazo CONNECT403 del proxy, sin respuesta HTTP del servicio.
El dominio exacto y SUPABASE_URL quedaron guardados en el draft; falta aplicar
la configuración y conectar acceso autorizado. No se inspeccionó esquema remoto.
`inspect-readonly.sql` permite inspección metadata en SQL Editor sin escribir datos.
Once tests PostgreSQL locales aprobaron, incluido ese script. No sustituyen una
prueba Supabase real. La autorización condicional previa se mantiene vigente.

## Actualización 23/10/2026

El bloqueo anterior se resolvió: conector operativo y proyecto correcto inspeccionado.
Aplicada migración exacta autorizada sin conflictos (20261023120712, reakt_mvp).
RLS/grants verificados. Auth sin usuarios al inicio; falta registro/login real y
pruebas de escritura/aislamiento. Configuración pública local app/supabase-public.json
ignorada por Git. Formulario de banco: ejecutar `node tools/auth-local/server.mjs`
desde la raíz y abrir http://127.0.0.1:8766. Introducir contraseña solo localmente.
No se corrigieron advertencias de funciones preexistentes fuera del alcance autorizado.
Ver [registro](../Docs/CONTINUACION-COLEGIO-2026-10-23.md).
