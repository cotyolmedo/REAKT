# Instalación

Copiar estos elementos a la raíz del repositorio REAKT existente:

- `AGENTS.md`
- `.agent/PLANS.md`
- `docs/`
- `.codex/config.toml`

No reemplazar automáticamente el `.gitignore` existente.

Después de copiar:

1. revisar `docs/requirements.md`
2. revisar `docs/hardware.md` y corregir pines/partes que no sean definitivos
3. completar los `TBD`
4. iniciar Codex desde la raíz del repo
5. pedir primero un análisis del repositorio sin modificar código

Primer prompt recomendado:

"Leé AGENTS.md y docs/README.md. Inspeccioná el repositorio actual de REAKT sin modificar archivos. Compará el estado real con docs/architecture.md, docs/roadmap.md y docs/requirements.md. Informá inconsistencias, archivos relevantes, riesgos y próximos pasos. No implementes nada todavía."
