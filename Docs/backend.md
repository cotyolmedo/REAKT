# REAKT Backend

## Estado actual — 23/10/2026

El esquema MVP está aplicado en Supabase remoto y RLS fue comprobado mediante
transacciones revertidas. Auth/API públicos comprobados; login/sincronización de
Android y segundo login real pendientes. No repetir la migración para usar el APK.
Ver [backend/README](../backend/README.md) y [PROBAR-HOY](PROBAR-HOY.md).

## Technology

Intended backend:

- Supabase
- PostgreSQL

## Responsibilities

The backend stores persistent information that the application needs.

Potential categories include:

- users
- training sessions
- session configuration
- results
- node/session metadata
- historical performance

Only create entities that are actually required.

## Database design rules

- use explicit primary keys
- define relationships
- document important constraints
- avoid duplicated data where normalization is useful
- avoid speculative tables
- document migrations

## Security

Never expose service-role credentials in Flutter.

Client-side access must use the appropriate Supabase authentication and authorization model.

Row Level Security must be considered for user-owned data.

## Schema status

The final schema is not yet frozen.

All schema decisions should be recorded in `Docs/decisions.md`.

## Integration

The application should interact with the backend through a dedicated service/repository layer.

Firmware should not contain database credentials unless a future architecture explicitly requires direct access and its security implications are documented.

## Propuesta implementada — 2026-10-22

Ver `backend/README.md` y migración preparada. Diez pruebas PostgreSQL locales
aprobaron; no se inspeccionó Supabase remoto. El usuario autorizó aplicación tras
inspección si no hay conflictos. Ausencia del conector impide ejecutar ese paso.
