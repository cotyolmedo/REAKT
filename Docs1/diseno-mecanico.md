# REAKT — Diseño mecánico de módulo hexagonal V1

**Estado:** especificación preliminar para prototipo CAD/FDM. **Fecha:** 2026-10-08. **No validado físicamente.**

## 1. Objetivo y alcance
Diseñar cinco módulos periféricos hexagonales de entrenamiento de reflejos para golpes fuertes con la palma. Cada módulo incorpora un ESP32 (placa declarada «ESP32 32-s kit», variante por confirmar), pulsador mecánico normalmente abierto, iluminación WS2812B, batería recargable por definir y cargador TP4056 con conector USB-C. La carcasa negra debe poder utilizarse horizontalmente y fijarse a una pared mediante adaptadores intercambiables. La tapa incorpora una superficie de contacto de TPU o goma.

**Decisiones confirmadas:** geometría hexagonal; negro deportivo; tapa móvil; detección por pulsador mecánico; ESP32 en lugar de ESP32-C3; impresión FDM; USB-C TP4056; uso horizontal y vertical; golpes fuertes. **Pendientes:** dimensiones reales de PCB, batería, corriente de LEDs, interruptor, peso, fuerza/energía de impacto, tecnología de montaje final.

## 2. Envolvente preliminar
Hexágono regular: 150 mm entre vértices opuestos; aproximadamente 129,9 mm entre caras opuestas; lado de 75 mm. Altura inicial objetivo: 45–55 mm, a verificar con apilamiento de piezas. Espesor nominal de paredes: 3–4 mm, con nervaduras en puntos de carga. Tapa rígida de 4–6 mm más almohadilla TPU reemplazable de 2–4 mm. Carrera de tapa: objetivo inicial 4 mm (intervalo exploratorio 3–5 mm). Separación mínima de seguridad y tolerancias según impresora/material reales; no son cotas liberadas para fabricación.

Para imprimir con una máquina de volumen útil inferior a 150 mm en XY, dividir piezas con uniones atornilladas; no comprometer las columnas de carga con uniones adhesivas.

## 3. Arquitectura de piezas
- **A. Base estructural:** hexágono inferior con seis paredes, nervaduras, apoyos y alojamiento de insertos metálicos roscados.
- **B. Bastidor de impacto:** puente interno rígido unido a base; recibe topes y guías; desacoplado de electrónica.
- **C. Tapa flotante:** placa hexagonal rígida, cantos redondeados y almohadilla antideslizante de TPU/goma reemplazable.
- **D. Cuatro guías:** ejes o columnas simétricos, con casquillos y tolerancias para evitar atascos por inclinación; retenedores para que la tapa no se desprenda.
- **E. Cuatro resortes de compresión:** retorno elástico con precarga ligera; selección por ensayo de fuerza/carrera y riesgo de pandeo.
- **F. Actuador central:** saliente o empujador ajustable que transmite desplazamiento al pulsador, no la energía principal del impacto.
- **G. Topes elastoméricos:** cuatro o más apoyos que limitan la carrera antes de exceder el recorrido admisible del pulsador.
- **H. Difusor luminoso perimetral:** fijo en base; LED WS2812B fijado sin flexión repetida del cableado.
- **I. Placa trasera de montaje:** interfaz común con accesorios para pared y superficies horizontales.

**Regla de carga:** tapa → topes/guías/bastidor → base → soporte. Nunca tapa → pulsador → PCB/batería.

## 4. Mecanismos comparados
| Opción | Beneficio | Riesgo | Resolución |
|---|---|---|---|
| Cuatro resortes y cuatro guías | Estabilidad, piezas reemplazables, ajuste | Alineación y fricción | **Elegida para V1** |
| Resorte central y guías periféricas | Menos resortes | Mayor cabeceo en impactos excéntricos | Reserva |
| Flexuras impresas en TPU | Menos componentes y ruido | Fatiga, fluencia, variabilidad térmica | Investigación posterior |

El accionamiento debe producirse durante la carrera, con margen de sobrecarrera mecánica controlado por topes independientes. Para el prototipo se propone activar cerca de 2 mm de descenso con carrera nominal 4 mm, **sujeto al datasheet del pulsador seleccionado**. El firmware debe registrar el flanco y aplicar antirrebote sin `delay()`; distinguir tiempo de reacción de duración de presión.

### Resortes e impacto
Modelo cuasiestático exploratorio: F_retorno(x) = 4(F_precarga + k·x), para cuatro resortes iguales. No usar este modelo para dimensionar directamente impactos deportivos: calcular y ensayar energía de impacto, masa móvil, velocidad y disipación en topes. Evaluar atrapamiento de dedos en la junta móvil y cubrir holguras peligrosas. Establecer protocolo de ensayos de menor a mayor intensidad.

## 5. Distribución interna y fijaciones
- ESP32 sobre separadores atornillados (patrón de agujeros medido en placa real; no perforar ni apoyar sobre antena).
- Batería en alojamiento lateral independiente, con sujeción positiva, protección contra vibración y separación de zona de impacto. Evitar celdas deformadas o baterías sin protección adecuada.
- TP4056 sobre soporte propio, con USB-C alineado a abertura lateral y refuerzo contra esfuerzos de inserción. Acceso al puerto sin abrir carcasa.
- Cableado sujeto por grapas y alivio de tensión; espacio para mantenimiento, desconexión y acceso a tornillos.
- WS2812B en perímetro fijo con difusor opal; reservar espacio de cableado y disipación. Calcular corriente máxima a partir del número de LEDs y patrón de brillo permitido.
- Rendijas laterales con nervaduras; ubicar lejos de salpicaduras y electrónica sensible. Ventilación no implica impermeabilidad. Evaluar si son necesarias mediante medición térmica.
- Aberturas adicionales para interruptor general, indicador de carga y acceso de servicio si se incorporan.

### Seguridad eléctrica
TP4056 es un cargador de **una sola celda Li-ion/LiPo**; no equivale a regulador de alimentación ni a sistema power-path. Verificar que la versión adquirida tenga protección de celda adecuada o agregarla; usar regulador compatible con tensión de batería y picos de corriente del ESP32 y LEDs. Si el módulo debe operar durante la carga, incorporar gestión de carga y reparto de energía diseñada para ello. No conectar directamente la batería al pin 3V3. No cerrar carcasa hasta validar corriente, temperatura y cableado. Revisar condiciones de transporte/almacenamiento de baterías de litio.

## 6. Montaje a superficies
**Interfaz posterior modular** con tornillos y patrón común, no una única fijación permanente.
1. **Pared:** placa de pared atornillada, encastre guiado y cierre positivo; incluir retención secundaria/correa de seguridad. Validar sustrato, tacos, tornillos y esfuerzos dinámicos.
2. **Vidrio/azulejo:** ventosas de calidad como accesorio para pruebas de baja energía y con retención secundaria. **No aprobadas como única sujeción para golpes fuertes.**
3. **Mesa/piso:** pies antideslizantes más sujeción mecánica o plataforma lastrada/anclada para entrenamiento intenso.
4. **Superficies metálicas:** eventual adaptador magnético con enclavamiento mecánico, sujeto a evaluación de seguridad.

La tapa debe moverse perpendicular a su plano tanto en horizontal como en vertical. Comprobar que gravedad y precarga no causen activaciones espontáneas.

## 7. Materiales y fabricación
- Base y bastidor: PETG o ASA impresos en FDM como candidatos; definir por ensayos de impacto, temperatura y comportamiento a fatiga. PLA solo para maquetas dimensionales iniciales.
- Tapa: PETG/ASA con nervaduras y almohadilla de TPU 95A o goma equivalente, reemplazable.
- Guías: preferir ejes metálicos y casquillos comerciales para repetibilidad; guías impresas como alternativa experimental.
- Uniones: tornillos y, donde convenga, insertos térmicos roscados; evitar roscas impresas en piezas sometidas a desmontaje frecuente.
- Acabado: negro mate, cantos redondeados, tornillería oculta, difusor translúcido.
- Parámetros de impresión (orientación, número de paredes, relleno y temperaturas): definir tras ensayos, no asumir resistencia por porcentaje de relleno.

## 8. Secuencia CAD
1. Medir con calibre placa ESP32, cargador TP4056, portabatería y pulsador reales; fotografiar con escala.
2. Dibujar envolvente 150 mm, altura objetivo 45–55 mm y volúmenes de exclusión.
3. Modelar base, nervaduras y bastidor de carga; después guías, tapa y topes.
4. Reservar anillo LED, cableado, puerto USB-C y ranuras laterales.
5. Diseñar interfaz posterior con adaptadores independientes.
6. Crear plano de conjunto, vistas explotadas, sección central, lista de materiales y archivos STEP/STL/3MF.
7. Imprimir primero mecanismo sin batería ni electrónica.

## 9. Verificación y criterios de aceptación propuestos
| Ensayo | Método | Criterio inicial |
|---|---|---|
| Carrera y retorno | Medir desplazamiento, 100 accionamientos manuales iniciales | Sin atasco ni activación permanente |
| Golpe descentrado | Accionar en seis zonas de la tapa | Detecta de forma consistente sin trabarse |
| Antirrebote | Registrar señales crudas y filtradas | Un evento por accionamiento válido |
| Retención de tapa | Tirar y mover con carga moderada definida en protocolo | No se desprende |
| Montaje vertical | Ensayar con sujeción secundaria | No cae, no gira, no se dispara solo |
| Impacto progresivo | Instrumentar fuerza/energía y aumentar escalonadamente | Sin fracturas, aflojamiento ni daño interno |
| Seguridad eléctrica | Medir tensión, corriente y temperatura | Dentro de especificaciones de componentes |
| Puerto USB-C | Repetir inserción con cargador sujeto | Sin movimiento de PCB ni daño |

No declarar el módulo apto para golpes fuertes hasta completar ensayos instrumentados de resistencia, fijación y retención. Registrar fecha, configuración, mediciones, fallos y fotografías en `Tests/`.

## 10. Integración con firmware y aplicación
Entrada digital normalmente abierta, preferentemente conectada a GND con `INPUT_PULLUP` cuando el GPIO elegido lo permita. El evento debe incluir ID de nodo, secuencia y marca temporal local; contemplar sincronización/compensación para métricas entre nodos. ESP-NOW permanece como enlace inalámbrico. No confundir intensidad del golpe con tiempo de pulsación: **el sistema no mide fuerza**. Documentar en interfaz y backend la naturaleza binaria de cada impacto.

## 11. Requisitos escolares y trazabilidad
El repositorio `Docs/requirements.md` requiere carcasa terminada, prototipo funcional, evidencia de ensayos y documentación del circuito. Este diseño contribuye a dichos entregables, pero no sustituye pruebas físicas ni la verificación de requisitos de sensores. Mantener documentación de campo y fotografías reales.

## 12. Pendientes para liberar versión V1
- Confirmar modelo exacto y dimensiones de «ESP32 32-s kit».
- Seleccionar batería y calcular autonomía y picos de corriente.
- Identificar variante exacta del TP4056, protección y solución power-path/regulación.
- Elegir pulsador con hoja de datos, fuerza de actuación, sobrecarrera y vida útil.
- Medir masa de tapa y definir objetivo de fuerza/energía de impacto.
- Elegir resortes, ejes, casquillos, topes y tornillos por cálculo/ensayo.
- Definir cantidad, densidad y tensión de WS2812B y brillo máximo.
- Diseñar soportes traseros específicos según superficies reales.
- Revisar riesgo de pellizco, desprendimiento y exposición de batería.
- Validar con prototipo físico y actualizar planos finales.

## 13. Estructura recomendada del repositorio
- `Docs/diseno-mecanico.md` (este documento).
- `hardware/mechanical/CAD/` (fuentes CAD editables y STEP).
- `hardware/mechanical/STL/` (piezas exportadas con revisión).
- `hardware/mechanical/BOM.md` (lista de materiales, proveedores y costos).
- `Tests/mecanica/` (protocolos, resultados y fotos de ensayos).
- Actualizar `Docs/hardware.md`, `Docs/architecture.md`, `Docs/decisions.md`, `Docs/testing.md` y `Docs/roadmap.md` con referencias a esta especificación.
