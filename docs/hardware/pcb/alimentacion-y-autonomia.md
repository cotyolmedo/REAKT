# Alimentación, TP4056 y autonomía

**ESTADO BLOQUEANTE:** sin batería, módulo TP4056 exacto, corriente máxima de LED ni política de uso durante carga, no se libera el esquemático final.

## Carga
El TP4056 es un cargador CC/CV para **una sola celda** Li-ion/LiPo (tensión final típica 4,2 V), no un convertidor 3V3/5V ni un power-path. La corriente de carga depende de la resistencia PROG del módulo. No asumir que todos los módulos USB-C incluyen protección por sobredescarga/cortocircuito. Revisar terminales y chips instalados.

**Alternativa A (prototipo simple):** deshabilitar el funcionamiento durante la carga y usar protección de celda verificada; documentar procedimiento y bloqueo de encendido.

**Alternativa B (funcionar y cargar):** seleccionar cargador/gestor con *power-path* integrado, p. ej. familia BQ2407x adecuada a la corriente, o circuito validado de reparto de carga. No conectar cargas directamente al BAT del TP4056 mientras carga sin resolver la terminación CC/CV.

**Seguridad:** celda de proveedor confiable, sujeción rígida con amortiguación, polaridad marcada, sin soldar directamente a celdas no preparadas, protección de cortocircuito y sobrecorriente, temperatura de carga según ficha técnica. Un módulo sometido a golpes necesita ensayos térmicos y mecánicos adicionales.

## LED y corrientes
Para LED RGB tipo WS2812B, usar una estimación de diseño conservadora de **hasta 60 mA/LED** a blanco pleno, verificando variante y condiciones reales. A 60 LED/m, un perímetro aproximado de 450 mm alojaría cerca de **27 LED** si se emplea esa densidad; depende del canal, empalmes y zonas de corte.

| Cantidad | 20 mA/LED (escenario orientativo) | 60 mA/LED (cota conservadora) |
|---|---:|---:|
| 18 | 0,36 A | 1,08 A |
| 24 | 0,48 A | 1,44 A |
| 27 | 0,54 A | 1,62 A |
| 30 | 0,60 A | 1,80 A |

Sumar corriente ESP32 (incluidos picos Wi-Fi), buffer, pérdidas de convertidores y cualquier buzzer. Elegir regulador, conector, cable, fusible y pistas con margen. La limitación de brillo es útil, pero no sustituye protecciones físicas.

## Ejemplo de autonomía, NO predicción de REAKT
Celda hipotética 1S 3000 mAh, 3,7 V nominal: **11,1 Wh nominales**. Energía utilizable será menor por profundidad de descarga, envejecimiento y eficiencia.

Si la carga promedia 2,0 W y el conjunto convierte con 85 % de eficiencia, autonomía ideal aproximada: `11,1 Wh × 0,85 / 2 W ≈ 4,7 h`. Este número **no es especificación de REAKT**; requiere perfiles reales de LED, radio y carga. No mezclar capacidad en mAh a 3,7 V con consumos de 5 V sin convertir a Wh.

## Instrumentación mínima
- Medir VBAT, V3V3, V5V en reposo, Wi-Fi TX y animaciones intensas.
- Medir corriente pico y promedio con equipo adecuado, no solo multímetro lento.
- Ensayar brownout, corte por batería baja, cortocircuito protegido y recuperación.
- Registrar temperatura de celda, cargador y reguladores en carcasa cerrada.
- Comprobar aislamiento y ausencia de retorno entre USB de programación y fuente de nodo.

## Referencias
- https://pcbwiki.com/parts/tp4056
- https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels
