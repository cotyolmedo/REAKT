#pragma once
#include <Arduino.h>
#include <esp_timer.h>
#include "Config.h"
#include "Piezo.h"
#include "SampleClock.h"
#if !defined(CONFIG_IDF_TARGET_ESP32)
#error "This pin configuration targets classic ESP32, not C3/S3"
#endif

// ADC acquisition and bounded diagnostics; training and radio remain in the node.
class PiezoInput {
  Piezo detector{REAKT_PIEZO_THRESHOLD, REAKT_PIEZO_RELEASE,
                 REAKT_PIEZO_LOCKOUT_MS, REAKT_PIEZO_QUIET_MS};
  SampleClock clock;
  uint16_t raw = 0, peak = 0;
  uint32_t lastLog = 0;
public:
  uint32_t hits = 0, adcMaxUs = 0, detectMaxUs = 0, skippedLogs = 0;
  uint64_t detectedAt = 0;
  void begin() {
    pinMode(REAKT_PIEZO_GPIO, INPUT);
    analogReadResolution(12);
    analogSetPinAttenuation(REAKT_PIEZO_GPIO, ADC_11db);
    detector.init(millis()); clock.init();
  }
  bool poll() {
    const uint64_t before = uint64_t(esp_timer_get_time());
    bool gap;
    if (!clock.due(uint32_t(before), REAKT_PIEZO_SAMPLE_US, gap)) return false;
    if (gap) detector.breakQuiet();
    raw = analogRead(REAKT_PIEZO_GPIO);
    const uint64_t acquired = uint64_t(esp_timer_get_time());
    const uint32_t adcUs = uint32_t(acquired - before);
    if (adcUs > adcMaxUs) adcMaxUs = adcUs;
    if (raw > peak) peak = raw;
    const uint16_t amplitude = raw > REAKT_PIEZO_BASELINE ? raw - REAKT_PIEZO_BASELINE : 0;
    const bool hit = detector.update(amplitude, millis());
    const uint32_t detectUs = uint32_t(uint64_t(esp_timer_get_time()) - acquired);
    if (detectUs > detectMaxUs) detectMaxUs = detectUs;
    if (hit) { detectedAt = acquired; ++hits; }
    return hit;
  }
  void diagnostics(uint32_t backpressure, uint32_t sendMaxUs) {
#if REAKT_PIEZO_DIAGNOSTICS
    const uint32_t now = millis();
    if (uint32_t(now - lastLog) < REAKT_PIEZO_LOG_MS) return;
    lastLog = now;
    char line[240];
    const int n = snprintf(line, sizeof(line),
      "piezo raw=%u peak=%u hits=%lu state=%u gap_us=%lu missed=%lu adc_us=%lu detect_us=%lu send_us=%lu busy=%lu logskip=%lu\n",
      raw, peak, (unsigned long)hits, unsigned(detector.state(now)),
      (unsigned long)clock.maxGap, (unsigned long)clock.missed,
      (unsigned long)adcMaxUs, (unsigned long)detectMaxUs,
      (unsigned long)sendMaxUs, (unsigned long)backpressure, (unsigned long)skippedLogs);
    // Never wait for serial capacity: diagnostics may be dropped, not samples.
    if (n > 0 && n < int(sizeof(line)) && Serial.availableForWrite() >= n) {
      Serial.write(reinterpret_cast<const uint8_t*>(line), size_t(n)); peak = 0;
    } else ++skippedLogs;
#else
    (void)backpressure; (void)sendMaxUs;
#endif
  }
};
