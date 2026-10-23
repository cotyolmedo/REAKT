# Plan de verificación de PCB y ensamblaje

## V0 — revisión documental
- [ ] Identidad y medidas de ESP32, TP4056, pulsador, LED y batería confirmadas.
- [ ] Esquemático de power-path/operación durante carga definido y revisado.
- [ ] Picos ESP32 y LED incluidos en presupuesto de corriente.
- [ ] BOM con MPN/footprints verificables y fuentes.
- [ ] ERC sin errores no justificados; revisiones registradas.
- [ ] DRC sin errores no justificados; Gerbers inspeccionados.

## V1 — pruebas sin batería de litio instalada
- [ ] Inspección visual, continuidad, cortos y polaridad.
- [ ] Alimentación de laboratorio con límite de corriente; verificar 3V3 y 5V.
- [ ] Pulsador: flanco, liberación, rebote y eventos duplicados.
- [ ] LED: secuencias y transitorios sin reset/brownout.
- [ ] Radio: recepción/envío, cinco nodos, interferencias y orientación.
- [ ] Medición de temperatura de reguladores.
- [ ] Ensayos de caída de tensión en cables y conectores.

## V2 — batería y carga
- [ ] Celda/protección/cargador identificados, inspeccionados y aprobados.
- [ ] Corriente de carga compatible con la celda y temperatura de carcasa.
- [ ] Corte de carga y estado de carga comprobados.
- [ ] Protección de sobrecorriente/cortocircuito y descarga baja verificada de forma segura.
- [ ] Operación durante carga ensayada **solo** si existe power-path validado.
- [ ] Sin retorno de corriente por USB de programación.
- [ ] Autonomía medida en tres perfiles: reposo, uso típico y brillo máximo permitido.

## V3 — impacto y montaje
- [ ] Pulsador separado de carga mecánica principal.
- [ ] Sin interferencias tapa/PCB/celda/antena.
- [ ] Cables con alivio de tensión, USB-C accesible.
- [ ] Repetición de impactos escalonados y verificación eléctrica posterior.
- [ ] Fijación mural con anclaje positivo y retención secundaria.

## Evidencia por ensayo
Fecha, autor, revisión de PCB, versión firmware, instrumento, configuración, resultado esperado, resultado medido, criterio de aprobación, fotos y fallas. **Ninguna prueba de esta lista está declarada aprobada.**
