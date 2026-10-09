# Medidas aproximadas y fuentes para la integración CAD/PCB

**Regla:** los valores de esta tabla sirven para **reservar espacio**. No determinan footprints ni agujeros hasta medir el componente comprado o verificar su dibujo técnico exacto. Las variantes de tiendas pueden cambiar de tamaño y pinout.

| Elemento | Referencia aproximada | Origen / fiabilidad | Acción previa al diseño |
|---|---|---|---|
| ESP32 DOIT DevKit V1, 30 pines | **51,45 × 28,33 mm** | Referencia de variante DOIT, **no** confirmación de «ESP32 32-s kit» | Fotografiar frente/reverso, contar pines, medir longitud, ancho, paso y separación de hileras |
| ESP32-DevKitC V4 | **Consultar DXF/PDF oficial**; no sustituir por dimensiones de DOIT | Espressif | Usar exclusivamente si coincide con la placa física |
| TP4056 USB-C en módulo | Habitualmente **26 × 17 mm**, pero existen variantes ~17 × 17 mm | Referencia de mercado, **baja confianza** | Medir PCB, agujeros, posición y altura del conector; confirmar terminales B+/B− y OUT+/OUT− |
| Celda 18650 (solo candidata) | Designación nominal **Ø18 × 65 mm**; celdas protegidas pueden ser mayores | Tamaño de familia, **no** celda seleccionada | Elegir fabricante, protección, ficha técnica y longitud real |
| Portacelda 18650 individual | Ejemplo Keystone 1042/1043: longitud global aprox. **77,1 mm**, ancho **20,7 mm**, con variantes y cotas adicionales | Plano técnico de fabricante | Seleccionar código exacto; no copiar agujeros de otro modelo |
| WS2812B encapsulado | Familia **5050 ≈ 5 × 5 mm** | Denominación de encapsulado | Revisar hoja técnica del LED exacto |
| Tira WS2812B | Frecuentes 30/60 LED/m; ancho típico **8–12 mm** según IP y fabricante | Referencia de mercado | Medir tira real, ancho, espesor, zonas de corte y cableado |
| SN74AHCT125 | SOIC-14 aprox. **8,65 × 6 mm**; TSSOP-14 aprox. **5 × 6,4 mm** (dimensiones de paquete del fabricante) | Texas Instruments | Elegir encapsulado y footprint conforme a hoja técnica |
| Pulsador mecánico NA | **TBD**: no hay modelo seleccionado | Sin evidencia | Elegir por fuerza de actuación, carrera, sobrecarrera y vida útil; fijarlo al bastidor, no a la PCB |
| Conector batería / LED | **TBD** | Sin evidencia | Elegir serie con retención y corriente nominal suficiente |
| PCB portadora nodo | **65 × 75 mm** como hipótesis de reserva | Propuesta de ingeniería, no medida | Verificar espacio para antena, tornillos, conector y soporte |
| Carcasa hexagonal | **150 mm entre vértices; 129,9 mm entre caras**, altura objetivo 45–55 mm | Decisión preliminar de diseño | Ajustar al apilamiento, mecanismo, batería y soporte |

## Documentación consultada
- Espressif DevKitC V4: https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32/esp32-devkitc/user_guide.html
- Referencia DOIT DevKit V1: https://www.espboards.dev/esp32/esp32doit-devkit-v1/
- Portaceldas Keystone (plano PDF): https://datasheet.lcsc.com/lcsc/2311231209_Keystone-1047_C5472171.pdf
- SN74AHCT125: https://www.ti.com/product/SN74AHCT125
- WS2812B / NeoPixel: https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels

## Procedimiento de medición
1. Fotografiar ambos lados con regla o calibre y anotar fabricante, serigrafía, revisión y número de pines.
2. Medir tres veces largo/ancho/alto y distancia entre centros de pines/agujeros; registrar tolerancia instrumental.
3. Crear ficha de pieza con dimensiones, orientación, acceso USB y zona libre para cables.
4. Si hay incertidumbre, imprimir plantilla 1:1 y verificar encastre físico antes de enviar PCB.
5. Exportar STEP del conjunto PCB y contrastar con carcasa, batería y recorrido de tapa.

**Nunca diseñar el footprint del ESP32 «32-s kit» tomando sin verificar la medida de una DevKit V1 de 30 pines.**
