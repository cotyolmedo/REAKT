# Sitio público REAKT

La web se publica mediante GitHub Pages desde `main`:

https://cotyolmedo.github.io/REAKT/

La fuente de la página es `REAKT_webv2.html`. El workflow
`.github/workflows/pages.yml` la publica como `index.html`, junto con `assets/`
y el manifest. No publica la app, configuraciones locales ni el resto del repo
como archivos del sitio.

## Actualizar la web

1. Editar `REAKT_webv2.html` y/o sus imágenes en `assets/`.
2. Revisar la vista local.
3. Con autorización del usuario, hacer commit y push a `main`.
4. GitHub Actions vuelve a publicar automáticamente. La URL se mantiene.

GitHub Pages hospeda la web estática; Flutter Android y su APK se compilan y
distribuyen por separado. La publicación no impide seguir editando el diseño,
el texto o las imágenes.
