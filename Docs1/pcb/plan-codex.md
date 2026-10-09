# Plan de ejecución para Codex local — REAKT KiCad + CAD + firmware

## Objetivo
Generar artefactos **reales, editables y verificables**, no capturas ni descripciones simuladas: KiCad para nodo/gateway, CAD paramétrico para carcasa y firmware para ESP32. Trabajar incrementalmente.

## Instrucciones obligatorias
1. Leer `AGENTS.md`, `Docs/README.md`, `Docs/pcb/README.md`, `Docs/pcb/*`, `Docs/diseno-mecanico.md`, `Docs/decisions.md` y `.agent/PLANS.md`.
2. Auditar archivos existentes, rama Git y decisiones. No sobrescribir pruebas históricas.
3. Crear ExecPlan para cada subsistema y no marcar como implementado lo que solo está especificado.
4. Si faltan dimensiones físicas, tipo de batería, conector, corriente LED o alimentación, **detener diseño final** y pedir datos. Se permiten esquemas preliminares claramente rotulados.
5. Empezar por un nodo con alimentación de laboratorio y pulsador/LED, sin batería.
6. Producir esquemático KiCad con símbolos, netlabels y footprints medidos; pasar ERC.
7. Producir PCB solo tras cerrar alimentación y geometría; pasar DRC y revisión 3D.
8. Diseñar carcasa CAD paramétrica con piezas separadas, topes y guías, exportar STEP/STL, verificar interferencias.
9. Implementar firmware nodo sin `delay()`; antirrebote, máquina de estados, ESP-NOW y WS2812B; evitar asumir protocolo v1 final.
10. Integrar cinco nodos y gateway con pruebas reproducibles.
11. Documentar BOM, presupuesto energético, pruebas y evidencias reales.
12. No publicar secretos, no afirmar pruebas físicas inexistentes, no forzar `git push`.

## Estructura de salida
```text
hardware/pcb/reakt-nodo/
hardware/pcb/reakt-gateway/
hardware/footprints/
hardware/3d-models/
hardware/datasheets/
hardware/bom/
hardware/cad/modulo-hexagonal/
firmware/nodes/
Tests/pcb/
Docs/pcb/
```

## Definición de terminado
- Archivos abren sin errores en las versiones instaladas de KiCad/CAD.
- ERC/DRC y análisis de compilación documentados; hardware validado solo con ensayos reales.
- Esquemas y layout coinciden con la BOM, las conexiones físicas y las decisiones registradas.
- PCB y carcasa encastran en CAD, con acceso USB-C y sin impacto sobre la batería.
- Commits acotados y trazables.

## Primer trabajo concreto
Solicitar fotos con regla de ESP32 «32-s kit», TP4056, portacelda, pulsador y tira WS2812B; proponer dos esquemas de alimentación (sin uso durante carga / con power-path), estimar consumo con 18/24/27 LEDs y presentar revisión antes de fabricar.
