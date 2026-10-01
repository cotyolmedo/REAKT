# REAKT - Codex Repository Instructions

## 1. Project identity

REAKT is a technical-school integrative project developed for E.E.S.T. N°4 "1ra Brigada Aérea".

The project combines electronics, embedded firmware, software, connectivity, data management and a mobile application.

The repository is the source of truth for the software/firmware side of REAKT.

Read `docs/README.md` first when repository documentation or project architecture needs to be understood.

---

## 2. Project architecture

The intended high-level architecture is:

Flutter application
        ↓
ESP32 Gateway
        ↓
5 × ESP32-C3 training nodes

Reverse direction:

ESP32-C3 nodes
        ↓
ESP32 Gateway
        ↓
Flutter application

The backend/database is Supabase with PostgreSQL.

ESP-NOW is the intended communication protocol between the gateway and ESP32-C3 nodes.

Do not introduce a Raspberry Pi or another central computer unless explicitly requested.

Do not replace Supabase, ESP-NOW, Flutter, ESP32 or ESP32-C3 without an explicit architectural decision.

---

## 3. Development philosophy

REAKT is an evolving real project, not a disposable demo.

Priorities:

1. Reliability
2. Understandability
3. Maintainability
4. Testability
5. Incremental development
6. Appropriate technical complexity

Prefer the simplest architecture that satisfies the requirements.

Do not add libraries, frameworks, abstractions or services just because they are fashionable or theoretically cleaner.

Do not rewrite unrelated working code.

Do not silently change architecture.

---

## 4. Student/learning context

The main developer is a technical-school electronics student.

Code must remain understandable and defensible by a student.

When introducing advanced concepts, explain the reason and document the relevant decision.

Avoid hiding important behavior behind unnecessary abstractions.

The objective is not only to make the system work, but also for the team to understand how and why it works.

---

## 5. Repository areas

- `app/` → Flutter application
- `firmware/gateway/` → ESP32 gateway firmware
- `firmware/nodes/` → ESP32-C3 node firmware
- `backend/` → Supabase/database-related material
- `docs/` → technical and project documentation
- `tests/` → tests and validation material
- `.agent/` → Codex execution-plan rules
- `.codex/` → repository-specific Codex configuration

Use the documentation relevant to the task instead of reading every document for every small change.

---

## 6. Firmware rules

Target hardware:

- ESP32 gateway
- ESP32-C3 nodes

Communication between gateway and nodes uses ESP-NOW unless an explicit decision changes this.

Avoid `delay()` in production firmware.

Prefer:

- `millis()`
- timers
- state machines
- event-driven logic
- non-blocking processing

Keep these responsibilities separated:

- initialization
- configuration
- communication
- input acquisition
- processing
- output/actuation
- error handling

Never hardcode Wi-Fi passwords, API keys, tokens or other secrets.

Do not change GPIO assignments without checking the current hardware documentation.

Maintain compatibility between ESP32 and ESP32-C3 firmware.

---

## 7. Global packet rule

REAKT should use a common packet architecture across modes.

Current conceptual modes/metrics:

- memoria
- agilidad
- reflejos
- velocidad
- resistencia
- precisión
- coordinación

Do not create unrelated packet formats for each mode.

Before changing the packet structure:

1. Inspect all current senders.
2. Inspect all current receivers.
3. Inspect `docs/packet-protocol.md`.
4. Identify compatibility implications.
5. Update the documentation together with the code.

Do not invent protocol fields when the requirement is unspecified. Mark unknown fields as TBD.

---

## 8. Flutter rules

Keep UI and application logic separated.

Prefer separation between:

- presentation/UI
- state/application logic
- communication
- domain/data models
- backend services

Do not place database queries or hardware communication directly inside UI widgets unless there is a documented reason.

Do not add a state-management package unless the project actually requires it.

Do not introduce a large architecture pattern solely for theoretical scalability.

---

## 9. Backend rules

Supabase/PostgreSQL is the intended backend.

Database changes must be documented.

Never expose privileged credentials in Flutter or firmware.

Prefer clear schemas over speculative tables.

Do not create tables or fields merely because they might become useful later.

If a schema change affects the application or firmware, document the dependency.

---

## 10. Git rules

Do not automatically commit or push.

Never force-push.

Never rewrite Git history destructively.

Keep changes focused.

Prefer small logical commits.

Before a requested commit, summarize what changed.

Never remove existing working functionality without an explicit reason.

---

## 11. Implementation workflow

For small tasks:

1. Inspect the relevant files.
2. Make the smallest correct change.
3. Run the most relevant validation.
4. Report what changed and what was tested.

For significant features or refactors:

1. Read `.agent/PLANS.md`.
2. Create/update an ExecPlan.
3. Inspect affected components.
4. Implement incrementally.
5. Validate each stage.
6. Update documentation.
7. Report unresolved risks.

Do not implement a large feature in one uncontrolled rewrite.

---

## 12. Validation

Whenever possible:

- compile firmware after firmware changes
- run Flutter analysis/tests after app changes
- validate database migrations
- verify packet compatibility
- test both successful and failure paths

If validation cannot be performed because required hardware, credentials or tools are unavailable, state that explicitly.

Never claim that hardware behavior was tested when it was only reasoned about.

---

## 13. Documentation rules

Documentation is part of the project.

Update the relevant documentation when a change modifies:

- architecture
- hardware
- GPIOs
- communication protocol
- packet structure
- database schema
- public APIs
- development workflow
- testing procedure

Use `docs/decisions.md` for significant architectural decisions.

Use `docs/roadmap.md` for project phases and progress.

Use `docs/requirements.md` for school requirements.

---

## 14. School requirements

The project must satisfy the official requirements stored in `docs/requirements.md`.

The school requirements have priority over convenience.

Important current requirements include:

- microcontroller
- sensor/data acquisition
- processing/decision logic
- Bluetooth and/or Wi-Fi connectivity
- mobile/web dashboard
- documented database location and integration
- functional prototype for final exhibition
- documented source code
- field/project documentation

Do not claim a requirement is satisfied without evidence.

---

## 15. OpenAI/Codex documentation

If a task concerns OpenAI APIs, Codex, OpenAI tools, plugins or current OpenAI behavior, use the configured OpenAI Developer Docs MCP when available.

Do not rely on stale assumptions about OpenAI products.

---

## 16. Safety and secrets

Never commit:

- passwords
- API keys
- access tokens
- private keys
- production secrets
- personal credentials

Use environment variables or local configuration excluded from Git.

If a secret is discovered in tracked files, stop and report it before exposing or propagating it.

---

## 17. When uncertain

Do not silently invent requirements.

If ambiguity materially affects architecture, hardware, protocol, database design or compatibility, stop and ask for clarification.

For low-risk ambiguity, choose the simplest reversible option and document the assumption.

Never hide an assumption.
