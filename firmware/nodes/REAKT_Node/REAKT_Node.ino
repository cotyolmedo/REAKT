#include <esp_timer.h>
#include <ReaktRadio.h>
#include "Config.h"
#include "Stimulus.h"
#include "PiezoInput.h"
using namespace reakt;
constexpr uint8_t Channel=6,NodeId=REAKT_NODE_ID;
const uint8_t GatewayMac[6]=REAKT_GATEWAY_MAC;
Radio radio;Pending outbound;Dedup commands;Target target;
PiezoInput piezo;
uint32_t inputBackpressure=0,sendMaxUs=0,impactSeq=0;
uint64_t impactAt=0;
Stimulus stimulus;
uint32_t seq=0,session=0,lastLog=0;bool ready=false;
uint32_t retired[8]={};uint8_t retiredPos=0;
void light(bool active){stimulus.set(active);}
void ack(const Frame& f){Frame a=f;a.type=Type::Ack;a.value=f.seq;a.seq=nextSeq(seq);radio.send(GatewayMac,a);}
bool retiredSession(uint32_t s){for(auto old:retired)if(old==s)return true;return false;}
bool report(Type type,uint32_t us){
 Frame f;f.type=type;f.node=NodeId;f.session=session;f.seq=nextSeq(seq);f.round=target.round;f.value=us;
 if(!outbound.begin(f)){Serial.println("event backpressure; not overwriting pending event");return false;}
 return true;
}
void pollImpact(){
 if(!piezo.poll() || !session)return;
 uint32_t us;Type result=target.press(piezo.detectedAt,us);light(0);
 if(outbound.active){++inputBackpressure;return;}
 if(report(result,us)){impactSeq=outbound.frame.seq;impactAt=piezo.detectedAt;}
}
void setup(){
 Serial.setTxBufferSize(512);Serial.begin(115200);WiFi.mode(WIFI_STA);WiFi.disconnect();
 Serial.println("REAKT node piezo-v2 IO34/IO33 compatible; ADC12 nominal polling");
 Serial.printf("REAKT node id=%u station MAC=%s\n",NodeId,stationMac().c_str());
 if(!REAKT_HARDWARE_VALIDATED||NodeId<1||NodeId>2||!configuredMac(GatewayMac)){Serial.println("BLOCKED: validate LocalConfig hardware/MAC");return;}
 // This sketch targets the classic ESP32/WROOM-32 bench, with Wi-Fi active.
 if((!REAKT_PIEZO_VALIDATED && !REAKT_PIEZO_BENCH_TEST) || REAKT_PIEZO_GPIO<32 || REAKT_PIEZO_GPIO>39 ||
    REAKT_PIEZO_GPIO==37 || REAKT_PIEZO_GPIO==38 ||
    (REAKT_LED_ENABLED && REAKT_PIEZO_GPIO==REAKT_LED_GPIO)){
  Serial.println("BLOCKED: configure and validate protected piezo ADC1 input (ESP32 GPIO32..36/39)");return;
 }
 if(REAKT_PIEZO_BENCH_TEST && !REAKT_PIEZO_VALIDATED)
  Serial.println("BENCH TEST: piezo electrical protection NOT validated");
 piezo.begin();
 Serial.printf("piezo ADC GPIO=%d threshold=%d release=%d (calibration pending)\n",REAKT_PIEZO_GPIO,REAKT_PIEZO_THRESHOLD,REAKT_PIEZO_RELEASE);
 stimulus.begin();
 Serial.println(REAKT_LED_ENABLED?"LED output enabled":"DIAGNOSTIC ONLY: no physical visual stimulus");
 if(esp_wifi_set_channel(Channel,WIFI_SECOND_CHAN_NONE)!=ESP_OK||!radio.begin()||!radio.peer(GatewayMac,Channel)){Serial.println("radio init failed; restart after diagnosis");return;}
 ready=true;
}
void loop(){
 if(!ready)return;
 pollImpact();
 Received rx;
 while(radio.pop(rx)){
  pollImpact();
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
 pollImpact();
 const uint64_t now=uint64_t(esp_timer_get_time());
 if(target.expired(now)){target.active=false;light(0);report(Type::Miss,0);}
 if(outbound.due(millis())){
  if(outbound.attempts==1 && outbound.frame.seq==impactSeq){
   uint32_t elapsed=uint32_t(uint64_t(esp_timer_get_time())-impactAt);
   if(elapsed>sendMaxUs)sendMaxUs=elapsed;
  }
  radio.send(GatewayMac,outbound.frame);
 }
 if(outbound.failed){outbound.failed=false;target.active=false;light(0);Serial.println("event ACK exhausted; session needs restart");}
 piezo.diagnostics(inputBackpressure,sendMaxUs);
 if(uint32_t(millis()-lastLog)>=5000){lastLog=millis();Serial.printf("node session=%lu round=%lu target=%d dropped=%lu invalid=%lu txerr=%lu\n",(unsigned long)session,(unsigned long)target.round,target.active,(unsigned long)radio.dropped,(unsigned long)radio.invalid,(unsigned long)radio.sendErrors);}
}
