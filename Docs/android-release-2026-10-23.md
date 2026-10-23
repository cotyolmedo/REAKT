# APK del demo REAKT — 23/10/2026

Se publica desde la rama `codex/android-demo-v0.3.0`, conservando main y los cambios locales ajenos a la app. Workflow `.github/workflows/android-apk.yml`: Flutter 3.47.4, JDK17, análisis, pruebas, compilación debug universal, verificación de firma y SHA256, publicación como prerelease con descarga directa.

Supabase usa variables GitHub Actions `SUPABASE_URL` y `SUPABASE_ANON_KEY`, verificadas como proyecto `hvaoezcsgqepcttaznof` y JWT de rol anon. Sin contraseñas ni claves privilegiadas en el APK. Inicio de sesión requerido en Perfil para sincronizar.

Comprobación remota: Auth settings HTTP200, las tres tablas reakt_* existen con RLS, nueve políticas limitadas a auth.uid() y permisos authenticated SELECT/INSERT/UPDATE. Anónimo rechazado HTTP401. Advisors conserva advertencias preexistentes de funciones SECURITY DEFINER y protección de contraseñas; no se modifican aquí.

Gateway `ws://192.168.4.1:81`, protocolo MVP v1. El usuario confirmó que las placas aún no están configuradas. La app queda preparada y probada con gateway simulado, sin atribuir conexión física. Arquitectura final de cinco nodos; MVP actual admite dos.

Pruebas y publicación concretas se registran al completar el workflow. El APK es de demostración debug: antes de cambiar de firma/instalación exportar historial JSON.
