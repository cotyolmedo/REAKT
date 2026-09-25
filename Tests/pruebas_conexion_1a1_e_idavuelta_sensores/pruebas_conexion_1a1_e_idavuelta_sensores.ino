#include <esp_now.h>
#include <WiFi.h>

//CONFIGURACIÓN DE PLACA

// DESCOMENTAR SOLO UNA:

//#define PLACA_ESP32
#define PLACA_ESP32C3


//                    SELECCIÓN DE PRUEBA

// DESCOMENTAR SOLO UNA PRUEBA:

#define PRUEBA_CONEXION
// #define PRUEBA_VARIABLE_C3_A_ESP32
// #define PRUEBA_PULSADOR
// #define PRUEBA_PIEZOELECTRICO
// #define PRUEBA_VARIABLE_ESP32_A_C3
// #define PRUEBA_LED


//                    CONFIGURACIÓN DE PINES


// Pines de la ESP32-C3
#ifdef PLACA_ESP32C3
 int PIN_PULSADOR = 4;
 int PIN_PIEZOELECTRICO = 5;
 int PIN_LED = 8;
#endif
// Pines de la ESP32
#ifdef PLACA_ESP32
 const int PIN_LED = 2;
#endif


//                    MAC DE LAS PLACAS

// IMPORTANTE: Reemplazar por las reales

// MAC de la ESP32
uint8_t MAC_ESP32[] = {
  0x2C, 0xBC, 0xBB, 0x92, 0xDA, 0x04
};

// MAC de la ESP32-C3
uint8_t MAC_ESP32C3[] = {
  0x44, 0xBD, 0x8D, 0x24, 0x57, 0x18
};


//                    VARIABLES GENERALES


typedef struct {
  char tipo[20];
  int valor;
} Datos;

Datos datosEnviar;
Datos datosRecibidos;

unsigned long tiempoAnterior = 0;

bool estadoPulsadorAnterior = HIGH;

int valorPiezo = 0;

//                    FUNCIÓN DE ENVÍO

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

  if (resultado == ESP_OK) {
    Serial.println("Datos enviados correctamente.");
  }
  else {
    Serial.println("Error al enviar los datos.");
  }
}


//                    RETORNO DE ENVÍO


void cuandoSeEnvio(const wifi_tx_info_t *info, esp_now_send_status_t estado) {

  if (estado == ESP_NOW_SEND_SUCCESS) {
    Serial.println("ESP-NOW: envío exitoso.");
  }
  else {
    Serial.println("ESP-NOW: error en el envío.");
  }
}


//                    ROTORNO DE RECEPCIÓN


void cuandoSeRecibio(
  const esp_now_recv_info_t *info,
  const uint8_t *datos,
  int longitud
) {

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


    // PRUEBA: ENCENDER LED DESDE ESP32

    #ifdef PRUEBA_LED

      #ifdef PLACA_ESP32C3

        if (strcmp(datosRecibidos.tipo, "LED") == 0) {

          if (datosRecibidos.valor == 1) {

            digitalWrite(PIN_LED, HIGH);

            Serial.println("Orden recibida: ENCENDER LED");
          }

          else {

            digitalWrite(PIN_LED, LOW);

            Serial.println("Orden recibida: APAGAR LED");
          }
        }

      #endif

    #endif
  }
}

//                    CONFIGURACIÓN ESP-NOW


void iniciarESPNow() {

  WiFi.mode(WIFI_STA);

  Serial.println();
  Serial.print("MAC de esta placa: ");
  Serial.println(WiFi.macAddress());


  if (esp_now_init() != ESP_OK) {

    Serial.println("Error al iniciar ESP-NOW.");

    while (true) {
     
    }
  }


  esp_now_register_send_cb(cuandoSeEnvio);

  esp_now_register_recv_cb(cuandoSeRecibio);


  // --------------------------------------------------------
  // Agregar la otra placa como dispositivo ESP-NOW
  // --------------------------------------------------------

  esp_now_peer_info_t peerInfo = {};

  #ifdef PLACA_ESP32
    memcpy(peerInfo.peer_addr, MAC_ESP32C3, 6);
  #endif

  #ifdef PLACA_ESP32C3
    memcpy(peerInfo.peer_addr, MAC_ESP32, 6);
  #endif

  peerInfo.channel = 0;
  peerInfo.encrypt = false;


  if (esp_now_add_peer(&peerInfo) != ESP_OK) {

    Serial.println("Error al agregar la otra placa.");
  }

  else {

    Serial.println("Otra placa agregada correctamente.");
  }
}


void setup() {

  Serial.begin(115200);

  delay(1000);

  Serial.println();
  Serial.println("===================================");
  Serial.println("       PRUEBAS ESP-NOW");
  Serial.println("===================================");


  // Configuración de pines

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


  // Inicializar ESP-NOW
  iniciarESPNow();
  Serial.println();
  Serial.println("Sistema listo.");
  Serial.println();
}

void loop() {

  // PRUEBA 1
  // CONEXIÓN EXITOSA ENTRE PLACAS
  #ifdef PRUEBA_CONEXION

    /*
      La ESP32-C3 envía un mensaje "HELLO".
      La ESP32 lo recibe y muestra:
      Tipo: HELLO
      Valor: 1
    */

    #ifdef PLACA_ESP32C3
      if (millis() - tiempoAnterior >= 2000) {
        tiempoAnterior = millis();
        enviarDatos("HELLO", 1);
        Serial.println("Enviando prueba de conexión...");
      }

    #endif

    #ifdef PLACA_ESP32

      // La recepción se realiza automáticamente
      // mediante cuandoSeRecibio().

    #endif

  #endif

  // PRUEBA 2
  // ENVÍO DE VARIABLE DE ESP32-C3 A ESP32
  #ifdef PRUEBA_VARIABLE_C3_A_ESP32
    /*
      La ESP32-C3 genera una variable y la envía
      periódicamente a la ESP32.
      En este ejemplo se envía el valor de "123".
    */

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

  // PRUEBA 3
  // ENVÍO DE RESPUESTA DE UN PULSADOR
  // ESP32-C3 → ESP32
  #ifdef PRUEBA_PULSADOR
    /*
      Cuando cambia el estado del pulsador en la ESP32-C3,
      se envía el nuevo estado a la ESP32.
      0 = pulsado
      1 = no pulsado
    */
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
  // PRUEBA 4
  // ENVÍO DE RESPUESTA DE UN PIEZOELÉCTRICO
  // ESP32-C3 → ESP32

  #ifdef PRUEBA_PIEZOELECTRICO
    /*
      Se lee el valor del piezoeléctrico en la ESP32-C3
      y se envía periódicamente a la ESP32.
    */

    #ifdef PLACA_ESP32C3
      if (millis() - tiempoAnterior >= 200) {
        tiempoAnterior = millis();
        valorPiezo = analogRead(PIN_PIEZOELECTRICO);
        enviarDatos("PIEZO",valorPiezo);
        Serial.print("Valor piezo enviado: ");
        Serial.println(valorPiezo);
      }

    #endif

  #endif

  // PRUEBA 5
  // ENVÍO DE VARIABLE DE ESP32 A ESP32-C3
  #ifdef PRUEBA_VARIABLE_ESP32_A_C3
    /*
      La ESP32 genera una variable y la envía
      periódicamente a la ESP32-C3.
    */
    #ifdef PLACA_ESP32
      if (millis() - tiempoAnterior >= 1000) {
        tiempoAnterior = millis();
        static int contador = 0;
        contador++;
        enviarDatos( "VARIABLE",contador);
        Serial.print("Variable enviada: ");
        Serial.println(contador);
      }

    #endif

  #endif

  // PRUEBA 6
  // ORDEN PARA PRENDER/APAGAR LED
  // ESP32 → ESP32-C3

  #ifdef PRUEBA_LED
    /*
      La ESP32 envía una orden a la ESP32-C3.
      Valor 1 = encender LED
      Valor 0 = apagar LED
      La ESP32-C3 recibe la orden y controla su LED.
    */

    #ifdef PLACA_ESP32
      if (millis() - tiempoAnterior >= 2000) {
        tiempoAnterior = millis();
        static bool estadoLED = false;
        estadoLED = !estadoLED;
        enviarDatos("LED",estadoLED);
        Serial.print("Orden LED enviada: ");
        if (estadoLED) {
          Serial.println("ENCENDER");
        }
        else {
          Serial.println("APAGAR");
        }
      }

    #endif

  #endif
}