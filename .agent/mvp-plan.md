# MVP REAKT — plan de ejecución

## Objective
Cadena Flutter Android → WebSocket → gateway WROOM-32 → ESP-NOW → nodo, resultados locales y sincronización Supabase.
## Current state
HEAD 840c9b3, limpio y coincidente con origin/main. Shell Flutter sin servicios, firmware opaco, sin backend ni pruebas actuales. Respaldo /workspace/backups/REAKT-before-mvp.tar.gz verificado por tar y SHA256.
## Requirements
Un nodo obligatorio, hasta dos; cinco WS2812B, pulsador NA, reloj monotónico local, ACK, duplicados, gateway coordina entrenamiento sin Internet. Auth, RLS, outbox persistente.
## Constraints
No inventar MAC. GPIO18/23 requieren habilitación explícita tras validación. No push ni migraciones remotas sin aprobación. Sin conector Supabase disponible. Flutter SDK3.29.3 instalado y validado; Supabase remoto sigue bloqueado por proxy/conector.
## Design
Biblioteca C++ portátil compartida entre ambos sketches: formato binario CRC32, ACK y stop-and-wait, motor de rondas. SoftAP de gateway en canal fijo, peers explícitos; comandos JSON/WebSocket y snapshots con eventos identificados. Flutter conserva snapshots completos y sincroniza por upsert autenticado. SQL aislado preparado para aprobación.
## Implementation steps
- [x] Contrato, biblioteca y pruebas nativas aprobadas.
- [x] Nodo y gateway implementados y compilados con Arduino-ESP32 2.0.17; configuración de hardware deshabilitada por defecto.
- [x] Flutter: transporte, outbox, Auth y UI implementados; SDK impide verificación.
- [x] SQL preparado y probado en PostgreSQL local; documentación y matriz física.
- [x] Compilaciones ESP32 y tests nativos/WebSocket/SQL disponibles ejecutados.
- [x] Flutter SDK3.29.3/Dart3.7.2 instalado; lock resuelto, analyze y17tests aprobados.
- [x] APK Android debug compilado con JDK17/NDK27 y firma verificada; físico pendiente.
- [!] Supabase remoto: aprobación recibida tras inspección sin conflictos, conector no disponible.
- [!] Pruebas físicas: sin acceso a placas; usuario sin LEDs/fuente.
## Validation
Pruebas C++ de serialización, CRC, duplicados, reintentos, debounce, reloj y resultados. Compilar ESP32 con PlatformIO si egress permite toolchain. Flutter analyze/test/build si SDK disponible. Matriz física diez sesiones, sin simular evidencia.
## Documentation changes
Protocolo, arquitectura, ADR, instalación, pinout, pruebas, bitácora y aprobación SQL.
## Risks and rollback
Radio sin cifrar (banco aislado), desconexiones y energía WS2812B. Mantener respaldo completo; no borrar evidencia histórica. Migración remota pendiente, no aplicada.
## Status
Implementación local preparada; dos builds ESP32 y pruebas disponibles aprobadas. No se declara integración completa. Análisis/tests Flutter aprobados. Validaciones remotas y físicas bloqueadas; build APK registrado en el estado final. Aprobación de migración recibida de forma condicional, sin aplicación remota. Ver Docs/implementation-log.md y Docs/testing.md.
