#pragma once
#include <stdint.h>
#include <stddef.h>
#include <string.h>
namespace reakt {
constexpr size_t WireSize = 32;
enum class Type : uint8_t { Activate=1, Cancel=2, Hit=3, Miss=4, Early=5, Ack=6 };
struct Frame {
 Type type=Type::Cancel;
 uint8_t node=1;
 uint32_t session=0, seq=0, round=0, value=0, limit=0;
};
inline uint32_t crc(const uint8_t* p, size_t n) {
 uint32_t c=~0u;
 while(n--) { c^=*p++; for(int j=0;j<8;j++) c=(c>>1)^(0xedb88320u & (0u-(c&1))); }
 return ~c;
}
inline void put(uint8_t* p,uint32_t v) { for(int i=0;i<4;i++) p[i]=uint8_t(v>>(8*i)); }
inline uint32_t get(const uint8_t* p) { return uint32_t(p[0])|(uint32_t(p[1])<<8)|(uint32_t(p[2])<<16)|(uint32_t(p[3])<<24); }
inline bool valid(const Frame& f) {
 auto t=uint8_t(f.type);
 return t>=1 && t<=6 && f.node>=1 && f.node<=2 && f.session!=0 && f.seq!=0 &&
   (f.type!=Type::Activate || (f.round>0 && f.limit>=100 && f.limit<=10000));
}
inline void encode(const Frame& f,uint8_t* p) {
 memset(p,0,WireSize); p[0]='R'; p[1]='K'; p[2]=1; p[3]=uint8_t(f.type); p[4]=f.node;
 put(p+8,f.session); put(p+12,f.seq); put(p+16,f.round); put(p+20,f.value); put(p+24,f.limit); put(p+28,crc(p,28));
}
inline bool decode(const uint8_t* p,size_t n,Frame& f) {
 if(n!=WireSize || p[0]!='R'||p[1]!='K'||p[2]!=1||p[5]||p[6]||p[7]||get(p+28)!=crc(p,28)) return false;
 Frame candidate; candidate.type=Type(p[3]); candidate.node=p[4]; candidate.session=get(p+8); candidate.seq=get(p+12);
 candidate.round=get(p+16); candidate.value=get(p+20); candidate.limit=get(p+24);
 if(!valid(candidate)) return false;
 f=candidate; return true;
}
inline uint32_t nextSeq(uint32_t& seq) { if(++seq==0) ++seq; return seq; }
// Per configured sender. A previous session is rejected by the application;
// reset this window only when an authorized new command session starts.
struct Dedup {
 uint32_t seq=0;
 bool accept(uint32_t next) { if(next==0 || (seq!=0 && int32_t(next-seq)<=0)) return false; seq=next; return true; }
};
struct Pending {
 Frame frame; bool active=false, failed=false; uint8_t attempts=0; uint32_t sent=0;
 bool begin(const Frame& f) { if(active) return false; frame=f; active=true; failed=false; attempts=0; return true; }
 bool due(uint32_t now) {
  if(!active) return false;
  if(attempts && uint32_t(now-sent)<120) return false;
  if(attempts>=8) {active=false; failed=true; return false;}
  sent=now; attempts++; return true;
 }
 bool ack(const Frame& a) {
  if(active && a.type==Type::Ack && a.node==frame.node && a.session==frame.session && a.round==frame.round && a.value==frame.seq) {active=false; return true;}
  return false;
 }
};
struct Button {
 bool raw=true, stable=true, armed=false; uint32_t changed=0;
 void init(bool level,uint32_t now) {raw=stable=level; armed=level; changed=now;}
 bool update(bool level,uint32_t now) {
  if(raw!=level) {raw=level; changed=now;}
  if(uint32_t(now-changed)<20 || stable==raw) return false;
  stable=raw;
  if(stable) {armed=true; return false;}
  if(!armed) return false;
  armed=false; return true;
 }
};
struct Target {
 bool active=false; uint32_t session=0, round=0, limit=0; uint64_t started=0;
 void activate(const Frame& f,uint64_t now) {session=f.session; round=f.round; limit=f.limit; started=now; active=true;}
 bool expired(uint64_t now) const {return active && now-started>=uint64_t(limit)*1000;}
 Type press(uint64_t now,uint32_t& reaction) {
  reaction=0;
  if(!active) return Type::Early;
  active=false;
  if(now-started>=uint64_t(limit)*1000) return Type::Miss;
  reaction=uint32_t(now-started); return Type::Hit;
 }
};
struct Score {
 uint32_t hits=0, misses=0, early=0; uint64_t totalUs=0;
 void add(Type t,uint32_t us) {if(t==Type::Hit){hits++;totalUs+=us;} else if(t==Type::Miss) misses++; else if(t==Type::Early) early++;}
 uint32_t meanUs() const {return hits?uint32_t(totalUs/hits):0;}
};
}
