# REAKT Testing Strategy

## Verificación de la interfaz Flutter — 2026-10-09

- Estado: UNVERIFIED.
- Se revisó estáticamente la estructura de `app/`.
- No fue posible ejecutar `flutter analyze` ni `flutter test` porque el SDK de Flutter no está disponible en este entorno.
- Falta validar el renderizado en Android/iOS y conectar datos reales cuando se defina la interfaz app↔gateway.

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

## Web REAKT — auditoría Apple

- Se verificaron estáticamente los metadatos Apple, `viewport-fit=cover`, safe areas, navegación móvil y manifest de `REAKT_web.html` el 2026-10-09.
- La verificación visual en Safari sobre iPhone/iPad y el modo Home Screen queda pendiente porque no hay dispositivo Apple disponible en este entorno.
- El detalle de cada cambio está documentado en `cambios pagina.md`.

## PCB V0.1 verification

- KiCad 9 CLI DRC ran on `hardware/pcb/reakt-nodo/reakt-nodo.kicad_pcb` on 2026-10-09.
- Result: file parsed; 0 unconnected pads; 14 silkscreen/library warnings; exit code 0 because violation exit mode was not requested.
- ERC, schematic parity, fabrication review, 3D fit and physical tests: pending because the real component variants and power architecture are TBD.
