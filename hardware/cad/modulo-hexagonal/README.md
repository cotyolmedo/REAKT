# REAKT - CAD modulo hexagonal estilo referencia

Estado: modelo conceptual editable, no validado fisicamente.

Este directorio contiene la version inspirada en la referencia enviada: una bandeja hexagonal azul con pared exterior ranurada y aro interior rojo.

## Archivos

- `fusion360_import_modulo_hexagonal_v1.py`: script para crear el modelo editable directamente en Autodesk Fusion 360.
- `reakt_modulo_hexagonal_v1.scad`: fuente parametrica OpenSCAD.
- `reakt_modulo_hexagonal_v1.obj` / `.mtl`: malla importable con materiales simples.
- `generate_rekt_obj.js`: regenerador local de la malla OBJ.

## Que incluye

- Piso central hexagonal azul.
- Pared exterior hexagonal azul.
- Borde superior azul.
- Marcadores claros repetidos que representan ranuras laterales.
- Aro interior rojo elevado, como en la referencia.

## Que NO esta cerrado

- Las ranuras son una representacion visual; antes de fabricar conviene convertirlas en cortes reales con dimensiones de impresion.
- Mecanismo real del pulsador/tapa.
- Ubicacion final de ESP32, TP4056, bateria, LED y cableado.
- Material definitivo, parametros de impresion y resistencia a golpes fuertes.

## Uso con Fusion 360

Ejecutar `fusion360_import_modulo_hexagonal_v1.py`. El script crea un documento nuevo con cuerpos separados y nombrados.

## Validacion pendiente

Antes de fabricar, medir componentes reales, definir espesores imprimibles y documentar ensayos fisicos. No declarar apto para golpes fuertes sin pruebas.
