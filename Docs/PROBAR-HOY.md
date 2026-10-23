# Probar REAKT — estado actual 23/10/2026

Esta es la entrada operativa actual. Las entregas del 22/10, guías anteriores y
bitácoras conservan estados históricos. No repetir migraciones ni compilar un APK
antiguo siguiendo un bloqueo ya resuelto.

## Qué está listo y qué falta

- Flutter 0.3.0: Inicio, Entrenar, Historial, Progreso y Perfil; WebSocket, SQLite,
  exportación y sincronización autenticada. Análisis y 21 pruebas aprobados en la
  publicación; [APK y evidencia](android-release-2026-10-23.md).
- Gateway y nodo MVP implementados y compilados, sin validación física completa.
  Un gateway y uno o dos nodos; cinco nodos y otros modos son ampliaciones.
- Nodo con pulsador NA y salida deshabilitada, LED común o WS2812B. Modelo de placa,
  GPIO, LED, resistencia y alimentación deben verificarse con piezas reales.
- Supabase: esquema aplicado, Auth y RLS comprobados. Falta probar login y
  sincronización desde el teléfono, y aislamiento con dos cuentas reales.
- Puesta en marcha posterior: gatewayCOM4 y nodoCOM19 cargados y verificados;
  primera sesión manual con LED/pulsador y acierto en Android comprobada por
  usuario y contadores serie. [Registro del banco](banco-2026-10-23.md).
  Mantener sin duplicados, timeout5s, stop e historial tras reapertura confirmados;
  diez sesiones completas y pruebas extendidas pendientes. No se afirma calibración
  independiente de tiempos de reacción.

## 1. Preparar la copia correcta y las herramientas

Usar un checkout de la rama integrada que contenga este documento y
`firmware/nodes/REAKT_Node/Stimulus.h`. Abrir los sketches de esa misma copia:

- [Gateway REAKT](../firmware/gateway/REAKT_Gateway/REAKT_Gateway.ino).
- [Nodo REAKT](../firmware/nodes/REAKT_Node/REAKT_Node.ino).

La carpeta original de la PC tenía otro proyecto (PILLDROP) en la ruta del
gateway. Se conserva fuera del firmware operativo como respaldo local; no cargarlo.
No combinar archivos sueltos de ramas diferentes. ReaktCore compartido está en
`firmware/libraries/ReaktCore`.

Instalar herramientas con Internet antes de conectarse al Wi-Fi del gateway.
[Instalación](mvp-installation.md) explica Arduino, bibliotecas y MAC.
Referencia original: core ESP32 2.0.17; también hay evidencia de compilación del
banco con core 3.3.4, WebSockets 2.7.2 y ArduinoJson 7.4.3. Seleccionar placa y
puerto reales; no cambiar herramientas al azar si un build falla.

## 2. Montar y configurar primero un nodo

Seguir [MVP-PROTOBOARD.md](MVP-PROTOBOARD.md). Confirmar pinout y conexiones con
el docente. GPIO18/23 son propuestas, no posiciones físicas ni pines validados.
Pulsador NA a GND con INPUT_PULLUP. LED común requiere resistencia calculada;
WS2812B requiere alimentación y adaptación verificadas. Se puede empezar sin LED,
clasificando el ensayo como comunicaciones/pulsador.

Identificar station MAC reales con monitor serie a 115200. Copiar los
`LocalConfig.example.h` de ambos roles como `LocalConfig.h` (ignorados por Git).
Gateway: contraseña local de al menos 12 caracteres y MAC del nodo. Nodo: MAC
station del gateway, ID 1 y GPIO reales. Habilitar HARDWARE_VALIDATED solo tras
verificar circuito; LED_ENABLED permanece 0 hasta verificar la salida.

Respaldar flash existente, comprobar roles/puertos, compilar y cargar ambos.
`tools/compile-firmware-windows.ps1` solo compila: no programa placas.
No hace falta Supabase en el ESP32. Ambos roles usan canal 6.

## 3. Probar radio y pulsador

Usar el panel de diagnóstico explicado en la
[guía de colegio, sección 2](GUIA-COLEGIO-2026-10-23.md). Conectar PC al Wi-Fi
REAKT-MVP y panel a `ws://192.168.4.1:81`. Verificar snapshot, prueba manual,
pulsación única, mantener/soltar, vencimiento, detener y reconectar. Exportar JSON
y conservar logs. Sin LED funcional no registrar reacción visual.

## 4. Probar el APK actual

Instalar [REAKT 0.3.0 para Android 7+](https://github.com/cotyolmedo/REAKT/releases/download/v0.3.0-demo.4.1/REAKT-0.3.0-android.apk).
Es debug; conservar historial JSON antes de cambiar una instalación previa.
No hace falta instalar Flutter para usar el APK. Si se recompila, usar
`app/.fvmrc` (Flutter 3.47.4), `app/pubspec.lock` y [app/README.md](../app/README.md),
que prevalecen sobre las versiones Android/Flutter de guías históricas.

Conectar teléfono a REAKT-MVP, mantener esa red aunque no tenga Internet y abrir
la app. Esperar snapshot válido antes de enviar órdenes. Probar manual, rondas,
detener, reconexión e historial después de cerrar/reabrir. El gateway retiene solo
la última sesión en RAM: no cortar su alimentación antes de recuperarla.

## 5. Probar persistencia remota

Volver a una red con Internet, iniciar sesión desde Perfil y sincronizar. El APK
publicado ya contiene URL y clave pública del proyecto; no requiere introducir
claves ni volver a aplicar la migración. Repetir sincronización y comprobar que
no duplica sesiones/eventos. Usar una segunda cuenta real para verificar aislamiento.
Conservar SQLite e historial ante un error; no borrar datos ni desactivar RLS.

## 6. Registrar lo que realmente se probó

Seguir la [matriz física](mvp-physical-tests.md) y completar la
[planilla de banco](registro-pruebas-colegio.md). Primero un nodo estable, luego
un segundo si está disponible. La meta de diez sesiones físicas sigue pendiente;
las pruebas de software y simuladores no la sustituyen.
