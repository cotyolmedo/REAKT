/*
  REAKT - ESP32 node (estructura de entrada y estados)

  GPIO, cantidad de WS2812B, MAC del gateway, canal y protocolo v1 siguen TBD.
  El sketch compila sin activar hardware desconocido y deja la configuración
  concentrada en Config para habilitarla después de medir/verificar la placa.
*/

#include <Arduino.h>
#include <WiFi.h>
#include <esp_now.h>
#include <esp_timer.h>

namespace Config {
constexpr uint32_t SERIAL_BAUD = 115200;
constexpr uint32_t DEBOUNCE_MS = 20;  // valor inicial de ensayo; no validado
constexpr int8_t BUTTON_GPIO = -1;    // TBD: pulsador NA a GND
constexpr int8_t LED_GPIO = -1;       // TBD: datos WS2812B
constexpr uint16_t LED_COUNT = 0;     // TBD
constexpr size_t RX_QUEUE_CAPACITY = 4;
constexpr size_t MAX_ESPNOW_PAYLOAD = 250;
}

enum class NodeState : uint8_t {
  Initializing,
  Ready,
  WaitingStimulus,
  TargetActive,
  EventRegistered,
  Error
};

enum class LightState : uint8_t { Off, Waiting, Target, Hit, Error };

struct ButtonRuntime {
  bool rawLevel = true;
  bool stableLevel = true;
  bool armed = true;
  uint32_t lastTransitionMs = 0;
};

struct NodeRuntime {
  NodeState state = NodeState::Initializing;
  LightState light = LightState::Off;
  uint32_t buttonEvents = 0;
  uint64_t lastEventUs = 0;
  uint32_t receivedCommands = 0;
  uint32_t invalidCommands = 0;
  uint32_t droppedCommands = 0;
  uint32_t failedTransmissions = 0;
};

struct ReceivedFrame {
  uint8_t sender[6] = {};
  uint8_t data[Config::MAX_ESPNOW_PAYLOAD] = {};
  uint16_t length = 0;
};

ButtonRuntime button;
NodeRuntime node;
ReceivedFrame rxQueue[Config::RX_QUEUE_CAPACITY];
volatile uint8_t rxHead = 0;
volatile uint8_t rxTail = 0;
portMUX_TYPE rxMux = portMUX_INITIALIZER_UNLOCKED;

const char* stateName(NodeState state) {
  switch (state) {
    case NodeState::Initializing: return "initializing";
    case NodeState::Ready: return "ready";
    case NodeState::WaitingStimulus: return "waiting stimulus";
    case NodeState::TargetActive: return "target active";
    case NodeState::EventRegistered: return "event registered";
    case NodeState::Error: return "error";
  }
  return "unknown";
}

void setLight(LightState next) {
  node.light = next;
  // TODO: controlar WS2812B cuando GPIO, cantidad, alimentación y librería
  // estén confirmados. No se escribe en un GPIO TBD.
}

void registerButtonEvent(uint32_t nowMs) {
  node.buttonEvents++;
  node.lastEventUs = static_cast<uint64_t>(esp_timer_get_time());
  node.state = NodeState::EventRegistered;
  Serial.print("Button event #");
  Serial.print(node.buttonEvents);
  Serial.print(" at ms ");
  Serial.println(nowMs);
  // TODO: serializar/enviar evento sólo cuando el protocolo v1 esté acordado.
}

bool enqueueGatewayFrame(const esp_now_recv_info_t* info, const uint8_t* data, int length) {
  portENTER_CRITICAL(&rxMux);
  const uint8_t nextHead = (rxHead + 1) % Config::RX_QUEUE_CAPACITY;
  if (nextHead == rxTail) {
    portEXIT_CRITICAL(&rxMux);
    return false;
  }

  memcpy(rxQueue[rxHead].sender, info->src_addr, sizeof(rxQueue[rxHead].sender));
  memcpy(rxQueue[rxHead].data, data, static_cast<size_t>(length));
  rxQueue[rxHead].length = static_cast<uint16_t>(length);
  rxHead = nextHead;
  portEXIT_CRITICAL(&rxMux);
  return true;
}

bool dequeueGatewayFrame(ReceivedFrame& frame) {
  portENTER_CRITICAL(&rxMux);
  if (rxTail == rxHead) {
    portEXIT_CRITICAL(&rxMux);
    return false;
  }
  frame = rxQueue[rxTail];
  rxTail = (rxTail + 1) % Config::RX_QUEUE_CAPACITY;
  portEXIT_CRITICAL(&rxMux);
  return true;
}

void updateButton() {
  if (Config::BUTTON_GPIO < 0) return;

  const uint32_t now = millis();
  const bool rawLevel = digitalRead(Config::BUTTON_GPIO) == HIGH;
  if (rawLevel != button.rawLevel) {
    button.rawLevel = rawLevel;
    button.lastTransitionMs = now;
  }

  if (now - button.lastTransitionMs < Config::DEBOUNCE_MS ||
      button.stableLevel == button.rawLevel) {
    return;
  }

  button.stableLevel = button.rawLevel;
  if (!button.stableLevel) {
    if (button.armed) {
      button.armed = false;
      registerButtonEvent(now);
    }
  } else {
    // El rearme requiere liberación estable; no hay repetición por pulsación larga.
    button.armed = true;
    node.state = NodeState::Ready;
  }
}

bool initializeEspNow() {
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  if (esp_now_init() != ESP_OK) return false;
  esp_now_register_recv_cb([](const esp_now_recv_info_t* info, const uint8_t* data, int length) {
    if (info == nullptr || info->src_addr == nullptr || data == nullptr ||
        length <= 0 || length > static_cast<int>(Config::MAX_ESPNOW_PAYLOAD)) {
      node.invalidCommands++;
      return;
    }
    if (!enqueueGatewayFrame(info, data, length)) {
      node.droppedCommands++;
      return;
    }
    node.receivedCommands++;
  });
  // TODO: registrar callback de envío y peer del gateway cuando estén definidos.
  // TODO: registrar peer del gateway cuando su MAC/canal estén definidos.
  return true;
}

void processGatewayCommands() {
  ReceivedFrame frame;
  while (dequeueGatewayFrame(frame)) {
    // TODO: validar aquí versión, tipo, nodo, secuencia y payload del protocolo v1.
    // No se cambia el estado por bytes cuyo significado aún no fue acordado.
    (void)frame;
  }
}

void setup() {
  Serial.begin(Config::SERIAL_BAUD);
  Serial.println();
  Serial.println("REAKT node starting");

  if (Config::BUTTON_GPIO >= 0) {
    pinMode(Config::BUTTON_GPIO, INPUT_PULLUP);
    button.rawLevel = digitalRead(Config::BUTTON_GPIO) == HIGH;
    button.stableLevel = button.rawLevel;
  } else {
    Serial.println("Button GPIO is TBD; input acquisition disabled.");
  }

  if (!initializeEspNow()) {
    node.state = NodeState::Error;
    Serial.println("ESP-NOW initialization failed.");
    return;
  }

  node.state = NodeState::Ready;
  setLight(LightState::Off);
  Serial.print("Node state: ");
  Serial.println(stateName(node.state));
}

void loop() {
  processGatewayCommands();
  updateButton();
  // TODO: procesar órdenes del gateway y controlar la máquina de estímulo.
}
