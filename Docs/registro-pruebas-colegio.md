# Registro de banco — 23/10/2026

Registro actualizado con el primer ensayo físico. Se distingue confirmación del
usuario en Android/LED de lecturas automáticas por serie. Las filas pendientes y
las diez sesiones inferiores no se completan por inferencia. Evidencia en
[banco-2026-10-23.md](banco-2026-10-23.md).

- Responsables y docente:
- Computadora/SO/herramientas y versiones:
- Identificación física de gateway y nodo(s): gatewayCOM4, nodo1COM19.
- Firmware/ZIP/SHA256 usados: fuente2bdefbc, core3.3.4; hashes de carga verificados.
- Pinout revisado por:
- Componentes disponibles / faltantes:
- LED_ENABLED:1, DIGITAL:1; LED común con resistencia confirmado por usuario.
- MAC reales registradas en archivo local seguro (no inventar):
- Logs y archivos JSON de evidencia:

| Ensayo | Esperado | Resultado real | Evidencia / problema / próxima acción |
|---|---|---|---|
| Carga gateway/nodo | Inicio y configuración correctos | APROBADO | Hashes y arranque serie de ambos roles |
| Conectar cliente | Snapshot válido | CONFIRMADO POR USUARIO | App Android conectada al gateway |
| Pulsación | Un evento y un hit | APROBADO EN BANCO | Usuario observó LED/pulsación; serie completed/hit1/miss0 |
| Mantener pulsador | Sin eventos repetidos | CONFIRMADO POR USUARIO | Solo un acierto manteniendo pulsación |
| Soltar y volver a pulsar | Rearme estable | SIN EJECUTAR | |
| No pulsar | Miss al vencer | CONFIRMADO POR USUARIO | A los5s LED apagado y un fallo |
| Detener | Cancelled; sin objetivo activo | APROBADO EN BANCO | Usuario confirmó LED apagado; serie cancelled/target0 |
| Reconectar cliente | Snapshot recuperado | SIN EJECUTAR | |
| Quitar nodo | Interrupción diagnosticada | SIN EJECUTAR | |
| Reiniciar app | Historial local conservado | CONFIRMADO POR USUARIO | Cerró/reabrió y conservó sesiones |
| Sincronizar dos veces | Sin duplicar sesiones/eventos | SIN EJECUTAR | |
| Otra cuenta | No puede leer/modificar datos ajenos | SIN EJECUTAR | |

## Diez sesiones

Registrar separadamente comunicaciones sin LEDs y entrenamiento con estímulo real.

| Sesión | Componentes/modo | Rondas | H/M/E reales | ¿Fallo crítico? | Archivo/log |
|---|---|---|---|---|---|
|1||||||
|2||||||
|3||||||
|4||||||
|5||||||
|6||||||
|7||||||
|8||||||
|9||||||
|10||||||

No anotar “reacción visual validada” sin LEDs, circuito verificado y referencia
independiente. No anotar “nube probada” por haber escrito SQL o usado un simulador.

## Registro inicial 23/10/2026

COM4 CP210x: lectura ROM exitosa después de BOOT manual; ESP32-D0WDQ6 rev1,
MAC 30:c6:f7:92:d0:9c. El usuario asignó esta placa como gateway. No cargada.
Supabase: migración aplicada, metadata RLS verificada; Auth y cadena física pendientes.
Ver [evidencia completa](CONTINUACION-COLEGIO-2026-10-23.md).

Etapa software posterior: Auth confirmado, API/RLS probados; gateway y nodo digital/off
compilados.17tests Flutter aprobados en copia de validación. Sin carga/radio/circuito.
El usuario armará el circuito al terminar esta etapa. No completar casilleros físicos.
[Cierre de etapa y guía de armado](CIERRE-SOFTWARE-2026-10-23.md).
