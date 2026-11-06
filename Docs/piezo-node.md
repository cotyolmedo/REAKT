# Piezoeléctrico del nodo — ESP32 clásico, 06/11/2026

Estado: implementado y probado con señales sintéticas; ensayo físico integrado pendiente.
Piezo en IO34 (ADC1_CH6) y salida LED en IO33 por indicación del usuario.
El banco local mantiene LED digital; WS2812B continúa como alternativa sin cambiar
Stimulus.h. No se presume que una tira esté realmente conectada.

## Configuración centralizada

Copiar LocalConfig.example.h a LocalConfig.h y conservar ID/MAC reales. No publicar
configuración local. El MVP sigue limitado a uno o dos nodos, no cinco.

| Parámetro | Valor inicial | Unidad y efecto |
|---|---:|---|
| REAKT_PIEZO_GPIO | 34 | Entrada ADC1 del ESP32 clásico |
| REAKT_LED_GPIO | 33 | Salida digital o datos de WS2812B según configuración |
| REAKT_PIEZO_THRESHOLD | 600 | Cuentas ADC; elegido explícitamente por usuario, sin calibrar golpes |
| REAKT_PIEZO_RELEASE | 50 | Cuentas sobre línea base; superior a picos de reposo informados (máximo 48) |
| REAKT_PIEZO_BASELINE | 0 | Cuentas ADC; señal referida a GND, se resta y limita a cero |
| REAKT_PIEZO_LOCKOUT_MS | 80 | Bloqueo mínimo desde el evento |
| REAKT_PIEZO_QUIET_MS | 30 | Tiempo continuo de muestras <= RELEASE antes de rearmar |
| REAKT_PIEZO_SAMPLE_US | 500 | Período nominal de polling: 2 kHz; no es frecuencia real garantizada |
| REAKT_PIEZO_DIAGNOSTICS | 0 | Cambiar a 1 para calibración; local habilitado |
| REAKT_PIEZO_LOG_MS | 250 | Intervalo serie; mínimo 100 ms |

ADC explícitamente de 12 bits (0..4095), atenuación ADC_11db. RELEASE debe ser
menor que THRESHOLD; períodos positivos, muestreo entre 100 y 10000 us. La línea
base fija evita filtros lentos y no intenta aprender golpes como ruido. No se
incorpora umbral adaptativo sin datos que demuestren su necesidad. Si el reposo
cambia, recalibrar; no usar este detector sin adaptar la base a una señal sesgada
a media alimentación. Los valores no miden fuerza ni intensidad física.

## Detector y tiempos

Piezo.h entrega un único true al cruzar THRESHOLD mientras está READY. Luego pasa
a REFRACTORY y REARMING. Exige simultáneamente 80 ms desde el golpe y 30 ms de
muestras bajas continuas. Un nivel alto al arrancar no dispara. El bloqueo no
se reinicia con Activate: así una oscilación no cuenta en la ronda siguiente.
El evento IMPACT_DETECTED es la devolución true, no un estado que bloquee el loop.

PiezoInput.h adquiere una muestra por vencimiento, antes y entre comandos radio;
no utiliza delay ni inventa muestras de recuperación. SampleClock.h registra
intervalos reales y períodos omitidos. Una separación >=2 períodos invalida la
prueba de reposo continuo; no desarma una entrada que ya estaba READY.
Un pulso entre muestras puede perderse. WS2812B, radio, Serial y otras tareas pueden
crear huecos: hay que medirlos y, si hace falta, diseñar captura continua o un
retenedor de pico en hardware. La lógica no garantiza captura de cualquier pulso.

Timestamp: fin de la lectura ADC que cruza el umbral. Se conserva Target::press,
Hit/Early/Miss, ACK, secuencias, canal 6 y protocolo v1 de 32 bytes. El antirrebote
de 20 ms del pulsador ya no forma parte del tiempo informado. El gateway conserva
su deduplicación de paquetes; el nodo suprime las oscilaciones físicas. Son tareas
distintas. Si hay un evento pendiente sin ACK, se conserva y se incrementa busy
al no poder encolar otro impacto; no se promete entrega ilimitada de golpes.

## Diagnóstico serie a 115200

Habilitar REAKT_PIEZO_DIAGNOSTICS=1 en LocalConfig.h. Se imprime cada 250 ms:

- raw: última lectura; peak: máximo desde el último diagnóstico emitido.
- hits: impactos físicos detectados acumulados, incluso antes de una sesión.
- state: 0 READY, 1 REFRACTORY, 2 REARMING.
- gap_us: intervalo máximo entre comienzos de adquisición; missed: períodos de
  muestreo omitidos (no es número de golpes perdidos).
- adc_us y detect_us: máximos de adquisición y procesamiento local.
- send_us: máximo desde la lectura del impacto hasta justo antes de solicitar
  su primer envío ESP-NOW; no mide recepción, tiempo en aire ni latencia física.
- busy: impactos de sesión que encontraron un evento pendiente.
- logskip: líneas omitidas por falta de capacidad serie.

El buffer TX se amplía a 512 bytes; si una línea no cabe se descarta sin esperar.
El reloj no está sincronizado con el gateway, por lo que no se calcula latencia
entre dispositivos restando sus timestamps. Saturación 4095 no demuestra seguridad
eléctrica ni informa cuánto excede el rango; el ADC tampoco muestra picos negativos.

## Cableado y protección

El sensor informado es un disco pasivo con 1 MΩ en paralelo y 10 kΩ en serie,
no un módulo con comparador. Un módulo digital DO requeriría otro detector.

| Origen | Destino | Condición |
|---|---|---|
| Disco, electrodo de señal | Resistencia serie 10 kΩ | Conexión informada, no medición independiente |
| Otro extremo de 10 kΩ | Entrada protegida IO34 | Debe limitar ambas polaridades al rango permitido |
| Resistencia 1 MΩ | Entre electrodos del disco | Descarga; no es un limitador de tensión |
| Electrodo de referencia del disco | GND del ESP32 | Referencia común |
| IO33 | Resistencia de LED común y LED hacia GND, o interfaz de datos WS2812B | Según salida configurada; no unir ambas variantes |
| Fuente del ESP32 | USB del banco | Sin batería ni power-path validados |
| Fuente externa de WS2812B | VDD/GND de la tira | Dimensionar con piezas reales; no alimentar desde GPIO |
| GND de fuente de tira | GND del ESP32 | Referencia común si se usa tira |

Esquema funcional informado (la etapa de protección debe verificarse):

    disco señal o----10 kΩ----[limitación de ambas polaridades]----IO34
                |
               1 MΩ
                |
    disco ref.  o------------------------------------------------GND

Las dos resistencias no fijan por sí mismas los máximos positivos/negativos.
No se declara un esquema de diodos o valores definitivos sin verificar tensiones,
corrientes, tolerancias y alimentación. El usuario respondió «ya verifique» a
la solicitud de verificar protección y rango con docente/osciloscopio; se registra
como confirmación del usuario, no como medición del agente ni diseño validado.
PIEZO_VALIDATED permanece 0 por ausencia de evidencia independiente; local tiene
BENCH_TEST=1 por solicitud explícita. El ejemplo mantiene ambos en 0.

Fuentes: [ADC de Arduino-ESP32](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/adc.html)
y [datasheet del ESP32](https://documentation.espressif.com/ESP32_datasheet_en.pdf).
IO34 es ADC1, solo entrada, sin pull-up interno; ADC2 se evita por Wi-Fi.
No trasladar estos GPIO a C3/S3. La confirmación posterior de ESP32 común sustituye
la referencia a C3 del pedido inicial. Modelo de placa exacto pendiente de ROM/MAC.

## Procedimiento físico A–I (sin resultados inventados)

Identificar primero rol/MAC, respaldar flash y cargar únicamente la placa correcta.
Abrir serie 115200, verificar versión piezo-v2, GPIO/umbrales y ausencia de errores.
Mantener habilitados diagnósticos y registrar la salida en archivo.

| Prueba | Procedimiento y criterio |
|---|---|
| A Reposo | 60 s sin tocar, luego 5 min; hits sin incremento. Registrar soporte y ruido |
| B Individual | 20 golpes separados por >=1 s; hits aumenta exactamente 20 |
| C Fuerte | 20 golpes fuertes separados; observar ringing, un evento por golpe |
| D Consecutivos | 20 pares por separación 500/250/150/100 ms; registrar reales con video/instrumento. Reducir hasta encontrar límite fiable |
| E Vibración | 60 s con movimientos leves definidos; registrar falsos positivos, no confundir con golpes válidos |
| F Integración | Una ronda manual por golpe, comprobar Hit en gateway/app, nodo y secuencia correctos; repetir sin golpe para Miss y con Stop para Cancel |
| G LED/radio | Repetir B/F con la salida instalada, revisar gap_us, missed, busy y errores radio; repetir con WS2812B solo si están conectados/verificados |
| H Reinicio | Reiniciar nodo y gateway; no aceptar eventos antiguos y volver a iniciar sesión |
| I Prolongado | 1000 impactos etiquetados, separados según D, incluyendo B–G; registrar detectados, perdidos, duplicados y falsos |

Meta 99 %: evaluar correspondencia uno a uno con golpes físicos etiquetados y
contabilizar aparte falsos/duplicados. No basta contar hits sin una referencia.
El mínimo físico entre golpes y latencia total requieren medición; los tests
sintéticos solo demuestran reglas lógicas. El protocolo permite un Hit por ronda;
un segundo golpe en esa ronda es Early, no un segundo Hit de entrenamiento.

Para carga manual: cerrar monitor, mantener BOOT, tocar EN/RESET, soltar BOOT y
leer MAC con esptool. COM4 existe pero el primer intento devolvió Wrong boot mode
0x13: no hay identificación de ROM/MAC ni respaldo de flash actuales todavía.
No sobrescribir por asumir que COM4 conserva el rol histórico de gateway.
