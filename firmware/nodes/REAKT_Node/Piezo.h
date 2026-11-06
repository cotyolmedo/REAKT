#pragma once
#include <stdint.h>

// Conditioned, ground-referenced ADC signal. No force measurement implied.
class Piezo {
  const uint16_t trigger, release;
  const uint32_t lockoutMs, quietMs;
  bool armed = false, quiet = false;
  uint32_t lastHit = 0, quietSince = 0;
public:
  enum class State : uint8_t { Ready, Refractory, Rearming };
  Piezo(uint16_t high, uint16_t low, uint32_t lockout, uint32_t settle)
      : trigger(high), release(low), lockoutMs(lockout), quietMs(settle) {}
  void init(uint32_t now) {
    armed = false; quiet = false; lastHit = now;
  }
  // Unsampled time cannot prove continuous quiet. Keep an already armed input.
  void breakQuiet() { quiet = false; }
  State state(uint32_t now) const {
    if (armed) return State::Ready;
    return uint32_t(now - lastHit) < lockoutMs ? State::Refractory : State::Rearming;
  }
  bool update(uint16_t sample, uint32_t now) {
    if (armed && sample >= trigger) {
      armed = false; quiet = false; lastHit = now;
      return true;
    }
    if (!armed) {
      if (sample <= release) {
        if (!quiet) { quiet = true; quietSince = now; }
        if (uint32_t(now - quietSince) >= quietMs &&
            uint32_t(now - lastHit) >= lockoutMs) armed = true;
      } else quiet = false;
    }
    return false;
  }
};
