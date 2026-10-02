# REAKT Gateway Firmware

## Status

Base transport scaffold. It is not yet a functional gateway for training
sessions.

## What exists

`REAKT_Gateway.ino`:

- starts the ESP32 in station mode;
- initializes ESP-NOW;
- registers send and receive callbacks;
- records transport-level diagnostics without interpreting payloads;
- uses a non-blocking `millis()` diagnostic interval;
- leaves explicit hooks for app commands, node-event processing, and outputs.

## Intentionally not implemented

- final node MAC addresses or node registration;
- radio-channel policy;
- packet encoding, validation, ACKs, retries, or deduplication;
- App-to-Gateway protocol;
- GPIOs, sensors, actuators, or power handling;
- Supabase integration;
- session or training-mode logic.

Those items are still TBD in `Docs/hardware.md` and
`Docs/packet-protocol.md`, or require a documented architectural decision.

## Validation pending

1. Select the actual ESP32 gateway board in Arduino IDE.
2. Compile `REAKT_Gateway.ino` with the project ESP32 Arduino core.
3. Confirm serial output reports `ESP-NOW ready`.
4. Record a one-node ESP32-C3 receive test before marking roadmap work done.

No physical validation is claimed by this scaffold.
