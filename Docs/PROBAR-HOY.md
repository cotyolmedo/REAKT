# Probar REAKT — guía de puesta en marcha

Guía operativa para montar y usar REAKT. APK vigente: [0.3.1](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1).
El MVP admite uno o dos nodos. La configuración debe verificarse con las piezas reales.

## 1. Preparar la copia correcta y las herramientas

Usar un checkout de la rama integrada que contenga este documento y
`firmware/nodes/REAKT_Node/Stimulus.h`. Abrir los sketches de esa misma copia:

- [Gateway REAKT](../firmware/gateway/REAKT_Gateway/REAKT_Gateway.ino).
- [Nodo REAKT](../firmware/nodes/REAKT_Node/REAKT_Node.ino).

No combinar archivos sueltos de ramas diferentes. La biblioteca compartida está en
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

Desde la raíz del repositorio ejecutar `python3 -m http.server 8000` y abrir
[el panel de diagnóstico](http://localhost:8000/tools/web-diagnostics/).
Conectar PC al Wi-Fi
REAKT-MVP y panel a `ws://192.168.4.1:81`. Verificar snapshot, prueba manual,
pulsación única, mantener/soltar, vencimiento, detener y reconectar. Exportar JSON
y conservar logs. Sin LED funcional no registrar reacción visual.

## 4. Probar el APK actual

Instalar [REAKT 0.3.1 para Android 7+](https://github.com/cotyolmedo/REAKT/releases/download/v0.3.1/REAKT-0.3.1-android.apk).
Comprobar el checksum en [Releases](https://github.com/cotyolmedo/REAKT/releases/tag/v0.3.1).
Es debug; conservar historial JSON antes de cambiar una instalación previa.
No hace falta instalar Flutter para usar el APK. Si se recompila, usar
`app/.fvmrc` (Flutter 3.47.4), `app/pubspec.lock` y [app/README.md](../app/README.md),
como referencias de compilación.

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

## 6. Comprobar el montaje

Seguir el [procedimiento de pruebas](mvp-physical-tests.md). Primero un nodo estable,
luego un segundo si está disponible. Los resultados se registran en la carpeta de
campo externa; las pruebas de software y simuladores no sustituyen las físicas.
