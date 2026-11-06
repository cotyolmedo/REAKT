# PCB del gateway ESP32

## Alcance
El gateway central usa un ESP32 y coordina cinco nodos ESP32 por ESP-NOW. El transporte con Flutter **no está definido**: analizar BLE, Wi-Fi o solución compatible, y su coexistencia con canal ESP-NOW. No introducir hardware que no esté justificado.

## Diseño recomendado
- PCB portadora propia para ESP32 DevKit, alimentación estable y conectores de servicio.
- Fuente por USB regulada y protegida como candidata; verificar puertos de la placa exacta.
- Indicadores opcionales de encendido/estado y botón de reset accesible.
- Testpoints de 3V3, GND, radio/estado cuando corresponda.
- No duplicar batería, TP4056, pulsador de impacto ni regulador 5 V LED de los nodos si no se requieren.
- Respetar zona de antena y acceso de programación.

## Puertas de decisión
1. ¿Gateway alimentado permanentemente por USB o autónomo?
2. ¿App ↔ gateway por BLE o Wi-Fi? ¿Canal y coexistencia?
3. ¿Necesita LED de estado o buzzer?
4. ¿Qué gabinete y conectores externos se usarán?

No generar esquema final hasta resolver estas decisiones. Las pruebas de ESP-NOW deben incluir cinco nodos y casos de pérdida de enlace.
