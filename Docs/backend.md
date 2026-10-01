# REAKT Backend

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

All schema decisions should be recorded in `docs/decisions.md`.

## Integration

The application should interact with the backend through a dedicated service/repository layer.

Firmware should not contain database credentials unless a future architecture explicitly requires direct access and its security implications are documented.
