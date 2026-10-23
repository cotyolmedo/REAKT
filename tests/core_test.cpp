#include "ReaktCore.h"
#include <assert.h>
#include <iostream>
using namespace reakt;
int main(){
 assert(crc(reinterpret_cast<const uint8_t*>("123456789"),9)==0xcbf43926u);
 Frame f; f.type=Type::Activate;f.node=2;f.session=0x12345678;f.seq=17;f.round=1;f.limit=1000;
 uint8_t b[WireSize];encode(f,b);Frame d;assert(decode(b,32,d));assert(d.session==f.session&&d.node==2&&d.limit==1000);
 assert(b[8]==0x78&&b[11]==0x12);assert(!decode(b,31,d));
 for(size_t i=0;i<32;i++){b[i]^=1;assert(!decode(b,32,d));b[i]^=1;}
 f.limit=99;encode(f,b);assert(!decode(b,32,d));f.limit=1000;
 Dedup dedup;assert(dedup.accept(17));assert(!dedup.accept(17));assert(!dedup.accept(16));assert(dedup.accept(18));
 Pending pending;assert(pending.begin(f));assert(!pending.begin(f));assert(pending.due(0));assert(!pending.due(119));assert(pending.due(120));
 Frame a=f;a.type=Type::Ack;a.value=f.seq+1;assert(!pending.ack(a));a.value=f.seq;a.session++;assert(!pending.ack(a));a.session=f.session;assert(pending.ack(a));
 assert(pending.begin(f));for(int i=0;i<8;i++)assert(pending.due(uint32_t(0xfffffff0u+i*120)));assert(!pending.due(uint32_t(0xfffffff0u+8*120)));assert(pending.failed);
 Button button;button.init(true,0);assert(!button.update(false,10));assert(!button.update(true,15));assert(!button.update(false,18));assert(!button.update(false,37));assert(button.update(false,38));assert(!button.update(false,500));button.update(true,501);button.update(true,521);button.update(false,522);assert(button.update(false,542));
 button.init(false,0);assert(!button.update(false,50)); // held at boot is not an event
 Target t;t.activate(f,1000000);uint32_t reaction;assert(t.press(1234567,reaction)==Type::Hit&&reaction==234567);assert(t.press(1234568,reaction)==Type::Early);
 t.activate(f,1000000);assert(!t.expired(1999999));assert(t.expired(2000000));assert(t.press(2000000,reaction)==Type::Miss);
 Score s;s.add(Type::Hit,200);s.add(Type::Hit,400);s.add(Type::Miss,0);s.add(Type::Early,0);assert(s.hits==2&&s.misses==1&&s.early==1&&s.meanUs()==300);
 std::cout<<"PASS protocol roundtrip/corruption/ranges, dedup, ACK/retry/wrap, debounce, monotonic deadline, scores\n";
}
