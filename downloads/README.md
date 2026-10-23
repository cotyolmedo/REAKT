# Descargar REAKT Android 0.2.0

Si los enlaces del chat abren el visor y muestran “Could not download artifact”,
usá los archivos publicados en GitHub:

- [ZIP pequeño ARM64 — unos8MB](https://github.com/cotyolmedo/REAKT/raw/refs/heads/main/downloads/REAKT-0.2.0-android-arm64.zip).
- [ZIP original universal — unos84MB](https://github.com/cotyolmedo/REAKT/raw/refs/heads/main/downloads/REAKT-0.2.0-universal-original.zip).

Descomprimir el ZIP e instalar el archivo `.apk`. Android mínimo6.0/API23.
Si GitHub muestra una página del archivo, pulsar **Download raw file**.
Si requiere iniciar sesión, usar una cuenta con acceso al repositorio.

## Por qué tienen distinto tamaño

| Versión | APK aproximado | Contenido y uso |
|---|---:|---|
| ARM64 optimizada |17MB|Compilación release, solo arm64-v8a; teléfonos ARM64 compatibles|
| Universal original |208MB|Compilación debug original; arm64-v8a, armeabi-v7a, x86 y x86_64|

La versión pequeña compila el código para ejecución optimizada, excluye herramientas
de depuración y elimina recursos no usados. Incluye una sola arquitectura. No se
recortaron las funciones de entrenamiento, WebSocket, SQLite, exportación o nube.
Ambas proceden del mismo código6e4eec6, sin credenciales Supabase configuradas.
La versión optimizada está firmada con la misma clave de pruebas del debug original;
no es un release de producción ni publicación Play Store. La instalación física
sigue pendiente. En un teléfono antiguo de32bits usar el universal.

Comprimir es otro paso distinto: el ZIP pequeño pesa8MB y al extraerlo produce
el APK de17MB; el ZIP universal pesa84MB y produce **el APK original exacto** de
208433007bytes. No se dividió ni modificó ese APK universal para subirlo: cada ZIP
queda por debajo del límite GitHub de100MiB por archivo.

`SHA256SUMS.txt` permite comprobar las descargas; `manifest.json` registra también
los tamaños y hashes de cada APK interno. No desinstalar una app con sesiones
pendientes para solucionar un problema de actualización: primero exportar historial.

Estos archivos binarios se incluyen por autorización explícita del usuario; no se
incluyen SDKs, claves de firma ni configuración local en el repositorio.
