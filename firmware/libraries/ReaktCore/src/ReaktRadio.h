#pragma once
#include <Arduino.h>
#include <WiFi.h>
#include <esp_now.h>
#include <esp_wifi.h>
#include <esp_arduino_version.h>
#include "ReaktCore.h"
namespace reakt {
struct Received { uint8_t mac[6]; Frame frame; };
class Radio {
 struct Raw {uint8_t mac[6],data[WireSize];};
 Raw queue[16]; volatile uint8_t head=0,tail=0;
 portMUX_TYPE mux=portMUX_INITIALIZER_UNLOCKED;
 static Radio* instance;
 void receive(const uint8_t* mac,const uint8_t* data,int len) {
  if(!mac||!data||len!=int(WireSize)) return;
  portENTER_CRITICAL(&mux);
  uint8_t next=(head+1)%16;
  if(next!=tail){memcpy(queue[head].mac,mac,6);memcpy(queue[head].data,data,WireSize);head=next;}else dropped++;
  portEXIT_CRITICAL(&mux);
 }
 public:
 volatile uint32_t dropped=0;uint32_t invalid=0,sendErrors=0;
 bool begin(){
  instance=this;
  if(esp_now_init()!=ESP_OK)return false;
#if ESP_ARDUINO_VERSION_MAJOR >= 3
  esp_now_register_recv_cb([](const esp_now_recv_info_t* info,const uint8_t* data,int len){if(info)instance->receive(info->src_addr,data,len);});
#else
  esp_now_register_recv_cb([](const uint8_t* mac,const uint8_t* data,int len){instance->receive(mac,data,len);});
#endif
  return true;
 }
 bool peer(const uint8_t* mac,uint8_t channel){
  if(esp_now_is_peer_exist(mac))return true;
  esp_now_peer_info_t p={};memcpy(p.peer_addr,mac,6);p.channel=channel;p.ifidx=WIFI_IF_STA;p.encrypt=false;
  return esp_now_add_peer(&p)==ESP_OK;
 }
 bool pop(Received& out){
  // Bound work per call; malformed traffic must not grow the call stack.
  for(uint8_t count=0;count<15;count++){
   Raw raw;
   portENTER_CRITICAL(&mux);
   if(head==tail){portEXIT_CRITICAL(&mux);return false;}
   raw=queue[tail];tail=(tail+1)%16;portEXIT_CRITICAL(&mux);
   if(!decode(raw.data,WireSize,out.frame)){invalid++;continue;}
   memcpy(out.mac,raw.mac,6);return true;
  }
  return false;
 }
 bool send(const uint8_t* mac,const Frame& f){uint8_t b[WireSize];encode(f,b);bool ok=esp_now_send(mac,b,WireSize)==ESP_OK;if(!ok)sendErrors++;return ok;}
};
inline bool configuredMac(const uint8_t* mac){uint8_t any=0;for(int i=0;i<6;i++)any|=mac[i];return any && !(mac[0]&1);}
}
