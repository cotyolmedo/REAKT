# Arquitectura REAKT — MVP actualizado 2026-10-23

Flutter Android ↔ WebSocket local ↔ gateway ESP32 WROOM-32 ↔ ESP-NOW ↔ uno o dos
nodos WROOM-32. Cada nodo incorpora pulsador NA y salida configurable: LED común
para el banco, WS2812B o salida deshabilitada. La meta
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
otra sesión. Reapertura del teléfono con historial conservado ya confirmada por
usuario; recuperación de sesión en curso y reinicios de radio requieren pruebas específicas.

Al volver Internet, Supabase Auth habilita sincronización de sesiones terminales,
resultados y eventos mediante IDs estables. Ningún fallo de nube borra el archivo
SQLite; los upserts parciales se repiten hasta completarse. Cuenta propietaria
estable y RLS implementada limitan el acceso por propietario. La sincronización
desde Android fue confirmada por usuario y consulta remota (11 sesiones, 11
resultados y 28 eventos). Aislamiento con dos cuentas reales sigue pendiente.
Las copias locales no están cifradas por la
app; se deshabilita backup Android. Ver backend/README.md para límites y aprobación.

Banco real probado: gateway COM4 y nodo COM19 por USB, pulsador NA en GPIO18 y
LED común con resistencia en GPIO23. WS2812B, alimentación recargable y ampliación
a cinco nodos siguen pendientes. Las métricas sin estímulo físico sirven solo
para diagnóstico; la calibración independiente de tiempos tampoco se ha realizado.
Ver [registro de pruebas](banco-2026-10-23.md) para evidencia y límites.
