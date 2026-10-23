# Firmware del gateway REAKT

## Estado

`REAKT_Gateway/REAKT_Gateway.ino` es una base de transporte ESP-NOW. Recibe
tramas en una cola acotada y las procesa fuera del callback. No implementa
todavía sesiones ni el protocolo v1.

## Implementado

- Inicialización Wi-Fi en modo estación y ESP-NOW.
- Callbacks de envío y recepción con contadores separados de tramas inválidas,
  tramas descartadas por cola llena y fallos de transmisión.
- Cola de recepción protegida; el callback no interpreta el payload.
- Recuperación periódica y no bloqueante si falla la inicialización.
- Diagnóstico periódico mediante `millis()`.

## Pendiente

- Campos y serialización del protocolo v1.
- MAC, IDs y política de canal de los cinco nodos.
- ACK, reintentos, deduplicación y timeouts semánticos.
- Transporte App ↔ gateway y lógica de sesiones.
- GPIO, indicadores y placa exacta del gateway.

Esos elementos siguen `TBD` en `Docs/packet-protocol.md`, `Docs/hardware.md` y
`Docs/architecture.md`.

## Validación pendiente

1. Seleccionar la placa ESP32 gateway real y registrar la versión del core.
2. Compilar el sketch para ese destino.
3. Verificar por monitor serie la inicialización y la recuperación.
4. Probar recepción y transmisión con un nodo ESP32 real.
5. Extender a cinco nodos tras definir protocolo y direccionamiento.

No hay validación física registrada. No agregar credenciales, MAC, GPIO ni
campos de protocolo ficticios para aparentar una implementación completa.
