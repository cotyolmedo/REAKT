/*
  REAKT - ESP32 gateway (base de transporte)

  El protocolo de paquetes v1, la interfaz App <-> gateway, la politica de
  canal y las MAC de los nodos siguen TBD. Este sketch recibe tramas opacas,
  las encola y deja su validacion semantica fuera del callback de ESP-NOW.
*/

#include <Arduino.h>
#include <WiFi.h>
#include <esp_now.h>

namespace Config {
constexpr uint32_t SERIAL_BAUD = 115200;
constexpr uint32_t DIAGNOSTIC_INTERVAL_MS = 5000;
constexpr uint32_t RECOVERY_INTERVAL_MS = 5000;
constexpr size_t RX_QUEUE_CAPACITY = 8;
constexpr size_t MAX_ESPNOW_PAYLOAD = 250;
}

enum class GatewayState : uint8_t {
  Starting,
  EspNowReady,
  CommunicationError
};

struct ReceivedFrame {
  uint8_t sender[6] = {};
  uint8_t data[Config::MAX_ESPNOW_PAYLOAD] = {};
  uint16_t length = 0;
};

struct GatewayRuntime {
  GatewayState state = GatewayState::Starting;
  volatile uint32_t receivedPackets = 0;
  volatile uint32_t invalidPackets = 0;
  volatile uint32_t droppedPackets = 0;
  volatile uint32_t failedTransmissions = 0;
  uint32_t lastDiagnosticMs = 0;
  uint32_t lastInitAttemptMs = 0;
};

GatewayRuntime gateway;
ReceivedFrame rxQueue[Config::RX_QUEUE_CAPACITY];
volatile uint8_t rxHead = 0;
volatile uint8_t rxTail = 0;
portMUX_TYPE rxMux = portMUX_INITIALIZER_UNLOCKED;

const char* gatewayStateName(GatewayState state) {
  switch (state) {
    case GatewayState::Starting: return "starting";
    case GatewayState::EspNowReady: return "ESP-NOW ready";
    case GatewayState::CommunicationError: return "communication error";
  }
  return "unknown";
}

bool enqueueReceivedFrame(const esp_now_recv_info_t* info,
                          const uint8_t* data,
                          int length) {
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

bool dequeueReceivedFrame(ReceivedFrame& frame) {
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

void onEspNowSent(const wifi_tx_info_t*, esp_now_send_status_t status) {
  if (status != ESP_NOW_SEND_SUCCESS) {
    gateway.failedTransmissions++;
  }
}

void onEspNowReceived(const esp_now_recv_info_t* info,
                      const uint8_t* data,
                      int length) {
  if (info == nullptr || info->src_addr == nullptr || data == nullptr ||
      length <= 0 || length > static_cast<int>(Config::MAX_ESPNOW_PAYLOAD)) {
    gateway.invalidPackets++;
    return;
  }

  if (!enqueueReceivedFrame(info, data, length)) {
    gateway.droppedPackets++;
    return;
  }

  gateway.receivedPackets++;
}

bool initializeEspNow() {
  gateway.lastInitAttemptMs = millis();
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();

  if (esp_now_init() != ESP_OK) {
    gateway.state = GatewayState::CommunicationError;
    return false;
  }

  esp_now_register_send_cb(onEspNowSent);
  esp_now_register_recv_cb(onEspNowReceived);
  gateway.state = GatewayState::EspNowReady;
  return true;
}

// Usar unicamente despues de documentar MAC, canal y politica de peers.
bool registerNodePeer(const uint8_t macAddress[6], uint8_t channel) {
  if (macAddress == nullptr || gateway.state != GatewayState::EspNowReady ||
      channel == 0) {
    return false;
  }

  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, macAddress, sizeof(peer.peer_addr));
  peer.channel = channel;
  peer.encrypt = false;
  return esp_now_add_peer(&peer) == ESP_OK;
}

void recoverTransportIfNeeded() {
  if (gateway.state != GatewayState::CommunicationError) return;

  const uint32_t now = millis();
  if (now - gateway.lastInitAttemptMs < Config::RECOVERY_INTERVAL_MS) return;

  Serial.println("Retrying ESP-NOW initialization...");
  esp_now_deinit();
  initializeEspNow();
}

void receiveApplicationCommands() {
  // TODO: implementar cuando se acuerde la interfaz App <-> gateway.
}

void processNodeEvents() {
  ReceivedFrame frame;
  while (dequeueReceivedFrame(frame)) {
    // TODO: validar version, tipo, nodo, secuencia y longitud del protocolo v1.
    // El payload permanece opaco hasta que Docs/packet-protocol.md sea final.
    (void)frame;
  }
}

void updateOutputs() {
  // TODO: no hay GPIO del gateway confirmado.
}

void reportDiagnostics() {
  const uint32_t now = millis();
  if (now - gateway.lastDiagnosticMs < Config::DIAGNOSTIC_INTERVAL_MS) return;
  gateway.lastDiagnosticMs = now;

  Serial.print("Gateway state: ");
  Serial.print(gatewayStateName(gateway.state));
  Serial.print(" | received: ");
  Serial.print(gateway.receivedPackets);
  Serial.print(" | invalid: ");
  Serial.print(gateway.invalidPackets);
  Serial.print(" | dropped: ");
  Serial.print(gateway.droppedPackets);
  Serial.print(" | send failures: ");
  Serial.println(gateway.failedTransmissions);
}

void setup() {
  Serial.begin(Config::SERIAL_BAUD);
  Serial.println();
  Serial.println("REAKT gateway starting");

  if (!initializeEspNow()) {
    Serial.println("ESP-NOW initialization failed; retry scheduled.");
  }
}

void loop() {
  recoverTransportIfNeeded();
  receiveApplicationCommands();
  processNodeEvents();
  updateOutputs();
  reportDiagnostics();
}
