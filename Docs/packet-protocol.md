# Protocolo REAKT MVP v1

Implementado en `firmware/libraries/ReaktCore/src/ReaktCore.h`. Decisión concretada
por la especificación del MVP suministrada el 22/10/2026. No es compatible con
ensayos históricos. Compilación original con Arduino-ESP32 2.0.17; banco posterior
core3.3.4 con un nodo y primera cadena física comprobada según
[registro del23/10](banco-2026-10-23.md). Matriz de fiabilidad extendida pendiente.

## ESP-NOW

32 bytes exactos, enteros unsigned little endian. Serialización explícita, sin
transmitir structs ni depender de padding. Máximo dos nodos en este MVP.

| Offset | Tamaño | Campo |
|---|---:|---|
| 0 | 2 | ASCII RK |
| 2 | 1 | versión 1 |
| 3 | 1 | Activate=1, Cancel=2, Hit=3, Miss=4, Early=5, Ack=6 |
| 4 | 1 | nodo lógico 1 o 2 |
| 5 | 3 | reservado: siempre cero |
| 8 | 4 | session: identificador aleatorio no cero del gateway |
| 12 | 4 | secuencia no cero del emisor |
| 16 | 4 | ronda (Activate requiere >=1) |
| 20 | 4 | Hit: reacción en microsegundos; Ack: secuencia confirmada |
| 24 | 4 | límite de estímulo en milisegundos (100..10000) |
| 28 | 4 | CRC32 IEEE de bytes 0..27 |

Activate enciende los LEDs si están habilitados e inicia el reloj después de
`show()`. Cancel apaga y desarma el objetivo. Miss marca vencimiento. Early
representa una pulsación sin objetivo activo y conserva la última ronda conocida.
Se confirma cada orden/evento válido con ACK sin confirmar ACKs. ACK identifica
sesión, nodo, ronda y secuencia original; su propia secuencia pertenece al emisor.
No hay sincronización entre relojes. Una pulsación se fecha al **confirmar** 20 ms
de nivel estable; la reacción incluye ese antirrebote. Pulsación mantenida al
arranque no produce evento. Un evento requiere liberación estable para rearmarse.

## Entrega, duplicados y límites

Stop-and-wait por destino: primer envío inmediato, reintento cada 120 ms, máximo
8 intentos. ACK de enlace ESP-NOW no sustituye al ACK de aplicación. Duplicados
se confirman sin volver a encender, reiniciar reloj ni contar resultados. Ventana
de secuencia modular por emisor y sesión; se presupone menos de 2^31 mensajes
entre observaciones. MAC origen debe coincidir con el peer configurado.

Al cambiar sesión, el nodo invalida pendientes y ventana de comandos. Recuerda
las últimas ocho sesiones retiradas para rechazar órdenes retrasadas. No protege
contra reproducción maliciosa de sesiones más antiguas ni reinicio del nodo;
reinicio o pérdida prolongada de radio exige reiniciar la sesión de entrenamiento.
Una orden de ronda posterior confirma implícitamente el evento de la anterior.
El gateway ignora eventos de otra sesión, ronda o nodo objetivo; Early se cuenta
como diagnóstico si pertenece a una ronda ya iniciada y hay espacio reservado.
La cola radio tiene 15 plazas útiles y descarta al llenarse, con contador visible.

Gateway permite 1..50 rondas y reserva espacio para cada resultado en un historial
de 64 eventos. Los Early adicionales no se almacenan ni cuentan al agotar el
espacio libre reservado. Backpressure del nodo no sobrescribe un evento pendiente.
Una pérdida no resuelta marca `interrupted`, nunca inventa un fallo del usuario.
No hay almacenamiento duradero en ESP32: solo la última sesión se retiene en RAM.

## WebSocket local

SoftAP `REAKT-MVP`, canal 6; teléfono conectado directamente. Gateway station MAC
para ESP-NOW y SoftAP MAC son diferentes. Endpoint `ws://192.168.4.1:81/`.
Contraseña WPA2 configurada localmente, >=12 caracteres. Sin dependencia Internet.

App envía JSON <=700 bytes, `v=1`, `id` string 1..64, `command` uno de `status`,
`start`, `manual`, `stop`. Start/manual incluyen `rounds` (1..50) y `limit_ms`
(100..10000). Manual fuerza una sola ronda. Repetir el último ID no ejecuta de
nuevo la orden; la app no reenvía automáticamente órdenes de entrenamiento.

Ejemplo: `{"v":1,"id":"cmd-1","command":"start","rounds":10,"limit_ms":1500}`.

Gateway envía `snapshot` completo al conectar, cambiar estado y cada segundo:
`v`, `type`, `session_id` UUID v4, `status`, `active`, `round`, `rounds`, `limit_ms`,
`target`, `hits`, `misses`, `early`, `mean_us`, `events`, `nodes`, `error`,
`diagnostics`. Evento: `id` (`UUID:ordinal`), `round`, `node`, `kind`
(`hit|miss|early`) y `reaction_us`. Estados terminales: `completed`, `cancelled`,
`interrupted`. `idle` carece de ID. `nodes` indica peers configurados, no presencia
verificada. La lista íntegra permite recuperar resultados tras reconexión mientras
no haya reinicio ni otra sesión. Flutter valida contrato y métricas antes de guardar.

## Seguridad y límites conocidos

CRC detecta corrupción, no autentica. ESP-NOW sin cifrado, MAC susceptible de
suplantación. WebSocket sin TLS limitado a la red de banco: todo cliente con la
contraseña Wi-Fi puede emitir órdenes. No usar en una red compartida no confiable.
La app Android solo autoriza tráfico claro al gateway y direcciones locales de
prueba. Supabase requiere HTTPS y Auth; no contiene secretos del backend en radio.
