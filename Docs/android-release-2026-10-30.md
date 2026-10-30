# REAKT 0.3.1 — Actualización visual

El usuario solicitó compilar y crear una release, trabajando sobre `main`.
Fuente de la compilación: `36207cf3586c442b78b343986c62315fad475de9`.

## Cambios

- Logo y marca originales en cabecera e inicio de Flutter.
- Símbolo REAKT como icono Android.
- Versión `0.3.1+4`; conserva las funciones de entrenamiento y persistencia.

## Compilación

[GitHub Actions](https://github.com/cotyolmedo/REAKT/actions/runs/41065794583):
Flutter 3.47.4, JDK 17, análisis, tests, APK debug Android 7+ y verificación de firma.
Configuración Supabase mediante variables públicas del repositorio, sin credenciales
privilegiadas. No se instala automáticamente en ningún teléfono.

La firma debug puede diferir de la versión anterior. Exportar historial JSON antes
de reemplazar instalaciones; no desinstalar sin conservar los datos necesarios.

## Distribución

Release: `v0.3.1`. El archivo también se guarda en Downloads como
`REAKT-0.3.1-estetica-actualizada.apk`, con checksum SHA256 junto al APK.
La rama temporal de compilación fue eliminada tras integrar la fuente en `main`.

## Verificación ejecutada

Workflow `41065794583`: `completed/success`. Aprobados configuración pública,
análisis, tests Flutter, compilación Android, verificación de firma y subida de
artefacto. Se descarga y compara el SHA256 con el generado por CI; se comprueban
integridad ZIP del APK y coincidencia exacta de ambos assets de marca.
