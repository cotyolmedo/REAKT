#include <esp_now.h>
#include <WiFi.h>
#include <esp_wifi.h> // Necesario para configurar canal y ahorro de energía

// ========================================================
// CONFIGURACIÓN DE PLACA
// ========================================================
// DESCOMENTAR SOLO UNA:
#define PLACA_ESP32
//#define PLACA_ESP32C3

// ========================================================
// SELECCIÓN DE PRUEBA
// ========================================================
// DESCOMENTAR SOLO UNA PRUEBA:
//#define PRUEBA_CONEXION
#define PRUEBA_VARIABLE_C3_A_ESP32
//#define PRUEBA_PULSADOR
//#define PRUEBA_PIEZOELECTRICO
//#define PRUEBA_VARIABLE_ESP32_A_C3
//#define PRUEBA_LED

// ========================================================
// CONFIGURACIÓN DE PINES
// ========================================================
#ifdef PLACA_ESP32C3
  int PIN_PULSADOR = 4;
  int PIN_PIEZOELECTRICO = 5;
  int PIN_LED = 8;
#endif

#ifdef PLACA_ESP32
  const int PIN_LED = 2;
#endif

// ========================================================
// MAC DE LAS PLACAS
// ========================================================
uint8_t MAC_ESP32[]   = { 0x2C, 0xBC, 0xBB, 0x92, 0xDA, 0x04 };
uint8_t MAC_ESP32C3[] = { 0x44, 0xBD, 0x8D, 0x24, 0x57, 0x18 };

#define CANAL_WIFI 1 // Canal fijo garantizado para ambas placas

// ========================================================
// VARIABLES GENERALES
// ========================================================
typedef struct {
  char tipo[20];
  int valor;
} Datos;

Datos datosEnviar;
Datos datosRecibidos;

unsigned long tiempoAnterior = 0;
bool estadoPulsadorAnterior = HIGH;
int valorPiezo = 0;

// ========================================================
// FUNCIÓN DE ENVÍO
// ========================================================
void enviarDatos(const char* tipo, int valor) {
  strcpy(datosEnviar.tipo, tipo);
  datosEnviar.valor = valor;

  uint8_t* destino;

  #ifdef PLACA_ESP32
    destino = MAC_ESP32C3;
  #endif

  #ifdef PLACA_ESP32C3
    destino = MAC_ESP32;
  #endif

  esp_err_t resultado = esp_now_send(
    destino,
    (uint8_t*)&datosEnviar,
    sizeof(datosEnviar)
  );

  if (resultado != ESP_OK) {
    Serial.println("Error al iniciar el envío ESP-NOW.");
  }
}

// ========================================================
// RETORNO DE ENVÍO (CORREGIDO)
// ========================================================
void cuandoSeEnvio(const wifi_tx_info_t *info, esp_now_send_status_t estado) {
  if (estado == ESP_NOW_SEND_SUCCESS) {
    Serial.println("ESP-NOW: envío confirmado por el receptor.");
  } else {
    Serial.println("ESP-NOW: error en el envío.");
  }
}

// ========================================================
// RETORNO DE RECEPCIÓN (CORREGIDO PARA ESP32 CORE v3)
// ========================================================
void cuandoSeRecibio(const esp_now_recv_info_t *info, const uint8_t *datos, int longitud) {
  if (longitud == sizeof(Datos)) {
    memcpy(&datosRecibidos, datos, sizeof(datosRecibidos));

    Serial.println();
    Serial.println("========== DATO RECIBIDO ==========");
    Serial.print("Tipo: ");
    Serial.println(datosRecibidos.tipo);
    Serial.print("Valor: ");
    Serial.println(datosRecibidos.valor);
    Serial.println("===================================");
    Serial.println();

    #ifdef PRUEBA_LED
      #ifdef PLACA_ESP32C3
        if (strcmp(datosRecibidos.tipo, "LED") == 0) {
          if (datosRecibidos.valor == 1) {
            digitalWrite(PIN_LED, HIGH);
            Serial.println("Orden recibida: ENCENDER LED");
          } else {
            digitalWrite(PIN_LED, LOW);
            Serial.println("Orden recibida: APAGAR LED");
          }
        }
      #endif
    #endif
  }
}

// ========================================================
// CONFIGURACIÓN ESP-NOW
// ========================================================
void iniciarESPNow() {
  WiFi.mode(WIFI_STA);

  // 1. Fijar Canal WiFi e Inhabilitar Sleep del Módem
  esp_wifi_set_channel(CANAL_WIFI, WIFI_SECOND_CHAN_NONE);
  esp_wifi_set_ps(WIFI_PS_NONE);
  WiFi.disconnect();

  Serial.println();
  Serial.print("MAC de esta placa: ");
  Serial.println(WiFi.macAddress());
  Serial.print("Canal WiFi fijado en: ");
  Serial.println(CANAL_WIFI);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error al iniciar ESP-NOW.");
    while (true);
  }

  esp_now_register_send_cb(cuandoSeEnvio);
  esp_now_register_recv_cb(cuandoSeRecibio);

  // Configuración del Peer
  esp_now_peer_info_t peerInfo = {};

  #ifdef PLACA_ESP32
    memcpy(peerInfo.peer_addr, MAC_ESP32C3, 6);
  #endif

  #ifdef PLACA_ESP32C3
    memcpy(peerInfo.peer_addr, MAC_ESP32, 6);
  #endif

  peerInfo.channel = CANAL_WIFI;
  peerInfo.encrypt = false;

  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Error al agregar la otra placa.");
  } else {
    Serial.println("Otra placa agregada correctamente.");
  }
}

// ========================================================
// SETUP
// ========================================================
void setup() {
  Serial.begin(115200);

  // Espera breve para la inicialización del USB nativo en C3
  unsigned long tInicio = millis();
  while (!Serial && (millis() - tInicio < 2000));

  delay(500);

  Serial.println();
  Serial.println("===================================");
  Serial.println("       PRUEBAS ESP-NOW");
  Serial.println("===================================");

  #ifdef PLACA_ESP32C3
    pinMode(PIN_PULSADOR, INPUT_PULLUP);
    pinMode(PIN_PIEZOELECTRICO, INPUT);
    pinMode(PIN_LED, OUTPUT);
    digitalWrite(PIN_LED, LOW);
  #endif

  #ifdef PLACA_ESP32
    pinMode(PIN_LED, OUTPUT);
    digitalWrite(PIN_LED, LOW);
  #endif

  iniciarESPNow();
  Serial.println("\nSistema listo.\n");
}

// ========================================================
// LOOP
// ========================================================
void loop() {

  #ifdef PRUEBA_CONEXION
    #ifdef PLACA_ESP32C3
      if (millis() - tiempoAnterior >= 2000) {
        tiempoAnterior = millis();
        enviarDatos("HELLO", 1);
        Serial.println("Enviando prueba de conexión...");
      }
    #endif
  #endif

  #ifdef PRUEBA_VARIABLE_C3_A_ESP32
    #ifdef PLACA_ESP32C3
      if (millis() - tiempoAnterior >= 1000) {
        tiempoAnterior = millis();
        int variable = 123;
        enviarDatos("VARIABLE", variable);
        Serial.print("Variable enviada: ");
        Serial.println(variable);
      }
    #endif
  #endif

  #ifdef PRUEBA_PULSADOR
    #ifdef PLACA_ESP32C3
      bool estadoPulsador = digitalRead(PIN_PULSADOR);
      if (estadoPulsador != estadoPulsadorAnterior) {
        estadoPulsadorAnterior = estadoPulsador;
        enviarDatos("PULSADOR", estadoPulsador);
        Serial.print("Estado pulsador enviado: ");
        Serial.println(estadoPulsador);
      }
    #endif
  #endif

  #ifdef PRUEBA_PIEZOELECTRICO
    #ifdef PLACA_ESP32C3
      if (millis() - tiempoAnterior >= 200) {
        tiempoAnterior = millis();
        valorPiezo = analogRead(PIN_PIEZOELECTRICO);
        enviarDatos("PIEZO", valorPiezo);
        Serial.print("Valor piezo enviado: ");
        Serial.println(valorPiezo);
      }
    #endif
  #endif

  #ifdef PRUEBA_VARIABLE_ESP32_A_C3
    #ifdef PLACA_ESP32
      if (millis() - tiempoAnterior >= 1000) {
        tiempoAnterior = millis();
        static int contador = 0;
        contador++;
        enviarDatos("VARIABLE", contador);
        Serial.print("Variable enviada: ");
        Serial.println(contador);
      }
    #endif
  #endif

  #ifdef PRUEBA_LED
    #ifdef PLACA_ESP32
      if (millis() - tiempoAnterior >= 2000) {
        tiempoAnterior = millis();
        static bool estadoLED = false;
        estadoLED = !estadoLED;
        enviarDatos("LED", estadoLED);
        Serial.print("Orden LED enviada: ");
        Serial.println(estadoLED ? "ENCENDER" : "APAGAR");
      }
    #endif
  #endif

  // Pequeña pausa para no saturar la CPU y permitir tareas de fondo del WiFi
  delay(10);
}