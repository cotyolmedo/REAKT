# Plan de saneamiento posterior a la auditoría

## 1. Objetivo

Dejar una única estructura canónica, coherente con la arquitectura vigente, sin
perder evidencia histórica ni presentar decisiones o pruebas pendientes como
resueltas.

## 2. Estado inicial

- `Docs1/` y `firmware1/` contenían una actualización paralela no integrada.
- `Docs/` y `firmware/` seguían describiendo parcialmente ESP32-C3/piezo.
- Había un lock de KiCad y bytecode Python rastreados.
- Faltaba `.gitignore` y un README principal.
- La actualización paralela incluía referencias a sus propias rutas, ADR
  duplicados y GPIO provisionales no respaldados por una placa confirmada.

## 3. Requisitos

- Conservar `Tests/` históricos.
- Integrar firmware no bloqueante de gateway y nodos.
- Mantener placa, GPIO, MAC, protocolo, alimentación e interfaz de app como
  `TBD` cuando corresponda.
- Mantener documentación escolar, app y backend ya existentes.

## 4. Restricciones

- No inventar validación física, ERC/DRC, métricas ni credenciales.
- No fabricar ni cerrar PCB/CAD sin piezas medidas.
- No hacer commit ni push automáticamente.

## 5. Diseño

`Docs/` y `firmware/` son las únicas rutas vigentes. `Tests/` conserva los
ensayos anteriores. Los artefactos de ingeniería preliminar viven bajo
`Docs/pcb/` y `hardware/`, claramente etiquetados como conceptuales.

## 6. Implementación

- [x] Integrar los documentos únicos de `Docs1/` en `Docs/`.
- [x] Reconciliar arquitectura, hardware, protocolo, roadmap y pruebas.
- [x] Integrar el firmware de nodo y mejorar la cola del gateway.
- [x] Corregir referencias `Docs1/`/`firmware1/` y numeración ADR.
- [x] Quitar GPIO no confirmados de la documentación vigente.
- [x] Eliminar carpetas paralelas y artefactos generados rastreados.
- [x] Añadir README principal y `.gitignore`.
- [x] Ejecutar verificaciones disponibles y registrar limitaciones.

## 7. Validación

- `git diff --check`.
- Búsqueda de referencias obsoletas, credenciales y `delay()` productivo.
- Revisión de enlaces locales Markdown.
- `flutter analyze` si la herramienta responde.
- Compilación Arduino y DRC solo si están disponibles las CLI y el destino real.

## 8. Documentación

Se actualizan `Docs/decisions.md`, `Docs/roadmap.md` y `Docs/testing.md` junto a
los archivos de arquitectura afectados.

## 9. Riesgos y reversión

El mayor riesgo es perder información útil al retirar las copias paralelas. Se
mitiga integrando primero archivos únicos y conservando requisitos, app/backend,
ensayos y artefactos de ingeniería. Antes de un commit, Git permite revisar o
restaurar cada cambio por archivo.

## 10. Estado

Implementación completada. `git diff --check`, referencias y enlaces locales se
verificaron el 2026-10-10. Flutter agotó el tiempo sin producir salida; Arduino
CLI y KiCad CLI no están instalados. Las validaciones dependientes de toolchains
o hardware quedan pendientes, no se declaran exitosas ni se interpretan como
fallas del diseño.
