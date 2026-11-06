#pragma once
// Set 1 only after checking board and wiring.
// No LEDs available yet: keep LED output disabled.
#define REAKT_LED_ENABLED 0
// For a verified single digital LED + series resistor, set DIGITAL=1.
// Keep ENABLED=0 until the actual GPIO, polarity and circuit are checked.
#define REAKT_LED_DIGITAL 0
#define REAKT_LED_COUNT 5
#define REAKT_LED_ACTIVE_HIGH 1
#define REAKT_HARDWARE_VALIDATED 0
#define REAKT_NODE_ID 1
// Select an ADC1 GPIO on the actual ESP32 (ADC2 conflicts with Wi-Fi).
// User-selected GPIO34; keep PIEZO_VALIDATED=0 until protection is checked.
#define REAKT_PIEZO_GPIO 34
#define REAKT_PIEZO_VALIDATED 0
// Set 1 only for an explicitly authorized bench test; not electrical validation.
#define REAKT_PIEZO_BENCH_TEST 0
// User-selected impact threshold 600; resting peaks up to 48; not calibrated.
#define REAKT_PIEZO_THRESHOLD 600
#define REAKT_PIEZO_RELEASE 50
#define REAKT_PIEZO_LOCKOUT_MS 80
#define REAKT_PIEZO_QUIET_MS 30
#define REAKT_PIEZO_SAMPLE_US 500
#define REAKT_PIEZO_BASELINE 0
#define REAKT_PIEZO_DIAGNOSTICS 0
#define REAKT_PIEZO_LOG_MS 250
#define REAKT_LED_GPIO 33
// Replace with gateway STATION MAC from serial (not SoftAP MAC).
#define REAKT_GATEWAY_MAC {0,0,0,0,0,0}
