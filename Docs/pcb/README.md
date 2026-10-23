# REAKT — Ingeniería de PCB (índice maestro)

**Estado:** especificación de ingeniería V1; no es un circuito validado ni un PCB listo para fabricar. **Fecha:** 2026-10-08.

## Decisiones confirmadas
- Seis ESP32 en total: un gateway y cinco nodos de entrenamiento, sin ESP32-C3 en el diseño vigente.
- Nodos con pulsador mecánico normalmente abierto y LED direccionable WS2812B.
- ESP-NOW entre nodos y gateway; Flutter y Supabase/PostgreSQL según la arquitectura documentada.
- Placa de desarrollo indicada por el equipo como «ESP32 32-s kit»; identificación y dimensiones **pendientes**.
- Módulo de carga TP4056 USB-C previsto; batería, protección, power-path y reguladores **pendientes**.
- Carcasa hexagonal deportiva; la electrónica no debe recibir la carga mecánica del golpe.

## Estrategia de PCB
1. **V1:** carrier PCB de nodo para placa ESP32 enchufable, conectores y circuitos auxiliares; componentes mecánicos montados en carcasa. No soldar la placa de desarrollo directamente a una PCB definitiva sin identificar su variante.
2. **Gateway:** PCB distinta, solo después de cerrar la interfaz con Flutter; evitar copiar el cargador y pulsador si no los necesita.
3. **V2 opcional:** migración a módulo ESP32-WROOM soldado directamente, con fuente 3V3, programación y diseño RF propios, únicamente después de validar V1.

## Documentos
| Documento | Contenido |
|---|---|
| `componentes-dimensiones.md` | Medidas aproximadas, fuentes y confianza |
| `arquitectura-electrica.md` | Bloques, conexiones, dominios eléctricos |
| `alimentacion-y-autonomia.md` | Batería, TP4056, power-path, LED y cálculos |
| `pinout-y-conectores.md` | Señales requeridas y proceso para definir GPIO/conectores |
| `layout-kicad.md` | Geometría, stack-up, trazado, RF, DRC y fabricación |
| `gateway-pcb.md` | Diferencias y diseño de placa central |
| `bom-preliminar.md` | Lista de materiales y alternativas |
| `verificacion-pcb.md` | Ensayos y criterios de aceptación |
| `plan-codex.md` | Instrucciones ejecutables para Codex, límites y entregables |
| `../diseno-mecanico.md` | Mecánica y coordinación CAD ↔ PCB |

## Puertas de decisión antes de fabricar
- **G1:** fotos, calibre y pinout de placa ESP32, TP4056, portabatería, LED y pulsador reales.
- **G2:** celda 1S y esquema de protección/carga/uso simultáneo aprobados.
- **G3:** cantidad de LEDs y límite de brillo; corriente pico calculada y comprobada.
- **G4:** esquemático revisado; ERC sin errores no justificados.
- **G5:** montaje mecánico, zonas de exclusión RF, conectores y accesos verificados en CAD.
- **G6:** DRC limpio, revisión de Gerbers, pruebas de banco y seguridad antes de instalar batería.

No confundir *dimensiones de referencia* con cotas finales de footprints. No declarar DONE sin evidencia.
