# REAKT

MVP de entrenamiento interactivo de la E.E.S.T. N.º4. Entrega objetivo: **6 de
noviembre de 2026**. Flutter Android ↔ WebSocket local ↔ ESP32 gateway WROOM-32 ↔
ESP-NOW ↔ uno o dos nodos con pulsadorNA y salida prevista de cinco WS2812B.

## Empezar

- [Estado final de esta entrega](Docs/ESTADO-FINAL-MVP.md).
- [Guía para el colegio mañana 23/10](Docs/GUIA-COLEGIO-2026-10-23.md).

- [Instalación, configuración y pinout](Docs/mvp-installation.md).
- [Pruebas físicas y meta de diez sesiones](Docs/mvp-physical-tests.md).
- [Protocolo compartido](Docs/packet-protocol.md).
- [Bitácora y evidencia](Docs/implementation-log.md).
- [Backend y autorización condicional](backend/README.md).
- [Informe técnico](Docs/mvp-school-report.md).

## Estado real

Firmware nodo y gateway **COMPILADO** con Arduino-ESP32 2.0.17. Componentes del
protocolo **PROBADOS** en C++ con pérdidas y duplicados simulados. SQL **PROBADO**
en PostgreSQL aislado con once casos de RLS/constraints; no aplicado remotamente.
Cliente Flutter/Android **IMPLEMENTADO**; análisis sin errores y **17 tests Flutter
aprobados**, incluida UI→WebSocket→SQLite con servidor de prueba. APK debug **COMPILADO** y firmado;
[entrega final](Docs/ESTADO-FINAL-MVP.md) contiene artefactos y límites. No hay validación completa App↔radio↔hardware↔Supabase.

Actualmente solo hay placas y pulsador: LEDs y su alimentación faltan. GPIO18/23
son propuestas por validar; MAC y credenciales no se inventan. La configuración
inicial no habilita hardware sin verificación. No se consideran medidas físicas
las reacciones del simulador o los tiempos sin estímulo luminoso.

## Desarrollo

`./tools/test-core.sh`: pruebas C++ y simulación de diez sesiones.
`python3 tests/test_mock_gateway.py`: contrato del simulador WebSocket.
`python3 tests/test_backend.py`: migración y RLS en PostgreSQL local aislado.
Dependencias Python en `tools/requirements-dev.txt`; usar virtualenv. Pruebas SQL
locales usan pgserver en Linux. El panel de banco solo necesita Python y navegador.

Arduino IDE: sketches en firmware/gateway y firmware/nodes, biblioteca local en
firmware/libraries. Flutter: `app/`. Los prototipos web HTML y los ensayos históricos
`Tests/` se conservan. PCB/CAD siguen conceptuales; no son diseños para fabricar.
Leer `AGENTS.md` y `Docs/README.md` antes de cambiar subsistemas. No hacer push ni
merge sin autorización para cambios posteriores. Ver [resumen de entrega](Docs/RESUMEN-ENTREGA.md)
y [prompt para retomar](Docs/PROMPT-PARA-MANANA.md).
