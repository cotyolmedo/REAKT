# Montaje en protoboard

Montaje mínimo: un gateway, un nodo, pulsador NA y un LED.
No requiere carcasa, PCB ni batería para este ensayo. Su aprobación escolar final
sigue dependiendo de los requisitos y del docente.

## Antes de conectar

Identificar la placa del nodo, pinout y LED disponibles con el docente. GPIO18
(pulsador) y GPIO23 (LED) son propuestas, no conexiones físicamente verificadas.
Identificar las MAC station reales de ambas placas antes de configurarlas.

Para LED común de dos patas: GPIO verificado → resistencia serie → ánodo LED;
cátodo → GND del nodo. Calcular resistencia según 3,3 V, tensión directa del LED
y corriente admisible del GPIO; no conectar el LED directamente al pin.
Pulsador NA entre GPIO verificado y GND, con INPUT_PULLUP. En uno de cuatro patas
identificar los contactos antes de cablear. No aplicar 5 V a ninguna entrada.

## Configuración local del nodo

Copiar LocalConfig.example.h a LocalConfig.h junto al sketch. Para LED común:

```cpp
#define REAKT_LED_DIGITAL 1
#define REAKT_LED_ACTIVE_HIGH 1
#define REAKT_LED_ENABLED 0       // pasar a 1 tras verificar el circuito
#define REAKT_HARDWARE_VALIDATED 0 // pasar a 1 tras verificar placa y pulsador
```

Completar los GPIO reales y la MAC del gateway. ID del primer nodo: 1.
Para un único WS2812B usar DIGITAL=0 y COUNT=1, conservando la verificación de
alimentación/nivel lógico que corresponde a ese componente. Para LED común no
se necesita Adafruit NeoPixel; para WS2812B sí. La salida está deshabilitada por defecto.
El reloj empieza después de escribir la salida elegida; antirrebote y protocolo no cambian.

## Compilación y carga

Desde la raíz del worktree, PowerShell:

```powershell
./tools/compile-firmware-windows.ps1 -Target Node -Led Digital
./tools/compile-firmware-windows.ps1 -Target Gateway
```

Estos comandos solo compilan. La configuración LocalConfig prevalece si redefine
los macros del compilador; conservar coherencia entre archivo y variante elegida.
Las compilaciones de banco con hardware deshabilitado no son imágenes listas para
entrenar. Antes de cargar: identificar ambas placas/puertos, respaldar firmware
existente y completar las MAC y contraseña AP locales.

## Ensayo cuando esté armado

Seguir [el procedimiento de pruebas](mvp-physical-tests.md): pulsación única,
mantener/liberar, timeout, detener, pérdida de radio y reconexión. Empezar con panel
de diagnóstico; después Android y sincronización con Internet. Guardar JSON y logs
en la carpeta de campo externa. Meta: diez sesiones físicas consecutivas.
Sin LED funcional, clasificar como prueba de comunicaciones/pulsador.
