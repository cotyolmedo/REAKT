/*
  REAKT - ESP32 Gateway base

  This sketch intentionally initializes only the transport foundation. The
  packet schema, node identifiers, MAC addresses, app interface, GPIO map, and
  backend flow are still project decisions and must not be guessed here.
*/

#include <esp_now.h>
#include <WiFi.h>

constexpr unsigned long DIAGNOSTIC_INTERVAL_MS = 5000;

enum class GatewayState : uint8_t {
  Starting,
  EspNowReady,
  CommunicationError,
};

struct GatewayRuntime {
  GatewayState state = GatewayState::Starting;
  volatile uint32_t receivedPackets = 0;
  volatile uint32_t invalidPackets = 0;
  volatile uint32_t failedTransmissions = 0;
  unsigned long lastDiagnosticMs = 0;
};

GatewayRuntime gateway;

const char* gatewayStateName(GatewayState state) {
  switch (state) {
    case GatewayState::Starting:
      return "starting";
    case GatewayState::EspNowReady:
      return "ESP-NOW ready";
    case GatewayState::CommunicationError:
      return "communication error";
  }

  return "unknown";
}

// Transport callbacks do not parse messages until packet v1 is agreed.
void onEspNowSent(const wifi_tx_info_t* info, esp_now_send_status_t status) {
  if (status != ESP_NOW_SEND_SUCCESS) {
    gateway.failedTransmissions++;
  }
}

void onEspNowReceived(const esp_now_recv_info_t* info, const uint8_t* data, int length) {
  if (info == nullptr || data == nullptr || length <= 0) {
    gateway.invalidPackets++;
    return;
  }

  gateway.receivedPackets++;

  // TODO: Validate and enqueue packet v1 once Docs/packet-protocol.md is final.
}

bool initializeEspNow() {
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

// Call this only after the final node MAC mapping and radio-channel strategy are documented.
bool registerNodePeer(const uint8_t macAddress[6], uint8_t channel) {
  if (macAddress == nullptr || gateway.state != GatewayState::EspNowReady) {
    return false;
  }

  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, macAddress, sizeof(peer.peer_addr));
  peer.channel = channel;
  peer.encrypt = false;

  return esp_now_add_peer(&peer) == ESP_OK;
}

void receiveApplicationCommands() {
  // TODO: Add the finalized App <-> Gateway interface here.
}

void processNodeEvents() {
  // TODO: Consume validated packet v1 events and update gateway state here.
}

void updateOutputs() {
  // TODO: Add gateway indicators only after hardware GPIO assignments are final.
}

void reportDiagnostics() {
  const unsigned long now = millis();
  if (now - gateway.lastDiagnosticMs < DIAGNOSTIC_INTERVAL_MS) {
    return;
  }

  gateway.lastDiagnosticMs = now;
  Serial.print("Gateway state: ");
  Serial.print(gatewayStateName(gateway.state));
  Serial.print(" | received: ");
  Serial.print(gateway.receivedPackets);
  Serial.print(" | invalid: ");
  Serial.print(gateway.invalidPackets);
  Serial.print(" | send failures: ");
  Serial.println(gateway.failedTransmissions);
}

void setup() {
  Serial.begin(115200);
  Serial.println();
  Serial.println("REAKT gateway starting");

  if (!initializeEspNow()) {
    Serial.println("ESP-NOW initialization failed; retry or recovery policy is pending.");
  }
}

void loop() {
  receiveApplicationCommands();
  processNodeEvents();
  updateOutputs();
  reportDiagnostics();
}
