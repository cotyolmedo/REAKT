# Matriz de pruebas físicas — pendiente de hardware

Estado integrado: APK 0.3.0 disponible y esquema/API/RLS remotos comprobados.
Primer banco físico con un nodo ejecutado: carga/arranque, LED común, pulsación,
mantener, timeout, stop e historial verificados según [registro](banco-2026-10-23.md).
Las demás verificaciones de esta matriz siguen requiriendo ejecución específica.
Procedimiento actual en [PROBAR-HOY](PROBAR-HOY.md); sin LEDs puede probarse radio
y pulsador, y un LED común verificado sirve para el ensayo de banco simplificado.

Registrar fecha, firmware/commit, placa, core, MAC reales (solo registro local),
pinout verificado, alimentación, procedimiento, esperado, real y evidencia. No
marcar PROBADO por compilar. Meta: diez sesiones consecutivas sin fallos críticos.

| Caso | Requisitos | Resultado esperado | Estado |
|---|---|---|---|
| Encendido seguro | Placas USB | Config incompleta imprime bloqueo y MAC, sin GPIO activo | PENDIENTE DE HARDWARE |
| Radio un nodo | Gateway+nodo configurados | ACK bidireccional; canal6, station MAC correctas | APROBADO ensayo básico app/LED/pulsación; fiabilidad extendida pendiente |
| Pulsador NA | Pinout18 confirmado | Un evento por pulsación, nada mantenido al arranque | Pulsación y mantener confirmados; arranque mantenido pendiente |
| Rebote | Pulsaciones rápidas/largas | Sin duplicados, rearme tras liberación20ms | PENDIENTE DE HARDWARE |
| Sin LEDs | Placas+pulsador actuales | Eventos y diagnósticos; ninguna conclusión de reacción visual | PENDIENTE DE HARDWARE |
| LEDs x5 | LEDs+fuente+adaptación no disponibles | Encendido/apagado de cinco, brillo limitado, sin brownout | BLOQUEADO: faltan componentes |
| Reflejos | LEDs y circuito verificados | Objetivos aleatorios, hit antes de límite, miss al vencer | BLOQUEADO: faltan componentes |
| Medición | Instrumento de referencia | Comparar luz/flanco físico y reloj; caracterizar debounce20ms | BLOQUEADO: sin estímulo físico/instrumentación |
| Pérdida radio | Desconectar/reubicar nodo | Reintentos y ACK, sin doble conteo; pérdida persistente interrumpe | PENDIENTE DE HARDWARE |
| Reconectar app | App compilada, AP | Sesión continúa en gateway, snapshot recupera eventos | PENDIENTE DE HARDWARE: Android físico |
| Reiniciar gateway | App y gateway | No inventar continuidad; sesión anterior queda local no completada | PENDIENTE DE HARDWARE: Android físico |
| SQLite | App instalada | Cerrar/reabrir conserva historial; no borrar datos | CONFIRMADO POR USUARIO en Android |
| Sincronización | Teléfono con Internet y cuentas reales | Repetir upsert sin duplicados, RLS entre dos usuarios | PENDIENTE: Android y dos logins reales |
| Segundo nodo | Tercera placa disponible | IDs/MAC distintos, objetivos alternan aleatoriamente | PENDIENTE DE HARDWARE |
| Diez sesiones físicas | Circuito completo | Diez x diez rondas, sin bloqueo ni duplicación; logs guardados | PENDIENTE: circuito e integración física |

La simulación de diez sesiones C++ prueba componentes de protocolo, no satisface
la meta de diez sesiones físicas. Ensayar energización LEDs antes de sesiones de
personas. El pulsador no mide fuerza; confirmar requisito escolar de sensor.
