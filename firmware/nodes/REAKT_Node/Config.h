#pragma once
// Copy LocalConfig.example.h to LocalConfig.h after physical validation.
#if __has_include("LocalConfig.h")
#include "LocalConfig.h"
#endif
// Compile helper overrides must be applied after local configuration.
#ifdef REAKT_BUILD_LED_ENABLED
#undef REAKT_LED_ENABLED
#define REAKT_LED_ENABLED REAKT_BUILD_LED_ENABLED
#endif
#ifdef REAKT_BUILD_LED_DIGITAL
#undef REAKT_LED_DIGITAL
#define REAKT_LED_DIGITAL REAKT_BUILD_LED_DIGITAL
#endif
#ifndef REAKT_HARDWARE_VALIDATED
#define REAKT_HARDWARE_VALIDATED 0
#endif
#ifndef REAKT_NODE_ID
#define REAKT_NODE_ID 1
#endif
#ifndef REAKT_PIEZO_GPIO
#define REAKT_PIEZO_GPIO 34
#endif
// Separate gate: the previous button validation does not validate an ADC circuit.
#ifndef REAKT_PIEZO_VALIDATED
#define REAKT_PIEZO_VALIDATED 0
#endif
// Explicit bench authorization, independent of measured electrical validation.
#ifndef REAKT_PIEZO_BENCH_TEST
#define REAKT_PIEZO_BENCH_TEST 0
#endif
#if REAKT_PIEZO_BENCH_TEST != 0 && REAKT_PIEZO_BENCH_TEST != 1
#error "REAKT_PIEZO_BENCH_TEST must be 0 or 1"
#endif
// Provisional raw 12-bit ADC settings; calibrate with the actual mounting.
#ifndef REAKT_PIEZO_THRESHOLD
#define REAKT_PIEZO_THRESHOLD 600
#endif
#ifndef REAKT_PIEZO_RELEASE
#define REAKT_PIEZO_RELEASE 50
#endif
#ifndef REAKT_PIEZO_LOCKOUT_MS
#define REAKT_PIEZO_LOCKOUT_MS 80
#endif
#ifndef REAKT_PIEZO_QUIET_MS
#define REAKT_PIEZO_QUIET_MS 30
#endif
// Nominal 2 kHz polling. Actual gaps are measured; no catch-up burst.
#ifndef REAKT_PIEZO_SAMPLE_US
#define REAKT_PIEZO_SAMPLE_US 500
#endif
// Fixed ground-referenced baseline, in raw ADC counts. No moving-average delay.
#ifndef REAKT_PIEZO_BASELINE
#define REAKT_PIEZO_BASELINE 0
#endif
#ifndef REAKT_PIEZO_DIAGNOSTICS
#define REAKT_PIEZO_DIAGNOSTICS 0
#endif
#ifndef REAKT_PIEZO_LOG_MS
#define REAKT_PIEZO_LOG_MS 250
#endif
#if REAKT_PIEZO_SAMPLE_US < 100 || REAKT_PIEZO_SAMPLE_US > 10000
#error "Sample period must be 100..10000 us"
#endif
#if REAKT_PIEZO_BASELINE < 0 || REAKT_PIEZO_BASELINE > 4095
#error "Baseline must be 0..4095 raw ADC counts"
#endif
#if REAKT_PIEZO_BASELINE + REAKT_PIEZO_THRESHOLD > 4095
#error "Impact threshold must be reachable above the configured baseline"
#endif
#if REAKT_PIEZO_LOG_MS < 100
#error "Diagnostic interval must be at least 100 ms"
#endif
#if REAKT_PIEZO_RELEASE < 0 || REAKT_PIEZO_RELEASE >= REAKT_PIEZO_THRESHOLD || REAKT_PIEZO_THRESHOLD > 4095
#error "Piezo requires 0 <= release < threshold <= 4095"
#endif
#if REAKT_PIEZO_LOCKOUT_MS < 1 || REAKT_PIEZO_QUIET_MS < 1
#error "Piezo lockout and quiet times must be positive"
#endif
#ifndef REAKT_LED_GPIO
#define REAKT_LED_GPIO 33
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
