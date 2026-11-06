#include "../firmware/nodes/REAKT_Node/Piezo.h"
#include "../firmware/nodes/REAKT_Node/SampleClock.h"
#include "ReaktCore.h"
#include <assert.h>
#include <stdio.h>

int main() {
  Piezo p(600, 200, 80, 30);
  p.init(0);
  assert(!p.update(1000, 0)); // high at boot cannot trigger
  assert(!p.update(0, 1));
  assert(!p.update(0, 80));
  assert(!p.update(599, 81));
  assert(p.update(600, 82));
  assert(!p.update(4095, 83));
  assert(!p.update(0, 90));
  assert(!p.update(800, 100)); // ringing interrupts quiet interval
  assert(!p.update(0, 140));
  assert(!p.update(300, 169)); // hysteresis band also interrupts quiet
  assert(!p.update(0, 170));
  assert(!p.update(0, 199));
  assert(!p.update(0, 200));
  assert(p.update(700, 201));
  assert(!p.update(0, 202));
  assert(!p.update(0, 232));
  assert(!p.update(700, 240)); // quiet alone cannot bypass lockout
  assert(!p.update(0, 250));
  assert(!p.update(0, 281));
  assert(p.update(700, 282));
  p.init(0xfffffff0u);
  assert(!p.update(0, 0xfffffff0u));
  assert(!p.update(0, 0x40u)); // millis wrap
  assert(p.update(600, 0x41u));
  // Current defaults: resting peaks provided by user are <=48, not impact data.
  Piezo sensor(600, 50, 80, 30);
  sensor.init(0);
  for (uint32_t t=0; t<1000; ++t) assert(!sensor.update(uint16_t(t%49), t));
  assert(sensor.state(1000)==Piezo::State::Ready);
  assert(!sensor.update(599,1000));
  assert(sensor.update(600,1001));
  assert(sensor.state(1001)==Piezo::State::Refractory);
  for(uint32_t t=1002; t<1100; ++t) assert(!sensor.update(4095,t));
  assert(sensor.state(1100)==Piezo::State::Rearming);
  assert(!sensor.update(0,1100));
  sensor.breakQuiet(); // missing acquisition cannot count as observed quiet
  assert(!sensor.update(0,1150));
  assert(!sensor.update(0,1179));
  assert(!sensor.update(0,1180));
  assert(sensor.update(700,1181));

  SampleClock clock; bool gap;
  clock.init();
  assert(clock.due(0xfffffff0u,500,gap)&&!gap);
  assert(!clock.due(0xfffffff1u,500,gap));
  assert(clock.due(484,500,gap)&&!gap); // micros wrap
  assert(clock.due(2484,500,gap)&&gap&&clock.missed==3&&clock.maxGap==2000);
  assert(!clock.due(2484,500,gap)); // no fake catch-up acquisition

  // Synthetic long run: 1000 distinct impacts, ringing, no extra events.
  sensor.init(0);
  unsigned count=0;
  for(uint32_t t=0;t<200200;++t){
    const uint32_t phase=t%200;
    const uint16_t sample=(t>=200&&phase<20)?uint16_t(phase%2?900:4095):20;
    if(sensor.update(sample,t))++count;
  }
  assert(count==1000);
  // Lockout suppresses another pulse; that pulse also restarts quiet detection.
  sensor.init(0);sensor.update(0,0);sensor.update(0,80);
  assert(sensor.update(600,81));
  assert(!sensor.update(0,82));assert(!sensor.update(0,112));
  assert(!sensor.update(600,150));
  assert(!sensor.update(0,151));assert(!sensor.update(0,181));
  assert(sensor.update(600,182));
  // With uninterrupted quiet, independent hits 81ms apart are distinguishable.
  sensor.init(0);sensor.update(0,0);sensor.update(0,80);
  assert(sensor.update(600,81));
  assert(!sensor.update(0,82));assert(!sensor.update(0,112));
  assert(!sensor.update(0,161));assert(sensor.update(600,162));

  // Integration with unchanged Target and wire protocol, no physical radio.
  using namespace reakt;
  Frame command;command.type=Type::Activate;command.node=1;command.session=1;
  command.round=1;command.seq=1;command.limit=1000;
  Target target;target.activate(command,1000000);
  uint32_t reaction;assert(target.press(1000500,reaction)==Type::Hit&&reaction==500);
  Frame event=command;event.type=Type::Hit;event.value=reaction;
  uint8_t bytes[WireSize];encode(event,bytes);Frame decoded;
  assert(decode(bytes,WireSize,decoded)&&decoded.type==Type::Hit&&decoded.node==1);
  Dedup gateway;assert(gateway.accept(decoded.seq));assert(!gateway.accept(decoded.seq));
  assert(target.press(1000600,reaction)==Type::Early);
  target.activate(command,2000000);assert(target.press(3000000,reaction)==Type::Miss);
  puts("PASS piezo startup, threshold, ringing, hysteresis, lockout, rearm, wrap");
  puts("PASS current 600/50, noise<=48, saturation recovery, gaps, 1000 synthetic impacts, target/wire/dedup");
}
