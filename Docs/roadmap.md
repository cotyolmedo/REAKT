# REAKT Roadmap

## Current phase

Initial/incremental development.

The project should be advanced in demonstrable stages.

## Phase 0 - Repository and documentation

- [x] GitHub repository exists
- [ ] Codex repository instructions installed
- [ ] architecture documented
- [ ] hardware inventory documented
- [ ] protocol specification finalized
- [ ] development workflow documented

## Phase 1 - Gateway and nodes

- [ ] ESP32 gateway base firmware
- [ ] ESP32-C3 node base firmware
- [ ] ESP-NOW connection test
- [ ] bidirectional communication
- [ ] multiple-node communication
- [ ] error/timeout handling

## Phase 2 - Global packet protocol

- [ ] finalize packet types
- [ ] finalize node ID
- [ ] finalize mode representation
- [ ] finalize timing representation
- [ ] finalize payload
- [ ] compatibility tests

## Phase 3 - Flutter

- [ ] project structure
- [ ] initial UI
- [ ] gateway connection
- [ ] command transmission
- [ ] event reception
- [ ] result display

## Phase 4 - Supabase

- [ ] schema design
- [ ] migrations
- [ ] authentication if required
- [ ] result persistence
- [ ] historical data
- [ ] security policies

## Phase 5 - First complete training mode

Implement one complete mode end-to-end before implementing all modes.

Candidate modes:

- memoria
- agilidad
- reflejos
- velocidad
- resistencia
- precisión
- coordinación

The selected first mode must be explicitly decided.

## Phase 6 - Remaining modes

- [ ] implement remaining modes
- [ ] reuse global packet infrastructure
- [ ] validate node behavior
- [ ] validate metrics

## Phase 7 - Final integration

- [ ] hardware integration
- [ ] application integration
- [ ] database production setup
- [ ] reliability testing
- [ ] enclosure
- [ ] PCB
- [ ] documentation

## Phase 8 - Exhibition

- [ ] complete live demo
- [ ] backup source code
- [ ] field documentation
- [ ] final schematic
- [ ] process evidence
- [ ] user manual
- [ ] technical documentation
