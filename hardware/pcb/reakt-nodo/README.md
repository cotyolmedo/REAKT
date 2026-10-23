# REAKT nodo — carrier preliminar V0.1

Estado: `IN PROGRESS`, layout de reserva no fabricable.

Esta placa solo reserva una envolvente hipotética de 65 x 75 mm, dos hileras de 15 pines para una placa ESP32 aún no identificada, conectores conceptuales para impacto/RGB/batería y puntos de prueba. No contiene esquemático, netclass, redes, ruteo, alimentación, agujeros mecánicos ni keepout RF definitivo.

Motivo: la documentación V1 exige medir la placa ESP32, TP4056, batería, conectores, pulsador y LED reales antes de fijar footprints. El diseño no debe interpretarse como listo para fabricar ni como validación ERC/DRC.

Abrir `reakt-nodo.kicad_pcb` con KiCad 9.0. Próximo paso bloqueante: completar G1–G3 de `Docs/pcb/README.md` y generar el esquemático a partir de esas medidas.
