# Backend Supabase REAKT

La app conserva las sesiones en SQLite y sincroniza mediante Auth y RLS.
No volver a ejecutar la migración si el esquema ya está aplicado.

## Esquema

`migrations/20261022_001_reakt_mvp.sql` define las tablas `reakt_sessions`,
`reakt_results` y `reakt_events`, sus índices, claves foráneas y políticas RLS.
`inspect-readonly.sql` inspecciona el esquema sin modificar datos.
`remote-rls-smoke.sql` comprueba las políticas; revisar su contenido y ejecutarlo
solo en el proyecto correcto y con autorización para pruebas de base de datos.

## Configuración y operación

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


Para el formulario local de autenticación, ejecutar desde la raíz
`node tools/auth-local/server.mjs` y abrir http://127.0.0.1:8766.
La contraseña se introduce únicamente en el formulario local.
