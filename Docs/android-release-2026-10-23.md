# APK del demo REAKT — 23/10/2026

Se publica desde la rama `codex/android-demo-v0.3.0`, conservando main y los cambios locales ajenos a la app. Workflow `.github/workflows/android-apk.yml`: Flutter 3.47.4, JDK17, análisis, pruebas, compilación debug universal, verificación de firma y SHA256, publicación como prerelease con descarga directa.

Supabase usa variables GitHub Actions `SUPABASE_URL` y `SUPABASE_ANON_KEY`, verificadas como proyecto `hvaoezcsgqepcttaznof` y JWT de rol anon. Sin contraseñas ni claves privilegiadas en el APK. Inicio de sesión requerido en Perfil para sincronizar.

Comprobación remota: Auth settings HTTP200, las tres tablas reakt_* existen con RLS, nueve políticas limitadas a auth.uid() y permisos authenticated SELECT/INSERT/UPDATE. Anónimo rechazado HTTP401. Advisors conserva advertencias preexistentes de funciones SECURITY DEFINER y protección de contraseñas; no se modifican aquí.

Gateway `ws://192.168.4.1:81`, protocolo MVP v1. El usuario confirmó que las placas aún no están configuradas. La app queda preparada y probada con gateway simulado, sin atribuir conexión física. Arquitectura final de cinco nodos; MVP actual admite dos.

Pruebas y publicación concretas se registran al completar el workflow. El APK es de demostración debug: antes de cambiar de firma/instalación exportar historial JSON.

## Publicación verificada

Workflow https://github.com/cotyolmedo/REAKT/actions/runs/39965490097: success; análisis, 21 pruebas Flutter, ensamblado, firma y publicación aprobados. Fuente compilada `a6985d2f1846259dbcdbdc0f9df46262784c4a8f`.

[Descarga directa del APK](https://github.com/cotyolmedo/REAKT/releases/download/v0.3.0-demo.4.1/REAKT-0.3.0-android.apk), [release con checksum y firma](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.0-demo.4.1). Tamaño 154267345 bytes. SHA256: `ab2f646c77047784e8a22944a3edfe1f0467f3346a7ebb7408782c33f920c072`.

La prueba SQL transaccional remota de RLS fue aprobada y revertida; no quedaron sesiones/eventos sintéticos. Falta iniciar sesión en el teléfono y probar sincronización desde la app. Placas todavía sin configurar: no se declara conexión física.

La compilación con Flutter 3.47.4 requiere actualizar el proyecto anterior: Gradle 8.14.3 (checksum oficial), AGP 8.11.1, Kotlin 2.2.20 y Android mínimo 7.0/API24. No se usa `--android-skip-build-dependency-validation`.
