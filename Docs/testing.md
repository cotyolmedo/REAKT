# REAKT Testing Strategy

## Testing philosophy

Testing must progress from isolated components to complete system integration.

## Firmware tests

### ESP32 ↔ ESP32-C3

Verify:

- node discovery/addressing
- packet transmission
- packet reception
- invalid packets
- lost packets
- timeout behavior
- multiple nodes
- simultaneous events where applicable

### Sensors

For every sensor:

- idle state
- activation
- false trigger behavior
- expected range
- electrical limits

### Actuators

Verify:

- correct output
- timing
- repeated activation
- failure/recovery behavior

## Application tests

Verify:

- screen navigation
- session configuration
- connection states
- malformed data handling
- result visualization
- backend errors
- offline/disconnected behavior where applicable

## Backend tests

Verify:

- schema constraints
- inserts
- reads
- updates
- authorization
- invalid data
- failure handling

## Integration tests

At minimum:

```text
Flutter
  ↓
Gateway
  ↓
ESP32-C3
  ↓
Gateway
  ↓
Flutter
  ↓
Supabase
```

Test both normal operation and communication failures.

## Evidence

When a requirement depends on physical hardware:

- record test conditions
- record expected result
- record actual result
- record date/version when useful
- store photo/video evidence when required by school documentation

Codex must never fabricate physical test results.
