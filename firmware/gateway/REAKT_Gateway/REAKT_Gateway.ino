#include <ReaktRadio.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
#include <esp_system.h>
#include "Config.h"
using namespace reakt;
constexpr uint8_t Channel=6;
const uint8_t Nodes[2][6]={REAKT_NODE1_MAC,REAKT_NODE2_MAC};
Radio radio;Pending pending[2];Dedup events[2];Score score;WebSocketsServer ws(81);
uint32_t seq=0,session=0,roundId=0,totalRounds=0,limitMs=1500,lastBroadcast=0,nextAt=0,roundAt=0;
uint8_t targetNode=0;bool ready=false,active=false,waiting=false;
String sessionId,phase="idle",lastError="",lastCommand;
struct Event{uint32_t round;uint8_t node;Type type;uint32_t us;};
Event history[64];size_t eventCount=0;
String snapshot(){
 DynamicJsonDocument doc(16384);
 doc["v"]=1;doc["type"]="snapshot";doc["session_id"]=sessionId;doc["status"]=phase;doc["active"]=active;
 doc["round"]=roundId;doc["rounds"]=totalRounds;doc["limit_ms"]=limitMs;doc["target"]=targetNode;
 doc["hits"]=score.hits;doc["misses"]=score.misses;doc["early"]=score.early;doc["mean_us"]=score.meanUs();doc["error"]=lastError;
 JsonArray nodes=doc.createNestedArray("nodes");for(int i=0;i<2;i++)if(configuredMac(Nodes[i]))nodes.add(i+1);
 JsonArray list=doc.createNestedArray("events");
 for(size_t i=0;i<eventCount;i++){auto o=list.createNestedObject();o["id"]=sessionId+":"+String(i+1);o["round"]=history[i].round;o["node"]=history[i].node;o["kind"]=history[i].type==Type::Hit?"hit":history[i].type==Type::Miss?"miss":"early";o["reaction_us"]=history[i].us;}
 auto diag=doc.createNestedObject("diagnostics");diag["rx_dropped"]=uint32_t(radio.dropped);diag["invalid"]=radio.invalid;diag["send_errors"]=radio.sendErrors;
 String out;serializeJson(doc,out);return out;
}
Frame command(uint8_t node,Type type){Frame f;f.type=type;f.node=node;f.session=session;f.seq=nextSeq(seq);f.round=roundId;f.limit=limitMs;return f;}
void sendSnapshot(uint8_t client){String payload=snapshot();ws.sendTXT(client,payload);}
void broadcast(){String payload=snapshot();ws.broadcastTXT(payload);lastBroadcast=millis();}
void stop(const String& why){
 active=false;waiting=false;phase=why;
 for(int i=0;i<2;i++)if(configuredMac(Nodes[i])){pending[i]={};pending[i].begin(command(i+1,Type::Cancel));}
 broadcast();
}
void startRound(){
 if(roundId>=totalRounds){stop("completed");return;}
 uint8_t options[2];uint8_t count=0;for(int i=0;i<2;i++)if(configuredMac(Nodes[i]))options[count++]=i+1;
 if(!count){lastError="no configured peers";stop("interrupted");return;}
 targetNode=options[esp_random()%count];roundId++;roundAt=millis();waiting=true;
 // Inform every peer of the round, so non-target presses can be reported as Early.
 for(int i=0;i<2;i++)if(configuredMac(Nodes[i]))pending[i].begin(command(i+1,(i+1)==targetNode?Type::Activate:Type::Cancel));
 broadcast();
}
bool roundPeersAcknowledged(){for(auto& p:pending)if(p.active)return false;return true;}
void onCommand(uint8_t client,uint8_t* payload,size_t len){
 StaticJsonDocument<768> d;
 if(len>700||deserializeJson(d,payload,len)||d["v"]!=1||!d["id"].is<const char*>()||!d["command"].is<const char*>()){ws.sendTXT(client,"{\"type\":\"error\",\"error\":\"invalid command\"}");return;}
 String id=d["id"].as<String>(),cmd=d["command"].as<String>();
 if(id.length()<1||id.length()>64)return;
 if(id==lastCommand){sendSnapshot(client);return;}
 if(cmd=="status"){sendSnapshot(client);return;}
 if(cmd=="stop"){lastCommand=id;if(active)stop("cancelled");return;}
 if(cmd!="start"&&cmd!="manual")return;
 if(active){ws.sendTXT(client,"{\"type\":\"error\",\"error\":\"session already active\"}");return;}
 if(!d["rounds"].is<int>()||!d["limit_ms"].is<int>())return;
 int rounds=d["rounds"],limit=d["limit_ms"];
 if(rounds<1||rounds>50||limit<100||limit>10000)return;
 lastCommand=id;
 // UUID-shaped identifier from independent hardware RNG; no wall-clock dependency.
 uint32_t a=esp_random(),b=esp_random(),c=esp_random(),e=esp_random();
 char uuid[37];snprintf(uuid,sizeof(uuid),"%08lx-%04lx-4%03lx-8%03lx-%04lx%08lx",(unsigned long)a,(unsigned long)(b>>16),(unsigned long)(b&0xfff),(unsigned long)(c&0xfff),(unsigned long)(c>>16),(unsigned long)e);
 sessionId=uuid;session=esp_random();if(!session)session=1;
 roundId=0;totalRounds=cmd=="manual"?1:rounds;limitMs=limit;eventCount=0;score={};lastError="";phase=cmd=="manual"?"manual":"running";active=true;waiting=false;nextAt=millis();
 for(int i=0;i<2;i++){events[i]={};pending[i]={};}
 broadcast();
}
void setup(){
 Serial.begin(115200);WiFi.mode(WIFI_AP_STA);WiFi.disconnect();
 Serial.printf("REAKT gateway STATION MAC=%s\n",WiFi.macAddress().c_str());
 if(strlen(REAKT_AP_PASSWORD)<12||!configuredMac(Nodes[0])){Serial.println("BLOCKED: fill LocalConfig password and node1 station MAC");return;}
 if(configuredMac(Nodes[1])&&!memcmp(Nodes[0],Nodes[1],6)){Serial.println("duplicate peer MAC");return;}
 if(!WiFi.softAP("REAKT-MVP",REAKT_AP_PASSWORD,Channel)||!radio.begin()){Serial.println("AP/radio init failed");return;}
 for(int i=0;i<2;i++)if(configuredMac(Nodes[i])&&!radio.peer(Nodes[i],Channel)){Serial.println("peer registration failed");return;}
 ws.begin();ws.onEvent([](uint8_t client,WStype_t type,uint8_t* data,size_t len){if(type==WStype_CONNECTED)sendSnapshot(client);else if(type==WStype_TEXT)onCommand(client,data,len);});
 ready=true;Serial.printf("AP=%s WebSocket port 81; channel=%u\n",WiFi.softAPIP().toString().c_str(),Channel);
}
void loop(){
 if(!ready)return;ws.loop();Received rx;
 while(radio.pop(rx)){
  Frame f=rx.frame;int index=f.node-1;
  if(index<0||index>=2||!configuredMac(Nodes[index])||memcmp(rx.mac,Nodes[index],6)||f.session!=session)continue;
  if(f.type==Type::Ack){pending[index].ack(f);continue;}
  if(f.type!=Type::Hit&&f.type!=Type::Miss&&f.type!=Type::Early)continue;
  // ACK only syntactically/semantically acceptable events, even duplicates.
  if(f.round<1||f.round>totalRounds)continue;
  if(f.type==Type::Hit&&(f.value>=limitMs*1000u||f.value==0))continue;
  if(f.type!=Type::Hit&&f.value!=0)continue;
  Frame ack=f;ack.type=Type::Ack;ack.value=f.seq;ack.seq=nextSeq(seq);radio.send(Nodes[index],ack);
  if(!active||!events[index].accept(f.seq))continue;
  if(f.type==Type::Early){
   if(f.round>0 && f.round<=roundId && eventCount<64-totalRounds+roundId-(waiting?1:0)){
    score.add(f.type,0);history[eventCount++]={f.round,f.node,f.type,0};broadcast();
   }
   continue;
  }
  if(!waiting||f.round!=roundId||f.node!=targetNode)continue;
  pending[index].active=false;score.add(f.type,f.value);
  if(eventCount<64)history[eventCount++]={f.round,f.node,f.type,f.value};
  waiting=false;nextAt=millis()+500+(esp_random()%1000);broadcast();
 }
 for(int i=0;i<2;i++){
  if(pending[i].due(millis()))radio.send(Nodes[i],pending[i].frame);
  if(pending[i].failed){pending[i].failed=false;if(active){lastError="ESP-NOW ACK timeout";stop("interrupted");}}
 }
 if(active&&waiting&&uint32_t(millis()-roundAt)>limitMs+2500){lastError="node event timeout";stop("interrupted");}
 if(active&&!waiting&&roundPeersAcknowledged()&&int32_t(millis()-nextAt)>=0)startRound();
 if(uint32_t(millis()-lastBroadcast)>=1000){broadcast();Serial.printf("status=%s round=%lu hit=%lu miss=%lu rxdrop=%lu\n",phase.c_str(),(unsigned long)roundId,(unsigned long)score.hits,(unsigned long)score.misses,(unsigned long)radio.dropped);}
}
