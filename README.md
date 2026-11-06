# REAKT

Actualización 06/11/2026: entrada de nodos migrada a piezoeléctrico en IO34 y LED
en IO33 para ESP32 clásico. Umbral inicial 600 elegido por usuario; diagnóstico y
pruebas en [guía de piezo](docs/firmware/piezo-node.md). Compilación y simulaciones no
sustituyen validación física; el banco con pulsador descrito debajo es histórico.

MVP de entrenamiento interactivo de la E.E.S.T. N.º4. Flutter Android ↔ WebSocket
local ↔ ESP32 gateway WROOM-32 ↔ ESP-NOW ↔ uno o dos nodos. La entrada vigente es
piezoeléctrica; el banco probado anteriormente usaba pulsador. Cinco WS2812B por
nodo siguen previstos, sin validación eléctrica.

## Empezar

- [Estado actual y guía de pruebas del 23/10](docs/inicio/PROBAR-HOY.md): empezar aquí.
- [APK 0.3.0 publicado y evidencia](docs/archivo/2026-10/android-release-2026-10-23.md).
- [Montaje de banco con pulsador y LED opcional](docs/inicio/MVP-PROTOBOARD.md).

- [Instalación, configuración y pinout](docs/inicio/mvp-installation.md).
- [Pruebas físicas y meta de diez sesiones](docs/validacion/mvp-physical-tests.md).
- [Protocolo compartido](docs/arquitectura/packet-protocol.md).
- [Bitácora y evidencia](docs/historial/implementation-log.md).
- [Backend y autorización condicional](backend/README.md).
- [Informe técnico](docs/archivo/2026-10/mvp-school-report.md).

## Estado real

App Flutter 0.3.0 implementada, **21 tests aprobados**, APK debug Android 7+ publicado
y verificado por checksum/firma. Firmware gateway/nodo implementado y compilado;
el nodo admite salida deshabilitada, LED digital o WS2812B. Supabase remoto tiene
esquema aplicado y RLS comprobado. Gateway y un nodo ya cargados: primera sesión
manual con LED/pulsador y acierto en Android comprobada por usuario y serie.
Sincronización Android comprobada:11sesiones/11resultados/28eventos en Supabase,
repetición sin duplicados confirmada por usuario. Matriz extendida, dos cuentas
reales y diez sesiones consecutivas completas siguen pendientes.
Ver [estado actual](docs/inicio/PROBAR-HOY.md).

El banco actual usa un nodo por USB, pulsadorNA enGPIO18 y LED común con
resistencia enGPIO23, confirmados por usuario en el ensayo funcional. WS2812B,
alimentación recargable y pinout final de PCB siguen pendientes. MAC y contraseña
quedan en configuración local. La configuración pública por defecto no habilita
hardware; los simuladores no cuentan como evidencia física.

## Desarrollo

`./tools/test-core.sh`: pruebas C++ y simulación de diez sesiones.
`python3 tests/test_mock_gateway.py`: contrato del simulador WebSocket.
`python3 tests/test_backend.py`: migración y RLS en PostgreSQL local aislado.
Dependencias Python en `tools/requirements-dev.txt`; usar virtualenv. Pruebas SQL
locales usan pgserver en Linux. El panel de banco solo necesita Python y navegador.

Arduino IDE: sketches en firmware/gateway y firmware/nodes, biblioteca local en
firmware/libraries. Flutter: `app/`. Los prototipos web HTML y los ensayos históricos
`tests/historicas/` se conservan. El sitio vive en `web/` y la documentación en
`docs/`. PCB/CAD siguen conceptuales; no son diseños para fabricar.
Leer `AGENTS.md` y `docs/README.md` antes de cambiar subsistemas. La rama de
reorganización admite commits; fusionar en `main` requiere una revisión posterior.
Ver [resumen de entrega](docs/archivo/2026-10/RESUMEN-ENTREGA.md)
y [prompt para retomar](docs/archivo/2026-10/PROMPT-PARA-MANANA.md).
