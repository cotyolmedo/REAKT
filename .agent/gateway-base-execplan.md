# Gateway Base Firmware ExecPlan

## 1. Objective

Create a small, understandable Arduino firmware base for the ESP32 gateway. It
must initialize ESP-NOW, expose non-blocking runtime hooks, and avoid defining
the still-pending REAKT packet, node identity, app transport, GPIO map, or
Supabase integration.

## 2. Current state

- The repository has ESP-NOW exploration sketches under `Tests/`.
- The base gateway firmware now exists under `firmware/gateway/`; physical validation is pending.
- `Docs/packet-protocol.md` keeps the packet fields and encoding as TBD.
- `Docs/hardware.md` keeps the final gateway board, GPIO map, and power design
  as TBD.

## 3. Requirements

- Target an ESP32 gateway using the Arduino IDE and ESP32 Arduino core.
- Use ESP-NOW for gateway-to-node transport.
- Keep production behavior non-blocking.
- Keep initialization, communication, app input, processing, output, and
  diagnostics visibly separated.

## 4. Constraints

- Do not hardcode node MAC addresses, Wi-Fi credentials, GPIO assignments, or
  secrets.
- Do not define a final packet format before the protocol decision.
- Do not represent unvalidated hardware behavior as complete.

## 5. Design

The sketch owns ESP-NOW initialization and transport-level reception only.
Callbacks record minimal diagnostics without interpreting payloads. The main
loop periodically reports diagnostics and contains explicit hooks for the
future app interface, packet processing, node routing, and status outputs.

## 6. Implementation steps

- [x] Add the Arduino gateway sketch under `firmware/gateway/`.
- [x] Add a local README that records scope, current limits, and validation.
- [ ] Confirm the final ESP32 board and its ESP32 Arduino core version.
- [ ] Validate ESP-NOW initialization and a one-node physical link.
- [ ] Define packet v1 and register actual node peers.

## 7. Validation

- Compile with the final ESP32 board selected in Arduino IDE.
- Confirm serial output reaches `ESP-NOW ready`.
- Perform and document a physical receive test with one ESP32-C3 node.
- Verify malformed/empty transport input does not enter packet processing.

## 8. Documentation changes

- `firmware/gateway/README.md` describes this base and its non-final areas.
- Do not mark roadmap firmware work done before hardware validation.

## 9. Risks and rollback

- ESP-NOW behavior depends on the installed ESP32 Arduino core and radio
  channel configuration.
- The gateway cannot route production messages until packet and node-ID
  decisions are finalized.
- Rollback consists of removing only the new `firmware/gateway/` files.

## 10. Status

Base created; hardware validation and protocol integration remain pending.

