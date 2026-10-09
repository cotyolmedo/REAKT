# REAKT Architecture Decision Record

This file records significant decisions.

## ADR-001 - Primer shell de interfaz Flutter

Date: 2026-10-09
Status: Accepted

### Decision

Se adopta una primera interfaz Flutter en `app/` con fondo oscuro, acento rojo REAKT, superficies redondeadas y navegación inferior, trasladando la jerarquía visual de `REAKT_web.html`. Los datos visibles son de demostración y los estados de gateway/backend permanecen pendientes.

### Consequences

La UI puede evolucionar sin comprometer el protocolo ni inventar una interfaz app↔gateway antes de definirla.

## Decision template

```md
## ADR-XXX - Title

Date:
Status: Proposed / Accepted / Superseded

### Context

What problem required a decision?

### Decision

What was chosen?

### Alternatives considered

What other options were considered?

### Consequences

What does the decision improve or make harder?

### Validation

How will the decision be validated?
```

## ADR-001 - Gateway architecture

Date: 2026

Status: Accepted

### Context

REAKT requires communication between the mobile application and multiple ESP32-C3 training nodes.

### Decision

Use one ESP32 as a gateway between the Flutter application and five ESP32-C3 nodes.

### Consequences

The gateway centralizes node coordination and separates application communication from local node communication.

### Alternatives

A Raspberry Pi or direct application-to-node architecture were considered conceptually but are not part of the current architecture.

---

## ADR-002 - Node communication

Date: 2026

Status: Accepted

### Decision

Use ESP-NOW for gateway-to-node communication unless a later decision explicitly replaces it.

### Consequences

The system can communicate locally without requiring each node to maintain a normal Wi-Fi application connection.

---

## ADR-003 - Backend

Date: 2026

Status: Accepted

### Decision

Use Supabase/PostgreSQL as the intended persistent backend.

### Consequences

Database design should follow PostgreSQL principles and Supabase security mechanisms.

---

## ADR-004 - Global packet concept

Date: 2026

Status: Accepted

### Decision

Use a shared packet architecture across training modes.

### Consequences

New modes should reuse the same transport/protocol foundation instead of creating independent communication systems.

---

## Future decisions

Add an ADR whenever a significant choice changes:

- architecture
- communication protocol
- database technology/schema
- Flutter architecture
- hardware topology
- security model
- packet protocol

---

## ADR-005 - PCB V0.1 is a provisional node carrier

Date: 2026-10-09

Status: Provisional / blocked by physical measurements

### Decision

Create only an editable carrier layout for one node: hypothetical 65 x 75 mm outline, provisional 2x15 header reservation for the unidentified ESP32 board, conceptual impact/RGB/battery connectors, and service test points. Do not freeze the ESP32 footprint, battery path, regulator topology, connector series, mounting holes, RF keepout, or routing until the real parts are measured.

### Evidence and consequences

The KiCad 9 board is `hardware/pcb/reakt-nodo/reakt-nodo.kicad_pcb`. It is not fabrication-ready and has no schematic or electrical netlist. The KiCad CLI DRC completed with zero unconnected pads and warnings expected from provisional local footprints and silkscreen; this is not a clean DRC release.
