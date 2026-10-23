#pragma once
// Copy LocalConfig.example.h to LocalConfig.h after physical validation.
#if __has_include("LocalConfig.h")
#include "LocalConfig.h"
#endif
#ifndef REAKT_HARDWARE_VALIDATED
#define REAKT_HARDWARE_VALIDATED 0
#endif
#ifndef REAKT_NODE_ID
#define REAKT_NODE_ID 1
#endif
#ifndef REAKT_BUTTON_GPIO
#define REAKT_BUTTON_GPIO 18
#endif
#ifndef REAKT_LED_GPIO
#define REAKT_LED_GPIO 23
#endif
#ifndef REAKT_GATEWAY_MAC
#define REAKT_GATEWAY_MAC {0,0,0,0,0,0}
#endif

#ifndef REAKT_LED_ENABLED
#define REAKT_LED_ENABLED 0
#endif

// 0 = WS2812B (existing configuration), 1 = single current-limited digital LED.
#ifndef REAKT_LED_DIGITAL
#define REAKT_LED_DIGITAL 0
#endif
#ifndef REAKT_LED_COUNT
#define REAKT_LED_COUNT 5
#endif
#ifndef REAKT_LED_ACTIVE_HIGH
#define REAKT_LED_ACTIVE_HIGH 1
#endif
#if REAKT_LED_DIGITAL != 0 && REAKT_LED_DIGITAL != 1
#error "REAKT_LED_DIGITAL must be 0 or 1"
#endif
#if REAKT_LED_COUNT < 1 || REAKT_LED_COUNT > 255
#error "REAKT_LED_COUNT must be between 1 and 255"
#endif
