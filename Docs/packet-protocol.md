# REAKT Packet Protocol

## Compatibilidad de la app — 2026-10-23

La app recuperada de GitHub `main` en `3f34294` implementa el [contrato MVP v1 remoto](https://github.com/cotyolmedo/REAKT/blob/3f34294/Docs/packet-protocol.md). Este documento local conserva debajo la definición conceptual anterior; no implica que se haya actualizado el firmware local.

Gateway compatible: WebSocket JSON v1, órdenes `start`, `manual`, `stop`, rondas 1..50 y límite 100..10000 ms; snapshots completos validados por `app/lib/services/snapshot.dart`. El MVP admite nodos 1 y 2. La UI no altera ESP-NOW ni crea otra codificación. Comprobar versiones antes de probar hardware.

## Purpose

REAKT uses a common packet concept so different training modes can communicate through the same infrastructure.

The protocol is intentionally documented separately from the implementation.

## Direction

### App → Gateway

Carries commands/configuration.

### Gateway → Node

Carries node-specific commands.

### Node → Gateway

Carries events/results/status.

### Gateway → App

Carries events/results/status.

## Common packet concept

The exact binary/serialized representation is still a technical design task.

Conceptual fields:

| Field | Purpose | Status |
|---|---|---|
| `type` | packet/event type | TBD/finalize |
| `mode` | training mode | TBD/finalize |
| `node_id` | node identity | TBD/finalize |
| `timestamp` | event timing | TBD/finalize |
| `value` | measurement/result | TBD/finalize |
| `sequence` | duplicate/order detection | TBD |
| `payload` | mode-specific data | TBD |

Do not implement these fields blindly. Finalize their types, sizes, ranges and encoding before treating the protocol as stable.

## Modes

Current conceptual modes:

- memoria
- agilidad
- reflejos
- velocidad
- resistencia
- precisión
- coordinación

All modes should reuse the global packet architecture whenever possible.

Mode-specific data should be represented as payload/data rather than creating completely separate protocols.

## Compatibility

When changing the packet:

1. update this document
2. update gateway implementation
3. update node implementation
4. update application model
5. test both directions
6. document backward compatibility or migration requirements

## Validation

At minimum test:

- valid packet
- invalid packet
- unknown packet type
- wrong node ID
- wrong mode
- duplicate packet
- timeout
- lost packet
- out-of-order packet where applicable

## Security

Do not place secrets in packets.

If authentication/integrity becomes necessary, document the threat model before selecting a mechanism.
