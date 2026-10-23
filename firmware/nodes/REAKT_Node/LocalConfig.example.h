#pragma once
// Set 1 only after checking board and button wiring.
// No LEDs available yet: keep LED output disabled.
#define REAKT_LED_ENABLED 0
#define REAKT_HARDWARE_VALIDATED 0
#define REAKT_NODE_ID 1
#define REAKT_BUTTON_GPIO 18
#define REAKT_LED_GPIO 23
// Replace with gateway STATION MAC from serial (not SoftAP MAC).
#define REAKT_GATEWAY_MAC {0,0,0,0,0,0}
