/*
  REAKT - PRUEBA PIEZO ESP32-C3

  Piezo:
    + -> GPIO 5
    - -> GND

  Resistencia:
    1 MΩ entre GPIO 5 y GND
*/

#define PIEZO_PIN 4

void setup() {
  Serial.begin(115200);  

  pinMode(PIEZO_PIN, INPUT);

 
}

void loop() {
   Serial.println();
   Serial.println("=== PRUEBA PIEZO ESP32-C3 ===");
   Serial.println("Golpea el piezo y observa los valores.");
   float valorPiezo = analogRead(PIEZO_PIN);
   Serial.println(valorPiezo);

  delay(100);
}

