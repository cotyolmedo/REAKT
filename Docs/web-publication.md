# Sitio público REAKT

La web estática se publica con GitHub Pages desde `main`: https://cotyolmedo.github.io/REAKT/.

**Fuente vigente única:** `REAKT_webv2.html`. El workflow `.github/workflows/pages.yml` lo publica como `index.html`, junto con `assets/` y el manifest. La antigua `REAKT_web.html` se retiró del árbol de trabajo porque era una versión anterior; se conserva en el historial Git.

Para actualizar el sitio, editar `REAKT_webv2.html` y/o los recursos de `assets/`, comprobar la vista local y publicar los cambios autorizados en `main`. GitHub Actions despliega el sitio. El APK Android se distribuye desde [Releases v0.3.1](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1), no desde Pages.
