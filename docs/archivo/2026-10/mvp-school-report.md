# Informe técnico escolar — REAKT MVP

## Problema y objetivo

REAKT propone entrenamiento por estímulos luminosos y pulsaciones digitales.
Entrega objetivo: 6/11/2026. Un gateway coordina uno o dos módulos para validar el
MVP antes de ampliar a cinco. No mide fuerza ni impacto: el pulsador es digital;
confirmar con docentes el cumplimiento del requisito de sensor.

## Solución técnica

ESP32 WROOM-32/DevKitC en gateway y nodos. Radio ESP-NOW en canal fijo, con
paquetes binarios32bytes y confirmación de aplicación. El gateway distribuye
objetivos; cada nodo aplica antirrebote y mide reacción usando un único reloj
monotónico. Reintentos y deduplicación evitan contar un evento dos veces por una
pérdida de ACK. Código de control no bloqueante; WS2812B opcionales hasta validar
hardware y alimentación.

Flutter Android controla sesiones a través de WebSocket local, sin depender de
Internet. Snapshot completo recupera eventos tras reconectar mientras el gateway
mantenga la sesión en RAM. SQLite conserva historial en teléfono. Supabase Auth y
RLS propuestos permiten persistir sesiones, resultados y eventos por usuario;
fallos de Internet dejan trabajo pendiente para sincronización idempotente.

## Evidencia disponible

Firmware compilado para ESP32 con core2.0.17 y bibliotecas versionadas. Pruebas
nativas de contrato y simulación de diez sesiones con fallos de entrega. Once
pruebas PostgreSQL local de autorización/consistencia. Dos pruebas de simulador
WebSocket, panel Chromium y diecisiete pruebas Flutter, incluida UI/WebSocket/SQLite. No equivalen a radio real ni Flutter instalado en Android.

## Limitaciones y siguiente ensayo

Solo se dispone de placas y pulsador. LEDs, alimentación y adaptación de nivel
están pendientes; GPIO18/23 son propuestas. No se probó batería ni cargador, PCB
ni carcasa de fabricación. Análisis Flutter y diecisiete tests fueron aprobados tras instalar el SDK; el estado
del APK está en ESTADO-FINAL-MVP.md. Android físico sigue pendiente. Supabase remoto no fue inspeccionado: el usuario autorizó aplicar la
migración tras verificar compatibilidad, pero falta conector/acceso.

Primer ensayo físico: identificar placas, configurar MAC reales, validar pulsador
y ACK en una pareja. Después adquirir/verificar circuito LED, ejecutar prueba
manual y diez sesiones seguidas con registros. Validar luz y pulsador con una
referencia temporal independiente antes de presentar tiempos como métricas humanas.
Ver matriz detallada en mvp-physical-tests.md; registrar resultados reales,
problemas y correcciones, sin convertir estados IMPLEMENTADO en PROBADO por escritura.
