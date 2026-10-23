# Mañana en el colegio — viernes 23 de octubre de 2026

> Guía histórica de preparación. Para el estado integrado y el orden vigente usar
> [PROBAR-HOY.md](PROBAR-HOY.md): APK 0.3.0 publicado, Supabase aplicado y nodo con
> salida digital opcional. Las secciones antiguas de SDK/migración no deben repetirse.

## Objetivo alcanzable con lo que tienen

Con **dos ESP32 y un pulsador** pueden comprobar programación, MAC reales,
ESP-NOW bidireccional, ACK, antirrebote y llegada de eventos al cliente. Si hay
una tercera placa, el segundo nodo queda para después. No tienen WS2812B ni su
alimentación: no conectar componentes sustitutos ni presentar tiempos como
reacción visual. Sin cables de datos/conexión adecuados, limitarse a software y
programación; no improvisar contactos eléctricos.

Primer documento a abrir: `Docs/ESTADO-FINAL-MVP.md`. Describe los resultados de
esta entrega. Este documento es el procedimiento; los casilleros vacíos no son
pruebas realizadas.

## Qué llevar y descargar antes

- El **ZIP de la entrega actual**, extraído en una carpeta con permisos de escritura.
  Para obtener el código desde GitHub, actualizar main y verificar el commit con
  mensaje “Cambios mayores, progreso considerable”. El ZIP es otra copia de la entrega.
  Conservar copia del ZIP en otro medio. Abrir la carpeta REAKT en VS Code.
- Dos placas identificadas, cables USB **de datos**, pulsador y conexiones adecuadas.
  Revisar con docente el modelo real y pinout. Teléfono Android/cable de datos si
  van a probar la app. No asumir que la computadora tiene Wi-Fi: comprobarlo.
- Arduino IDE2, core ESP32 de Espressif2.0.17, Adafruit NeoPixel1.12.3,
  WebSockets2.6.1 (Links2004), ArduinoJson6.21.5. Instalar con Internet.
- Python3 para el panel del navegador. Flutter3.29.3/Dart3.7.2, Android Studio/SDK
  y JDK17 **completo, con javac**, para desarrollar Android. NDK27.0.12077973
  está fijado en el proyecto; el primer build también puede instalar CMake3.22.1. Si no hay permisos para drivers/software,
  pedir asistencia al docente o administrador; no intentar evadir restricciones.
- Credenciales de Wi-Fi de banco guardadas localmente. Para nube: acceso propio
  al proyecto Supabase reakt y al usuario de pruebas, nunca una clave service_role
  en la app. No llevar credenciales dentro del ZIP ni en un repositorio público.

**Prioridad práctica:** configurar herramientas con Internet primero; recién
después cambiar la red Wi-Fi al AP de la gateway, que no ofrece Internet.

## 1. Programar e identificar placas

1. Abrir `firmware/gateway/REAKT_Gateway/REAKT_Gateway.ino` en Arduino IDE.
2. Copiar `firmware/libraries/ReaktCore` al directorio `libraries/ReaktCore` del
   sketchbook Arduino. Instalar las bibliotecas versionadas arriba.
3. Seleccionar la placa real (destino compilado de referencia: ESP32 Dev Module
   para WROOM-32) y su puerto. Si no aparece puerto: verificar cable de datos,
   driver oficial que corresponda al conversor USB de la placa y permisos.
4. Compilar/cargar configuración inicial y abrir monitor a **115200 baud**. Anotar
   la **station MAC** del gateway, no la del SoftAP. Cerrar monitor para otra carga.
5. Hacer lo mismo con `firmware/nodes/REAKT_Node/REAKT_Node.ino` en la segunda
   placa. Etiquetar físicamente gateway/nodo1 para no intercambiar roles.
6. Crear `LocalConfig.h` junto a cada sketch copiando su ejemplo. Gateway: contraseña
   propia >=12 caracteres y MAC real de nodo1. Nodo1: MAC station real del gateway,
   ID1. Dejar nodo2 sin configurar si no está disponible.
7. GPIO18 significa la señal GPIO, no la posición física18 del conector.
   El docente debe verificar GPIO18/pulsador y el modelo real. Solo después poner
   `REAKT_HARDWARE_VALIDATED 1`. Mantener **REAKT_LED_ENABLED 0**: hoy no tienen LEDs.
   Pulsador NA entre GPIO verificado y GND, con pull-up interno; nunca aplicar 5V al GPIO.
   En un pulsador de cuatro patas, identificar contactos correctos, no adivinarlos.
8. Recompilar y cargar ambos roles. Guardar logs de inicio. Ambos usan canal6.
   Si falla radio/peer, revisar las station MAC y configuración; no inventarlas.

## 2. Probar de inmediato con navegador, sin instalar Android

Requiere computadora con Wi-Fi conectada al AP y Python3. Este es un instrumento
de diagnóstico, no una sustitución de Flutter ni una integración Supabase.

Desde la raíz REAKT en PowerShell:

```powershell
py -m http.server 8000 --bind 127.0.0.1 --directory tools/web-diagnostics
```

Si el comando `py` no existe pero Python está instalado, usar `python`. Abrir en
el navegador la dirección local que muestra el servidor, puerto8000. Mantener
la terminal abierta. El servidor expone solo el panel, no archivos de configuración.

1. Conectar la computadora al Wi-Fi **REAKT-MVP** con la contraseña local.
2. En el panel dejar gateway `ws://192.168.4.1:81` y pulsar **Conectar**.
3. Verificar snapshot idle. Pulsar **Prueba manual · 5 s** y accionar el pulsador.
   Esperado: un hit, un evento e ID estable, sin duplicarse al mantenerlo presionado.
   El instante visual del navegador no define la medición de reacción: hoy no hay LEDs.
4. Repetir sin pulsar: esperado miss al vencer. Pulsar/mantener/liberar y repetir
   para verificar antirrebote y rearme. Confirmar por monitor serie del nodo.
5. Probar diez rondas como ensayo de comunicaciones. Sin LEDs, documentarlo como
   banco sin estímulo físico, no entrenamiento humano validado.
6. Desconectar/reconectar cliente; recuperar snapshot mientras no se reinicie la
   gateway ni se comience otra sesión. Pulsar **Exportar JSON** y guardar el archivo
   con fecha/placas usadas. Capturar también logs y errores, no solo aciertos.
7. Desconectar alimentación del nodo durante una sesión: esperado interrupción por
   comunicación, sin inventar un resultado del usuario. Después reiniciar sesión.

Si el navegador informa bloqueo de red privada/mixed content, usar el panel HTTP
local, no un sitio HTTPS público. Revisar permisos del navegador para ese origen
local con el docente. Si la PC no tiene Wi-Fi, usar la app Android o preparar las
herramientas y el simulador; no afirmar comunicación con la gateway sin conectarla.

## 3. App Android

Si esta entrega incluye un APK probado en compilación, consultar su ubicación en
ESTADO-FINAL-MVP.md. Compilar un APK no significa que fue probado en ese teléfono.
Para instalarlo, autorizar depuración/instalación mediante el procedimiento del
colegio. No borrar datos de una instalación anterior que tenga sesiones sin exportar.

Para desarrollar desde PowerShell, dentro de `app/`:

```powershell
flutter --version
flutter doctor -v
flutter pub get --enforce-lockfile
flutter analyze
flutter test
flutter devices
flutter run
```

Resolver licencias/SDK desde Android Studio y `flutter doctor --android-licenses`
según las indicaciones oficiales. El primer build necesita Internet. Luego:

1. Conectar teléfono a REAKT-MVP; mantener esa red aunque no tenga Internet.
2. Abrir app, conectar gateway, verificar estado. Probar manual, mantener pulsación,
   timeout, detener sesión y reconectar. Un fallo de disco no debe impedir detener.
3. Cerrar/reabrir y revisar **historial guardado**. Una sesión en curso tras reiniciar
   gateway no se convierte automáticamente en completada.
4. Usar **Copiar historial JSON** y pegarlo en un archivo guardado antes de cambiar
   de instalación. Es exportación, no un restaurador automático. APKs debug de distintas
   computadoras pueden tener firmas diferentes: si Android rechaza la actualización,
   detenerse y revisar con el responsable; no borrar datos como primer intento.
5. Volver a Internet al terminar para Auth y sincronización. La nube no se necesita
   para realizar las pruebas locales.

No ejecutar `flutter create --overwrite` sobre este proyecto ni regenerar pubspec.
Conservar el lock. Si el build falla, guardar la salida y corregir el error concreto;
no desactivar TLS, checksums ni RLS para conseguir un resultado aparente.

## 4. Supabase, cuando haya acceso

Proyecto indicado: `https://hvaoezcsgqepcttaznof.supabase.co`.
La autorización existente permite aplicar la migración preparada **tras inspección
sin conflictos**. No se recibió acceso administrativo en esta sesión ni se aplicó.

1. Abrir el proyecto correcto en el dashboard. Ejecutar primero
   `backend/inspect-readonly.sql` en SQL Editor y revisar metadata/RLS/tablas.
2. Si los nombres propuestos ya existen o hay incompatibilidades, parar solamente
   la migración y revisar la adaptación; no borrar tablas ni desactivar RLS.
3. Si la inspección confirma compatibilidad, el responsable con acceso puede aplicar
   `backend/migrations/20261022_001_reakt_mvp.sql`, ya autorizado condicionalmente.
4. Crear/invitar usuario de pruebas con el flujo Auth existente y completar la
   confirmación de correo cuando corresponda. No usar el password administrativo
   del proyecto como contraseña de la app. No guardar contraseñas en Markdown.
5. Copiar `app/supabase-public.example.json` como `supabase-public.json`. La URL ya
   está; completar solo clave pública anon/publishable de cliente, jamás service_role.
6. Desde app: `flutter run --dart-define-from-file=supabase-public.json`.
7. Iniciar sesión con Internet, entrenar sin Internet, volver a una red con Internet
   y sincronizar. Repetir: no debe aumentar cantidad de sesiones/eventos duplicados.
8. Verificar que otro usuario no vea ni cambie esos registros. Si falla, conservar
   SQLite y corregir autorización; no saltarse las políticas.

## 5. Sin placas conectadas o mientras instalan software

Se puede ensayar el flujo del panel contra un simulador, claramente identificado:

```powershell
py -m pip install websockets==15.0.1
py tools/mock_gateway.py
```

Abrir otro terminal para el servidor del panel. En el panel usar el endpoint local
puerto8765 que indica el simulador. Sus reacciones de250ms son datos sintéticos.
El simulador no necesita pulsador, no prueba ESP-NOW y no reemplaza evidencia física.

## Orden recomendado de trabajo

1. Herramientas y cables; conservar copia de la entrega.
2. Dos placas: MAC/configuración/cargas.
3. Gateway↔nodo↔pulsador con panel, guardar JSON/logs.
4. App Android con el mismo enlace y persistencia local.
5. Supabase y sincronización si hay acceso y esquema compatible.
6. Segundo nodo solo después de estabilizar el primero.

Usar `Docs/registro-pruebas-colegio.md` para registrar lo que realmente sucedió.
Los LEDs, su fuente y validación eléctrica siguen pendientes para el estímulo visual.
