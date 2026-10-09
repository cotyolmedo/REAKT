# ExecPlan - CAD modulo hexagonal V1

## 1. Objective

Crear una primera estructura CAD editable del modulo periferico REAKT: carcasa hexagonal, tapa movil, guias, topes, difusor LED, placa trasera y reservas de componentes.

## 2. Current state

La documentacion vigente describe un modulo hexagonal conceptual con ESP32, pulsador NA, WS2812B, TP4056 USB-C y bateria por definir. No hay medidas fisicas validadas de componentes reales.

Archivos relevantes:

- `Docs/README.md`
- `Docs1/diseno-mecanico.md`
- `Docs1/pcb/componentes-dimensiones.md`
- `Docs1/pcb/plan-codex.md`
- `Docs1/decisions.md`

## 3. Requirements

- Mantener geometria hexagonal de 150 mm entre vertices.
- Modelar base, tapa flotante, guias, resortes/topes y difusor perimetral.
- Separar carga mecanica de PCB, bateria y pulsador.
- Representar electronica como reservas de volumen, no como footprints finales.
- Mantener el resultado editable y claramente rotulado como preliminar.

## 4. Constraints

- No inventar cotas finales ni ensayos fisicos.
- No afirmar fabricabilidad o resistencia a golpes fuertes sin pruebas.
- No ubicar PCB/bateria en el camino de carga de impacto.
- No liberar STL/STEP final sin medir componentes reales.

## 5. Design

Modelo parametrico con:

- Base hexagonal estructural.
- Tapa flotante y almohadilla reemplazable.
- Cuatro guias con resortes/topes conceptuales.
- Canal/difusor perimetral para WS2812B.
- Placa trasera para adaptadores.
- Volumenes transparentes de PCB, ESP32, TP4056, bateria candidata y pulsador.

## 6. Implementation steps

- [x] Leer documentacion mecanica/PCB disponible.
- [x] Crear fuente OpenSCAD parametrica.
- [x] Crear script Python para Fusion 360.
- [x] Documentar uso y limitaciones.
- [!] Exportar STL/STEP: bloqueado porque `openscad`, FreeCAD y Blender no estan disponibles en PATH.
- [!] Validar interferencias con piezas reales: bloqueado hasta medir componentes.

## 7. Validation

Validacion realizada:

- Revision documental contra especificaciones preliminares.
- Inspeccion de existencia de herramientas CAD por consola.

Validacion pendiente:

- Ejecutar el script en Fusion 360 y revisar cuerpos.
- Exportar STL/STEP desde Fusion u OpenSCAD.
- Imprimir mecanismo sin bateria ni electronica.
- Ensayar carrera, retorno, golpe descentrado, retencion y acceso USB-C.

## 8. Documentation changes

Se agrego `hardware/cad/modulo-hexagonal/README.md` con uso, alcance y pendientes.

## 9. Risks and rollback

Riesgos:

- Las reservas de volumen pueden no coincidir con componentes comprados.
- La abertura USB-C y ubicacion de bateria pueden cambiar al medir piezas.
- Guias, topes y resortes requieren calculo/ensayo antes de golpes fuertes.

Rollback:

- Eliminar `hardware/cad/modulo-hexagonal/` y este ExecPlan si se decide rehacer el enfoque desde otro CAD.

## 10. Status

- [x] Modelo conceptual inicial creado.
- [!] Version final fabricable bloqueada por mediciones y ensayos reales.
