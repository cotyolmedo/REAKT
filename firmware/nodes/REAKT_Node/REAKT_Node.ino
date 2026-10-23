#include <esp_timer.h>
#include <ReaktRadio.h>
#include "Config.h"
#include "Stimulus.h"
using namespace reakt;
constexpr uint8_t Channel=6,NodeId=REAKT_NODE_ID;
const uint8_t GatewayMac[6]=REAKT_GATEWAY_MAC;
Radio radio;Pending outbound;Dedup commands;Button button;Target target;
Stimulus stimulus;
uint32_t seq=0,session=0,lastLog=0;bool ready=false;
uint32_t retired[8]={};uint8_t retiredPos=0;
void light(bool active){stimulus.set(active);}
void ack(const Frame& f){Frame a=f;a.type=Type::Ack;a.value=f.seq;a.seq=nextSeq(seq);radio.send(GatewayMac,a);}
bool retiredSession(uint32_t s){for(auto old:retired)if(old==s)return true;return false;}
void report(Type type,uint32_t us){
 Frame f;f.type=type;f.node=NodeId;f.session=session;f.seq=nextSeq(seq);f.round=target.round;f.value=us;
 if(!outbound.begin(f))Serial.println("event backpressure; not overwriting pending event");
}
void setup(){
 Serial.begin(115200);WiFi.mode(WIFI_STA);WiFi.disconnect();
 Serial.printf("REAKT node id=%u station MAC=%s\n",NodeId,WiFi.macAddress().c_str());
 if(!REAKT_HARDWARE_VALIDATED||NodeId<1||NodeId>2||!configuredMac(GatewayMac)){Serial.println("BLOCKED: validate LocalConfig hardware/MAC");return;}
 pinMode(REAKT_BUTTON_GPIO,INPUT_PULLUP);button.init(digitalRead(REAKT_BUTTON_GPIO)==HIGH,millis());
 stimulus.begin();
 Serial.println(REAKT_LED_ENABLED?"LED output enabled":"DIAGNOSTIC ONLY: no physical visual stimulus");
 if(esp_wifi_set_channel(Channel,WIFI_SECOND_CHAN_NONE)!=ESP_OK||!radio.begin()||!radio.peer(GatewayMac,Channel)){Serial.println("radio init failed; restart after diagnosis");return;}
 ready=true;
}
void loop(){
 if(!ready)return;
 Received rx;
 while(radio.pop(rx)){
  Frame f=rx.frame;
  if(memcmp(rx.mac,GatewayMac,6)||f.node!=NodeId)continue;
  if(f.type==Type::Ack){outbound.ack(f);continue;}
  if(f.type!=Type::Activate&&f.type!=Type::Cancel)continue;
  if(f.session!=session){
   if(retiredSession(f.session))continue;
   if(session)retired[retiredPos++%8]=session;
   session=f.session;commands={};outbound={};target.active=false;light(0);
  }
  ack(f);
  if(!commands.accept(f.seq))continue;
  if(f.type==Type::Cancel){target.active=false;target.round=f.round;target.session=f.session;outbound={};light(0);continue;}
  // Advancing round is an implicit ACK for the previous round event.
  if(outbound.active && outbound.frame.session==f.session && outbound.frame.round<f.round)outbound={};
  // An accepted command starts only once; retransmissions cannot reset its clock.
  light(true);target.activate(f,uint64_t(esp_timer_get_time()));
  Serial.printf("stimulus round=%lu LED=%d\n",(unsigned long)f.round,REAKT_LED_ENABLED);
 }
 const uint64_t now=uint64_t(esp_timer_get_time());
 if(button.update(digitalRead(REAKT_BUTTON_GPIO)==HIGH,millis()) && session){
  uint32_t us;Type result=target.press(now,us);light(0);
  if(!outbound.active)report(result,us);
 }
 if(target.expired(now)){target.active=false;light(0);report(Type::Miss,0);}
 if(outbound.due(millis()))radio.send(GatewayMac,outbound.frame);
 if(outbound.failed){outbound.failed=false;target.active=false;light(0);Serial.println("event ACK exhausted; session needs restart");}
 if(uint32_t(millis()-lastLog)>=5000){lastLog=millis();Serial.printf("node session=%lu round=%lu target=%d dropped=%lu invalid=%lu txerr=%lu\n",(unsigned long)session,(unsigned long)target.round,target.active,(unsigned long)radio.dropped,(unsigned long)radio.invalid,(unsigned long)radio.sendErrors);}
}
