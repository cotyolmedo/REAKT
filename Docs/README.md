# REAKT Documentation

This directory contains the technical documentation for REAKT.

## Documentation map

| File | Purpose |
|---|---|
| `requirements.md` | Official school requirements relevant to the project |
| `architecture.md` | System architecture and component responsibilities |
| `hardware.md` | Hardware, GPIOs, power and physical interfaces |
| `firmware.md` | Firmware conventions and embedded behavior |
| `packet-protocol.md` | Common communication packet definition |
| `app.md` | Flutter application architecture |
| `backend.md` | Supabase/PostgreSQL architecture |
| `development.md` | Development workflow and tools |
| `testing.md` | Testing strategy and validation |
| `roadmap.md` | Project phases and current progress |
| `decisions.md` | Important architectural decisions |
| `glossary.md` | Project terminology |

## Source-of-truth rules

Code is the source of truth for implementation.

Documentation is the source of truth for agreed architecture, requirements and decisions.

When code and documentation disagree:

1. Determine which one reflects the latest intentional decision.
2. Do not silently rewrite one to match the other.
3. Update the outdated source.
4. Record a decision if the disagreement represents an architectural change.

## Status notation

Use:

- `TBD` → not decided
- `TODO` → decided but not implemented
- `IN PROGRESS` → currently being implemented
- `DONE` → implemented and validated
- `BLOCKED` → cannot proceed because of an external dependency

Do not mark something `DONE` without evidence.
