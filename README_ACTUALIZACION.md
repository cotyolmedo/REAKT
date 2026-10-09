# Paquete de actualización local REAKT

Este ZIP es un **paquete de superposición**, no una copia completa del repositorio. Copiar su contenido en la raíz de `REAKT` conservando carpetas; no borrar archivos que no figuran aquí. Incluye la actualización documental anterior y documentación adicional de PCB/CAD.

## Comandos
```bash
git status
git diff --check
git diff --stat
git add AGENTS.md Docs/ firmware/gateway/README.md README_ACTUALIZACION.md
git commit -m "Cambios del proyecto actualizados"
git push origin main
```
Verificar diferencias y conflictos antes del commit. No hay esquemas KiCad ni firmware de nodos fabricados/compilados en este paquete. No sobrescribir cambios locales más recientes sin revisarlos.
