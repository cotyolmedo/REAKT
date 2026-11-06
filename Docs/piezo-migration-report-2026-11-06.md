# Informe de migración a piezo — 06/11/2026

## A. Firmware encontrado y respaldo

Repositorio: `C:/Users/Alumno/Desktop/ajaja/REAKT`.

- Nodo: `C:/Users/Alumno/Desktop/ajaja/REAKT/firmware/nodes/REAKT_Node/REAKT_Node.ino`.
- Gateway: `C:/Users/Alumno/Desktop/ajaja/REAKT/firmware/gateway/REAKT_Gateway/REAKT_Gateway.ino`.
- Origen: rama main, commit `c41c62d1c95877bccd2171884142ef7f0d4bb628`.
  `git ls-remote` confirmó ese mismo HEAD en main remoto al inspeccionar.
- Los cambios de piezo de esta conversación estaban sin confirmar; se conservaron
  junto con los cambios ajenos en web y dos PNG. No se sustituyó el trabajo local.
- El banco documentado en octubre utilizó ESP32 clásico, nodo1 con pulsador18 y
  LED digital23. La nueva asignación explícita es piezo34/LED33. El usuario
  confirmó ESP32 comunes, sustituyendo la mención al C3 del pedido inicial.
- Canal ESP-NOW6, ID local1, peer gateway y peer nodo1 ya configurados con MAC
  reales privadas; nodo2 sin configurar. No se cambiaron MAC, ID ni contraseña.
- Implementación MVP: hasta dos nodos. Cinco es ampliación, no capacidad nueva.

Antes de editar esta ampliación se copiaron firmware completo (incluidos archivos
locales privados), Tests, Docs, README, AGENTS y diff previo a:
`C:/Users/Alumno/Desktop/ajaja/REAKT/.school-work/backups/piezo-20261106-110715/`.
`committed-node/` conserva también los cuatro archivos del nodo anterior tomados
de HEAD; `base-commit.txt`, `status.txt` y `preexisting.patch` permiten reconstruir
el origen y los cambios. La exportación general por git archive se interrumpió
por una descarga de objetos pendiente: `committed-source.zip` está vacío, NO es
un respaldo válido. El respaldo recuperable es la copia de carpetas y
`committed-node/`, no ese ZIP. El respaldo posterior de flash física se registra en F.

## B. Modificaciones

| Archivo | Cambio |
|---|---|
| firmware/nodes/REAKT_Node/Config.h | IO34/33, ADC y parámetros, límites y selección LED efectiva de build |
| firmware/nodes/REAKT_Node/LocalConfig.example.h | Configuración reproducible sin MAC inventadas; prueba deshabilitada por defecto |
| firmware/nodes/REAKT_Node/LocalConfig.h | Privado/ignorado: umbral600, release50, diagnóstico1 y prueba autorizada |
| firmware/nodes/REAKT_Node/Piezo.h | init/update, histéresis, bloqueo, reposo, breakQuiet/state |
| firmware/nodes/REAKT_Node/SampleClock.h | init/due: vencimientos, huecos reales, sin muestras ficticias |
| firmware/nodes/REAKT_Node/PiezoInput.h | begin/poll/diagnostics: adquisición, timestamp y salida serie limitada |
| firmware/nodes/REAKT_Node/REAKT_Node.ino | pollImpact; report retorna resultado; setup/loop integran sensor y métricas |
| Tests/piezo_test.cpp | Casos adversos, muestreo y ensayo sintético de1000 impactos |
| tools/test-core.sh | Incorpora prueba nueva al runner nativo |
| tools/compile-firmware-windows.ps1 | Off/Digital/Pixels prevalecen sobre LocalConfig para compilar la variante solicitada |
| README, AGENTS, Docs y firmware/nodes/README | Decisiones, guía, protocolo semántico, evidencia y este informe |

Gateway, ReaktCore, Stimulus, app y backend permanecen sin modificaciones. El
gateway ya valida MAC/nodo/sesión/ronda, confirma eventos y deduplica secuencias.
No se agregaron mensajes ni campos: v1 conserva sus32bytes y ACK/reintentos.
La supresión física se hace en Piezo; la de paquetes se conserva en gateway.
La marca temporal nueva excluye el antiguo debounce20ms; no se afirma equivalencia
metrológica con el pulsador. Se conserva un Hit por ronda y Early fuera de objetivo.

## C. Conexiones eléctricas

Modelo declarado: ESP32 clásico; modelo/revisión de placa exactos pendientes de ROM.
Sensor declarado y mostrado: disco pasivo, no módulo DO. Cableado de señal:

    disco señal ----10 kΩ----etapa protegida----IO34 (ADC1_CH6)
          |
         1 MΩ
          |
    disco referencia--------------------------GND

| Conexión | Pin y condición |
|---|---|
| Entrada piezo acondicionada/protegida | IO34, sin INPUT_PULLUP |
| Referencia del sensor | GND común ESP32 |
| LED actual | IO33, LED digital configurado localmente, con resistencia propia |
| WS2812B opcional | Datos por IO33 mediante interfaz adecuada; alimentación externa dimensionada y GND común |
| ESP32 del banco | USB; batería/regulador/power-path no validados |

Las resistencias descargan y limitan corriente; no fijan por sí solas los máximos
positivos/negativos. La etapa de protección debe cubrir ambas polaridades y el
rango ADC real. El usuario respondió «ya verifique» a la solicitud de verificar
protección/rango con docente/osciloscopio. Es evidencia informada por usuario;
no se recibieron valores ni oscilogramas y no se realizaron mediciones propias.
No se declara diseño eléctrico final ni se inventan componentes de clamp.
Un módulo con comparador DO sería entrada digital y no usa este detector ADC.
Pinout, rango ADC y procedimiento completo: [guía](piezo-node.md).

## D. Calibración e instrumentación

| Parámetro | Valor y motivo |
|---|---|
| Impacto | 600 cuentas por pedido explícito «usa600»; sin medición de golpes |
| Liberación | 50 cuentas; picos de reposo0..48 confirmados por usuario |
| Histéresis | 600/50; evita rearme cerca del umbral de golpe |
| Refractario | 80ms inicial, no calibrado físicamente |
| Reposo continuo | 30ms; también debe haber terminado el refractario |
| ADC | 12bits, ADC_11db, amplitud positiva sobre base fija0 |
| Muestreo | Nominal500us/2kHz por polling; real sujeto al loop y medido con gap_us |
| Filtrado | Sin promedio lento ni umbral adaptativo; preserva la primera muestra de cruce |
| Diagnóstico | Serie115200, cada250ms, bufferTX512 y descarte de líneas si no caben |

Pendientes: amplitudes de golpes suaves/fuertes, ruido del montaje definitivo,
ringing, ajuste de80/30ms, mínima separación física y frecuencia efectiva bajo
radio/LED. Dos eventos sintéticos separados81ms se distinguen con reposo suficiente;
no constituye un límite físico medido. Un pulso entre muestras puede perderse.
adc_us/detect_us/send_us son tiempos internos locales: send_us termina antes de
solicitar envío, no mide aire/recepción ni latencia física completa. Sin sincronizar
relojes no se atribuye una demora extremo a extremo.

## E. Pruebas y observaciones

Ejecutadas con MinGW de CodeBlocks, C++17, Wall/Wextra/Werror/pedantic, sin sanitizers:

- Piezo: PASS arranque alto, umbral exacto600, ruido<=48, histéresis600/50,
  oscilaciones, bloqueo, reposo, saturación y recuperación, reinicio lógico,
  huecos de adquisición y wrap de millis/micros.
- Ensayo sintético:1000 impactos esperados,1000 eventos, cero adicionales en la
  señal construida. No son golpes reales ni una tasa física de99% demostrada.
- Integración nativa: Target Hit/Early/Miss, codificación/decodificación32bytes,
  nodo y deduplicación de secuencia: PASS.
- core_test: PASS protocolo, CRC/rangos, dedup, ACK/reintento/wrap, debounce
  histórico, deadline y score.
- link_sim_test: PASS10sesiones simuladas de10rondas con pérdidas y duplicados.

COM4 emitió «Lectura:0 Pico:0» durante una captura serie de3s del sketch previo;
no hubo golpes físicos etiquetados ni prueba de integración observada. No se
infiere presencia correcta del sensor, ausencia universal de ruido ni calibración.
Impactos físicos detectados/perdidos/duplicados/falsos: NO MEDIDOS. Latencia física:
NO MEDIDA. Ensayos A–I preparados en la guía; requieren participante y placas.

## F. Compilación y carga

Entorno instalado: Arduino CLI, FQBN esp32:esp32:esp32, core3.3.4, ReaktCore1.0.0.
Para la variante WS2812B se instaló Adafruit NeoPixel1.12.3. Se conserva LED digital
en la configuración local; compilar WS2812B no confirma qué salida está conectada.
Resultados de builds finales se registran en [testing.md](testing.md).

Inventario USB: COM4 CP210x, COM1 UART interno. Tras mantener BOOT durante la
conexión se identificó ESP32-D0WDQ6-V3 revisión3.1, cristal40MHz y flash4MB.
La MAC leída coincide exactamente con NODE1_MAC del gateway privado: COM4 es
el nodo1, no el gateway histórico. No se publican esas MAC en el informe.

Se leyó toda la flash antes de escribir:4194304bytes a115200baudios en379,8s.
Archivo privado `.school-work/backups/piezo-20261106-110715/node1-before-upload-4MB.bin`,
SHA256 `B96F702AD8DE7FBDF6FFAC9511E401A524ECFB8EEF4A052476E79958685E6C14`.
La tabla de particiones coincide byte a byte con la compilada, app0 comienza
0x10000 y tiene0x140000bytes; metadatos de arranque seleccionan app0.

Carga esptool5.1.0 del binario digital de905616bytes, solo aplicación a0x10000:
PASS, `Hash of data verified`,53,7s. SHA256 del binario cargado:
`9FA22301090BF49AB99CBEA835B9923DBAB50492A3A4F6D55CE41F8384AFA293`.
Después se releyeron0x0000..0xffff: los65536bytes coinciden con el respaldo,
incluidos bootloader, tabla, NVS y otadata. No se borraron configuraciones ni
se reescribió el firmware del gateway. Respaldo y logs permanecen privados.

Reinicio por RTS y monitor115200: arranque piezo-v2, nodo1, GPIO34,
threshold600/release50, LED habilitado. Radio inicializa sin error; sesión0
sin gateway. La salida cargada es LED digital enIO33, no WS2812B.
Captura de60s en reposo solicitado:240 diagnósticos, hits0→0, pico0,
gap máximo610us, missed0, adc_us máximo311, detect_us máximo9,
busy0 y logskip0. Estos tiempos son máximos internos, no latencia física.

Primera captura45s para10golpes: hits0→0 y pico0; todavía no hay confirmación
de golpes físicos realizados, así que la detección permanece pendiente. El usuario
indicó que el gateway/app todavía no están listos, por lo que la integración
ESP-NOW y la observación visual de estímulos siguen pendientes. COM19 no está
presente. Computer Use: skill leída; node_repl requerida no disponible. Se usaron
CLI y serie.NET, sin simular acciones de Arduino IDE.

## G. GitHub

Rama de trabajo: `codex/piezo-io34-diagnostics-20261106`, originada en c41c62d.
Commit de implementación: `0fc6e1aac977cf1f00eacf7326c4f3a1076f78a7`,
`feat: migrate node impacts to IO34 piezo with diagnostics and IO33 LED`.
Push de ese commit completado en origin con upstream configurado, sin merge a main.
Esta actualización documental registra el resultado después de publicar la implementación.
Solo se incluyen firmware, pruebas, herramientas y documentación relacionadas.
REAKT_web.html y los dos PNG ajenos permanecen sin confirmar. Configuración local,
logs, backups y builds están ignorados y no se publican.

## H. Estado final por evidencia

| Elemento | Estado |
|---|---|
| Detección/histéresis/bloqueo/rearme lógicos | Verificado con pruebas sintéticas |
| Nodo ADC y diagnóstico | Implementado; pendiente de prueba física |
| Compatibilidad protocolo y deduplicación | Verificada en código y simulaciones; radio físico pendiente |
| LED digital y WS2812B | Comportamiento de salida preservado; nuevo cableado pendiente de ensayo |
| Protección eléctrica | Verificación informada por usuario; sin mediciones propias |
| ROM/MAC/rol actual, respaldo flash y carga | Verificados: nodo1 COM4, carga y hash aprobados |
| Arranque nuevo y reposo60s | Verificados en nodo1; resto de A–I pendiente |
| Meta99%, separación mínima y latencia física | No medidas; no garantizadas |

La migración no se declara completamente terminada: faltan
ensayos físicos integrados conforme a los criterios solicitados.
