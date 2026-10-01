# REAKT Architecture

## High-level system

```text
                ┌─────────────────────┐
                │    Flutter App      │
                │ UI + session logic  │
                └──────────┬──────────┘
                           │
                           │ App ↔ Gateway
                           ▼
                ┌─────────────────────┐
                │   ESP32 Gateway     │
                │ coordination/routing│
                └──────────┬──────────┘
                           │
                     ESP-NOW network
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
       ESP32-C3         ESP32-C3         ESP32-C3
         Node             Node             Node
          │
          └──────────── ... up to 5 nodes

Supabase/PostgreSQL
        ↑
        │
   persistent data
        │
   Flutter/backend
```

## Components

### Flutter application

Responsibilities:

- user interface
- training configuration
- session control
- visualization
- result presentation
- communication with the gateway
- backend interaction where appropriate

### ESP32 Gateway

Responsibilities:

- receive commands from the application
- coordinate training nodes
- transmit commands over ESP-NOW
- receive node events/results
- aggregate/forward data
- manage communication state

### ESP32-C3 nodes

Responsibilities:

- local sensor/input acquisition
- local actuation
- LED/light feedback
- local timing
- event generation
- communication with gateway

### Supabase

Responsibilities:

- persistent application data
- users/session data as required
- results/history
- database-backed information required by the application

## Architectural constraints

- No Raspberry Pi unless explicitly approved.
- ESP-NOW is the intended gateway-node protocol.
- The packet model should remain shared across training modes.
- Firmware should be non-blocking.
- Secrets must not be hardcoded.

## Data-flow principle

Commands should move from the application toward the gateway and then to nodes.

Events/results should move from nodes to gateway and then to the application.

Persistent data should be stored in Supabase according to the database design.

## Architectural changes

Any change to this architecture must be recorded in `docs/decisions.md`.
