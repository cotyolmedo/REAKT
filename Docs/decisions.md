# Registro de decisiones de arquitectura (ADR)

## ADR-017 — Puesta en marcha del banco con placas reales

**Fecha:** 2026-10-23. **Estado:** banco básico implementado y probado; matriz extendida pendiente.

El usuario autorizó programar el gateway conectado y confirmó el puertoCOM4 tras
identificación; la segunda placa de nodo apareció enCOM19. Ambos son ESP32 de
4MB identificados por ROM. Las MAC reales se conservan en LocalConfig.h ignorados.
Se respaldaron ambas flashes completas antes de grabar. El usuario confirmó para
el ensayo pulsadorNA enGPIO18 y LED común con resistencia enGPIO23; esto no fija
el pinout de la PCB ni sustituye mediciones eléctricas.

La lectura de MAC para configuración usa esp_read_mac(ESP_MAC_WIFI_STA), porque
WiFi.macAddress() devolvió ceros al arrancar con core3.3.4. El comportamiento de
la API temprana está documentado en el [repositorio oficial de Espressif](https://github.com/espressif/arduino-esp32/issues/11285).
No se altera la MAC de radio, el protocolo ni los GPIO por esta corrección.

## ADR-016 — Integración del MVP y referencia operativa única

**Fecha:** 2026-10-23. **Estado:** aceptada por solicitud del usuario.

Se integra la rama del APK 0.3.0 con el firmware de banco y las herramientas de
la rama colegio. La rama de guardado local contiene el mismo código Flutter;
se conservan los historiales divergentes como ramas de respaldo, sin sobrescribir
los documentos técnicos modernos con versiones anteriores. PROBAR-HOY.md es la
entrada actual; los cierres anteriores conservan su fecha y evidencia.

El gateway operativo es REAKT, no el archivo PILLDROP que se encontraba modificado
en la copia original. Ese archivo se respalda localmente fuera del código operativo.
No se publican sus credenciales. APK debug previo conserva su enlace y checksum;
los pushes validan Android y publicar otro APK requiere workflow_dispatch.
No se cambian protocolo, esquema remoto ni estado de validación física.

## ADR-001 — Gateway central

**Fecha:** 2026. **Estado:** aceptada.

Un ESP32 actúa como gateway entre Flutter y cinco nodos de entrenamiento. El
gateway concentra coordinación y separa el enlace de la app del enlace local.

## ADR-002 — Comunicación entre gateway y nodos

**Fecha:** 2026. **Estado:** aceptada.

Se usa ESP-NOW bidireccional. Canal, direccionamiento, ACK y recuperación ante
errores continúan `TBD`.

## ADR-003 — Backend

**Fecha:** 2026. **Estado:** aceptada.

Supabase/PostgreSQL es el backend persistente previsto. Esquema, autenticación y
RLS todavía no están definidos.

## ADR-004 — Protocolo común

**Fecha:** 2026. **Estado:** aceptada.

Todos los modos reutilizan una arquitectura común de paquetes. Campos y
codificación definitivos continúan `TBD`.

## ADR-005 — Sustitución de ESP32-C3

**Fecha:** 2026-10-08. **Estado:** aceptada.

Se usarán cinco ESP32 periféricos en lugar de cinco ESP32-C3; el gateway sigue
siendo ESP32. Deben revisarse pinout, consumo, dimensiones, alimentación y
firmware. Los GPIO de los ensayos anteriores no se trasladan al diseño vigente.

## ADR-006 — Sustitución del piezoeléctrico

**Fecha:** 2026-10-08. **Estado:** aceptada.

La entrada principal pasa a ser un pulsador mecánico normalmente abierto
accionado por la tapa. Requiere antirrebote y rediseño mecánico. Se pierde toda
posibilidad de inferir fuerza o intensidad desde una señal analógica. Debe
confirmarse con docentes si cuenta como sensor para el requisito escolar.

## ADR-007 — Carcasa hexagonal conceptual

**Fecha:** 2026-10-08. **Estado:** propuesta; validación física pendiente.

Se explora una carcasa hexagonal con tapa móvil, iluminación perimetral y
montaje intercambiable. Dimensiones, materiales, topes, resortes y fijaciones no
son decisiones finales.

## ADR-008 — Carrier PCB para nodos

**Fecha:** 2026-10-08. **Estado:** aceptada como estrategia de prototipado.

La primera placa será una carrier para una placa ESP32 enchufable. El gateway
tendrá una placa distinta. La variante, footprints y pinout deben cerrarse con
mediciones de las piezas reales.

## ADR-009 — Alimentación recargable por definir

**Fecha:** 2026-10-08. **Estado:** propuesta; bloqueada por selección de piezas.

Se evalúa una batería 1S y un módulo TP4056 USB-C. Protección, regulación,
capacidad, corriente de carga y *power-path* deben resolverse antes de fabricar.
El TP4056 no se considera por sí solo una fuente regulada ni un *power-path*.

## ADR-010 — Electrónica aislada del impacto

**Fecha:** 2026-10-08. **Estado:** aceptada.

El bastidor y los topes reciben las cargas. Pulsador, PCB y batería quedan fuera
del camino principal de fuerza. La decisión requiere validación mecánica.

## ADR-011 — Primer shell de interfaz Flutter

**Fecha:** 2026-10-09. **Estado:** aceptada.

Se adopta una primera interfaz en `app/`, basada en la jerarquía visual del
prototipo web. Los datos son de demostración y no definen la interfaz con el
gateway ni el backend.

## ADR-012 — Bases de firmware separadas

**Fecha:** 2026-10-09. **Estado:** en progreso.

`firmware/gateway/` y `firmware/nodes/` contienen bases separadas. Las tramas se
encolan sin interpretar y el nodo implementa antirrebote con el GPIO
deshabilitado mientras el pinout sea `TBD`.

**Validación pendiente:** compilación para placas reales, enlace ESP-NOW y
pruebas físicas del pulsador y WS2812B.

## Plantilla

```md
## ADR-XXX — Título

**Fecha:**
**Estado:** propuesta / aceptada / reemplazada

### Contexto

### Decisión

### Alternativas consideradas

### Consecuencias

### Validación
```

## ADR-013 — MVP aprobado por especificación del usuario

**Fecha:** 2026-10-22. **Estado:** implementado; validación física pendiente.
La especificación recibida concreta WROOM-32/DevKitC, un nodo obligatorio y hasta
dos, cinco WS2812B por nodo, pulsador NA, WebSocket local y entrenamiento coordinado
en gateway. Reduce el alcance inicial de cinco nodos sin cambiar la topología.
Se define protocolo binario común v1, SoftAP en canal 6 y reacción medida solo en
reloj del nodo. GPIO18/23 son propuestas y quedan detrás de habilitación explícita.
El usuario confirma que actualmente solo dispone de placas y pulsador: salida LED
deshabilitada por defecto. La prueba sin LEDs es diagnóstica, no valida reacción
ante estímulo luminoso. No se inventaron MAC ni credenciales.

## ADR-014 — Persistencia offline y seguridad de datos

**Fecha:** 2026-10-22. **Estado:** cliente implementado; Supabase remoto bloqueado.
SQLite guarda snapshots e IDs estables antes de sustituir una sesión; upserts
separados e idempotentes a Supabase Auth, con propietario conservado localmente.
La migración propone tablas con prefijo reakt y RLS por usuario; fue probada en
PostgreSQL aislado, no contra Supabase remoto. El usuario autorizó expresamente
aplicarla **tras inspección y si no hay conflictos**. No se ejecutó remotamente
por ausencia del conector. Si hay conflictos, ajustar y volver a revisar el cambio.
Las sesiones sin dueño se vinculan a la cuenta que inicia su sincronización.

## ADR-015 — Alcance de banco simplificado y persistencia remota

**Fecha:** 2026-10-23. **Estado:** alcance aceptado; validación física pendiente.
El usuario autoriza un MVP en protoboard con pulsador y un LED para completar la
cadena. WS2812B sigue siendo salida prevista ampliada; LED común requiere circuito
y adaptación de firmware pendientes. No habilitar GPIO sin validación real.
La migración de ADR-014 se aplicó al proyecto identificado, sin conflictos, con
versión remota 20261023120712. Se verificaron RLS y permisos; no implica Auth,
sincronización real ni hardware completos.

Implementación posterior: nodo admite LED digital de polaridad configurable o
WS2812B de cantidad configurable, conservando ENABLED=0 por defecto. Compiló
variante digital/core3.3.4. Cuenta Auth confirmada y RLS remoto probado mediante
transacción revertida; circuito y app Android físicos todavía pendientes.
