#pragma once
#include <stdint.h>

// Polling clock: measure real gaps; do not pretend missed samples were acquired.
struct SampleClock {
  uint32_t last = 0, maxGap = 0, missed = 0;
  bool started = false;
  void init() { last = maxGap = missed = 0; started = false; }
  bool due(uint32_t now, uint32_t period, bool& discontinuity) {
    discontinuity = false;
    if (!started) { started = true; last = now; return true; }
    uint32_t gap = now - last;
    if (gap < period) return false;
    last = now;
    if (gap > maxGap) maxGap = gap;
    missed += gap / period - 1;
    discontinuity = gap >= 2 * period;
    return true;
  }
};
