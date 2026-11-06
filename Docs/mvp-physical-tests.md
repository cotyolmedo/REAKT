# Comprobación del montaje

Este procedimiento comprueba el sistema físico. Registrar resultados y evidencia
en la carpeta de campo externa. Una compilación o simulación no valida hardware.

1. Verificar placas, pinout, alimentación y configuración local. Sin configuración,
   el firmware debe imprimir bloqueo y MAC sin habilitar GPIO.
2. Configurar un gateway y un nodo con station MAC reales, canal 6 e ID único.
   Comprobar ACK bidireccional desde el panel de diagnóstico.
3. Probar una pulsación, mantener y liberar. Debe aparecer un único evento por
   accionamiento; comprobar rearme y antirrebote con pulsaciones rápidas y largas.
4. Con la salida LED verificada, probar encendido, apagado, vencimiento y detener.
   Sin LED, clasificar el ensayo como comunicaciones/pulsador.
5. Desconectar el nodo y reconectar la app. Comprobar reintentos, interrupción
   ante pérdida persistente y ausencia de eventos duplicados.
6. Cerrar y reabrir Android: SQLite debe conservar el historial. Un reinicio del
   gateway no debe convertir una sesión interrumpida en completada.
7. Volver a una red con Internet, iniciar sesión y sincronizar dos veces.
   Comprobar idempotencia y aislamiento con dos cuentas reales.
8. Añadir un segundo nodo con ID y MAC distintos y comprobar alternancia.
9. Ejecutar diez sesiones consecutivas de diez rondas, sin bloqueos ni duplicados.

Para WS2812B, verificar primero fuente, corriente, brillo, adaptación de nivel y
ausencia de brownout. Comparar tiempos con un instrumento de referencia antes de
atribuir precisión a las mediciones. El pulsador no mide fuerza.

Ver [puesta en marcha](PROBAR-HOY.md) y [montaje](MVP-PROTOBOARD.md).
