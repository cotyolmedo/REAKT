# Arquitectura REAKT — MVP 2026-10-22

Flutter Android ↔ WebSocket local ↔ gateway ESP32 WROOM-32 ↔ ESP-NOW ↔ uno o dos
nodos WROOM-32. Cada nodo incorpora pulsador NA y prevé cinco WS2812B. La meta
anterior de cinco nodos queda como ampliación; el MVP admite dos explícitamente.

Gateway crea SoftAP canal 6, coordina rondas aleatorias, acepta prueba manual,
confirma eventos y calcula métricas. El nodo controla debounce, estímulo y reloj
monotónico `esp_timer_get_time()`. No se comparan relojes entre dispositivos.
Callbacks radio solo copian a cola protegida; procesamiento y LEDs se hacen en
loop. No hay `delay()` en el firmware productivo de REAKT.

Flutter consume snapshots completos, valida contrato y guarda en SQLite. Intenta
reconectar con espera creciente 1..16 s y detecta ausencia de snapshots tras 6 s.
La lógica de entrenamiento sigue funcionando en el gateway aunque cierre la app.
Solo se conserva la última sesión en RAM del gateway: recuperar en el teléfono
antes de reiniciar o comenzar otra. La app conserva el resultado antes de iniciar
otra sesión; los reinicios de teléfono/radio requieren prueba física.

Al volver Internet, Supabase Auth habilita sincronización de sesiones terminales,
resultados y eventos mediante IDs estables. Ningún fallo de nube borra el archivo
SQLite; los upserts parciales se repiten hasta completarse. Cuenta propietaria
estable y RLS propuesta aíslan datos. Las copias locales no están cifradas por la
app; se deshabilita backup Android. Ver backend/README.md para límites y aprobación.

Disponibilidad real: usuario solo tiene placas y pulsador. Los WS2812B y su
alimentación faltan; su uso queda deshabilitado. Las métricas sin estímulo físico
sirven para diagnóstico, no para evaluación de reacción humana.
