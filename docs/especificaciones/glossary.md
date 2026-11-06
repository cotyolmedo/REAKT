# Glosario REAKT

**Gateway:** ESP32 central que coordina los nodos y se comunica con la app.

**Nodo:** uno de los cinco ESP32 periféricos de entrenamiento.

**ESP-NOW:** transporte inalámbrico previsto entre gateway y nodos.

**Pulsador NA:** contacto normalmente abierto; entrega una entrada digital al
cerrarse y no mide fuerza.

**Antirrebote:** validación temporal que evita contar varias transiciones
eléctricas o mecánicas como pulsaciones independientes.

**WS2812B:** LED RGB direccionable previsto como salida visual de los nodos.

**Modo:** actividad de entrenamiento que reutiliza la infraestructura común.

**Paquete:** unidad estructurada de datos; su formato v1 sigue `TBD`.

**Sesión:** ejecución configurada de un modo con uno o más nodos.

**Métrica:** valor derivado de eventos medibles y de una temporización validada.

**Documentación de campo:** registro escolar de avances, evidencia y trabajo
técnico real.

**ExecPlan:** plan vivo en `.agent/` para un cambio complejo.
