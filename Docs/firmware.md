# REAKT Firmware

## Firmware targets

- ESP32 Gateway
- ESP32-C3 Nodes

## Development environment

Primary intended environment:

- Arduino IDE during current development
- C/C++ firmware
- ESP32 Arduino core

## Core rules

Production firmware should be non-blocking.

Avoid:

```cpp
delay(...)
```

Prefer:

- `millis()`
- timers
- finite-state machines
- event-driven logic

## Firmware structure

A firmware project should separate:

```text
Initialization
    ↓
Communication
    ↓
Input acquisition
    ↓
State/logic processing
    ↓
Output/actuation
    ↓
Telemetry/results
```

## Gateway responsibilities

The gateway should:

1. initialize communication
2. maintain known node information
3. receive commands from the application
4. validate incoming commands
5. transmit commands to nodes
6. receive node events
7. validate events
8. forward/aggregate information
9. handle communication failures

## Node responsibilities

A node should:

1. initialize GPIO and communication
2. receive commands
3. enter the requested training state
4. read local inputs
5. drive local outputs
6. timestamp/measure events as required
7. send events/results to the gateway
8. recover from communication failures

## Error handling

Firmware should explicitly handle:

- failed packet transmission
- invalid packet
- unknown node
- timeout
- duplicate event
- unexpected state
- initialization failure

Do not hide communication failures.

## Timing

Training timing must not depend on blocking delays.

Timing-sensitive behavior should use monotonic elapsed-time measurements.

## Debugging

Serial logging is allowed during development.

Production/debug logging should be controllable so it does not interfere with timing or communication.
