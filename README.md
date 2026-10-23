# REAKT

MVP de entrenamiento interactivo de la E.E.S.T. N.º4. Entrega objetivo: **6 de
noviembre de 2026**. Flutter Android ↔ WebSocket local ↔ ESP32 gateway WROOM-32 ↔
ESP-NOW ↔ uno o dos nodos con pulsadorNA y salida prevista de cinco WS2812B.

## Empezar

- [Estado actual y guía de pruebas del 23/10](Docs/PROBAR-HOY.md): empezar aquí.
- [APK 0.3.0 publicado y evidencia](Docs/android-release-2026-10-23.md).
- [Montaje de banco con pulsador y LED opcional](Docs/MVP-PROTOBOARD.md).

- [Instalación, configuración y pinout](Docs/mvp-installation.md).
- [Pruebas físicas y meta de diez sesiones](Docs/mvp-physical-tests.md).
- [Protocolo compartido](Docs/packet-protocol.md).
- [Bitácora y evidencia](Docs/implementation-log.md).
- [Backend y autorización condicional](backend/README.md).
- [Informe técnico](Docs/mvp-school-report.md).

## Estado real

App Flutter 0.3.0 implementada, **21 tests aprobados**, APK debug Android 7+ publicado
y verificado por checksum/firma. Firmware gateway/nodo implementado y compilado;
el nodo admite salida deshabilitada, LED digital o WS2812B. Supabase remoto tiene
esquema aplicado y RLS comprobado. Falta validar la cadena física completa,
el teléfono y la sincronización desde Android. Ver [estado actual](Docs/PROBAR-HOY.md).

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
