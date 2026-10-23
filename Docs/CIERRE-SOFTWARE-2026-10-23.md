# Cierre de etapa software — 23/10/2026

> Cierre histórico previo a la publicación Android. Actualmente hay APK 0.3.0
> con configuración de nube y ramas integradas. Consultar [PROBAR-HOY](PROBAR-HOY.md).
> El porcentaje y los bloqueos inferiores corresponden al momento de este cierre.

El usuario pidió cerrar esta etapa antes de armar el circuito. No se cargó firmware
ni se cambió el cableado. Trabajo en rama codex/colegio-mvp-20261023, desde 6e4eec6,
en .school-work/REAKT; checkout original preservado. Sin commit/push.

## Porcentaje estimado

**MVP actual: aproximadamente 60% completo.** Es una estimación de planificación
según entregables y evidencia, no una medición de horas ni una certificación.
El alcance es la cadena con un nodo, pulsador y LED en protoboard. No representa
el proyecto ampliado de cinco nodos, todos los modos, PCB y carcasa final.

| Área | Peso | Avance reconocido sobre el total |
|---|---:|---:|
| App y almacenamiento local | 25 | 20 |
| Firmware y protocolo | 20 | 17 |
| Supabase/Auth/persistencia | 20 | 16 |
| Hardware y montaje | 15 | 3 |
| Integración física y fiabilidad | 15 | 0 |
| Documentación operativa | 5 | 4 |
| Total estimado | 100 | 60 |

La mayor incertidumbre pendiente es la integración real. Tener código compilado
y pruebas de software no demuestra funcionamiento de radio, estímulo ni Android físico.

## Verificaciones ejecutadas en esta PC

- Supabase: cuenta de prueba registrada por el usuario y confirmada; consulta de
  metadata encontró tres sesiones Auth. No se accedió a contraseñas/tokens.
- `backend/remote-rls-smoke.sql`: aserciones remotas aprobadas con el UUID del
  usuario confirmado. Sesión idempotente, escritura/lectura de resultados/eventos,
  rechazo de rondas inválidas y cambio de dueño, DELETE bloqueado, identidad distinta
  sin lectura/actualización/upsert sobre datos ajenos, anónimo sin lectura.
  La segunda identidad es un subject SQL sintético, no un segundo login real.
  Transacción revertida; consulta posterior confirmó 0 sesiones, 0 resultados,
  0 eventos. No se dejaron métricas de prueba en producción.
- `node tools/probe-supabase-public.mjs`: Auth settings HTTP200; REST anónimo
  rechazado con HTTP401 en las tres tablas. No se imprimieron claves.
- Flutter3.47.4/Dart3.13.3 instalado: `pub get --enforce-lockfile` en la app
  original falló porque el SDK fija diez dependencias diferentes de Flutter3.29.3.
  No se modificó app/pubspec.lock. Se copió lib/test/pubspec a build/flutter347-app
  (ignorado), resolvieron allí las diez dependencias de SDK y se ejecutó:
  `analyze --no-pub`: No issues found; `test --no-pub`: 17 tests passed.
  Es validación con SDK más nuevo, no reproducción exacta del APK anterior.
- Arduino CLI1.1.1 / esp32:esp32:esp32 core3.3.4, dos jobs:
  nodo LED digital 888275 bytes flash / 44792 RAM;
  nodo salida deshabilitada 887975 / 44792;
  gateway 929487 / 48324. Gateway usó WebSockets2.7.2 y ArduinoJson7.4.3.
  Las tres compilaciones terminaron exit0. Destino genérico de banco, sin MAC
  del nodo ni pinout validados; no son evidencia de firmware cargado.
- `git diff --check`, sintaxis Node y parser PowerShell del nuevo script: aprobados.

## Cambios implementados

Salida del nodo encapsulada en Stimulus.h: admite LED digital con polaridad
configurable, WS2812B con cantidad configurable y salida deshabilitada. Mantiene
protocolo, debounce y reloj posterior a la escritura de salida. ENABLED y
HARDWARE_VALIDATED permanecen en0 por defecto. El LED digital no requiere NeoPixel.

Nuevos instrumentos: compilador Windows, formulario Auth local, comprobación
pública de API y prueba RLS remota transaccional. Configuración pública solo en
app/supabase-public.json ignorado por Git, sin claves privilegiadas.

## Qué sigue cuando esté el circuito

1. Seguir [MVP-PROTOBOARD.md](MVP-PROTOBOARD.md), verificar placa/pines/LED/resistencia.
2. Conectar el nodo, identificar su MAC real y completar configuración local de
   ambos roles. Gateway conocido: COM4, MAC30:c6:f7:92:d0:9c.
3. Respaldar flash existente y cargar cada rol con identidad y puerto comprobados.
4. Probar radio, pulsación, mantener/soltar, timeout, detener y recuperación.
5. Preparar Android SDK/JDK/NDK o recuperar APK compatible con configuración de nube;
   probar teléfono real, SQLite tras reinicio y sincronización desde app con Internet.
6. Segundo login real y aislamiento REST; diez sesiones físicas consecutivas.

Android SDK no fue localizado; no se generó APK nuevo con la configuración Supabase.
Las advertencias previas de funciones SECURITY DEFINER siguen documentadas y su
corrección requiere revisión/aprobación separada. No se deshabilitaron protecciones.
