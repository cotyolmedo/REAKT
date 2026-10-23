# Procedimiento de diseño PCB en KiCad

## Estructura del proyecto
```text
hardware/
  pcb/
    reakt-nodo/
      reakt-nodo.kicad_pro
      reakt-nodo.kicad_sch
      reakt-nodo.kicad_pcb
      reakt-nodo.kicad_dru          # solo si se usan reglas personalizadas
    reakt-gateway/
      reakt-gateway.kicad_pro
      reakt-gateway.kicad_sch
      reakt-gateway.kicad_pcb
  footprints/                       # bibliotecas personalizadas si son necesarias
  3d-models/                        # STEP propios, respetar licencias
  datasheets/
  bom/
```
**No crear archivos `.kicad_sch`/`.kicad_pcb` falsos**: Codex debe generarlos con sintaxis válida y verificarlos con KiCad CLI cuando esté disponible.

## Parámetros preliminares
- PCB portadora de nodo: hipótesis **65 × 75 mm**; no fijar antes de medir ESP32 y batería.
- Material: FR-4, **2 capas, 1,6 mm, 1 oz**, sujeto a fabricante y corrientes.
- Trazas de señales: proponer anchos según reglas del fabricante; no imponer un valor universal.
- Potencia LED: calcular sección/anchos según corriente, longitud, temperatura y cobre; usar planos/polígonos donde convenga.
- Cuatro agujeros de fijación en áreas libres, cotas y diámetro **TBD** según tornillos/insertos reales.
- Mantener antena ESP32 alejada de cobre, metal, batería, tornillos y carcasa que afecten RF; respetar **keepout del módulo real**.
- Conector USB-C del TP4056 alineado con la abertura lateral y accesible sin desmontaje.
- Separar electrónica del recorrido de tapa, resortes, tornillos y zonas de impacto.

## Orden de trabajo
1. Identificar piezas reales y construir símbolos/footprints correctos; enlazar fuentes.
2. Crear esquemático por bloques y anotar redes, corrientes y tensión nominal.
3. Ejecutar **ERC** y corregir errores, sin ocultar advertencias injustificadamente.
4. Definir `Edge.Cuts`, agujeros, keepouts de antena y zonas de exclusión mecánica.
5. Ubicar conectores, ESP32 y reguladores antes de rutear.
6. Añadir testpoints, serigrafía, referencia de revisión, polaridad y orientación.
7. Configurar reglas según capacidades del fabricante; ejecutar **DRC**.
8. Visualizar 3D; exportar STEP y verificar interferencias con CAD de carcasa.
9. Generar Gerber/Excellon y revisarlos en visor independiente.
10. Fabricar 1 prototipo y medir antes de solicitar cinco unidades.

## Archivos entregables
- Esquemático, PCB, proyecto KiCad y bibliotecas necesarias.
- BOM con fabricante/MPN y referencias, sin sustituciones tácitas.
- Diagramas de bloques, pinout, PDF de esquemático, Gerbers, archivos de perforación, STEP.
- Capturas/registro ERC-DRC y evidencia de prototipo real.

## Referencias
- https://www.kicad.org/discover/pcb-design/
- https://docs.kicad.org/master/en/pcbnew/pcbnew.pdf
