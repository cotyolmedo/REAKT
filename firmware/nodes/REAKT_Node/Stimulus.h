#pragma once
#include <Arduino.h>
#include "Config.h"
#if REAKT_LED_ENABLED && !REAKT_LED_DIGITAL
#include <Adafruit_NeoPixel.h>
#endif

// Output only: the node retains the shared timing, debounce and radio logic.
class Stimulus {
#if REAKT_LED_ENABLED && !REAKT_LED_DIGITAL
  Adafruit_NeoPixel pixels{REAKT_LED_COUNT, REAKT_LED_GPIO, NEO_GRB + NEO_KHZ800};
#endif
public:
  void set(bool active) {
#if REAKT_LED_ENABLED && REAKT_LED_DIGITAL
    digitalWrite(REAKT_LED_GPIO, active == bool(REAKT_LED_ACTIVE_HIGH) ? HIGH : LOW);
#elif REAKT_LED_ENABLED
    pixels.fill(active ? pixels.Color(0, 80, 0) : 0);
    pixels.show();
#else
    (void)active;
#endif
  }
  void begin() {
#if REAKT_LED_ENABLED && REAKT_LED_DIGITAL
    // Preload the OFF level before switching the pin to output.
    set(false);
    pinMode(REAKT_LED_GPIO, OUTPUT);
#elif REAKT_LED_ENABLED
    pixels.begin();
    pixels.setBrightness(32);
    set(false);
#endif
  }
};
