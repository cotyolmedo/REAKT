#include "ReaktCore.h"
#include <cassert>
#include <iostream>
using namespace reakt;
// Deterministic fault-injection simulation of the production protocol components.
// Not an ESP-NOW radio test or an execution of the Arduino loop functions.
int main(){
 for(uint32_t session=1;session<=10;session++){
  Score score;Dedup commandWindow,eventWindow;uint32_t commandSeq=0,eventSeq=0;
  for(uint32_t round=1;round<=10;round++){
   Frame cmd;cmd.type=Type::Activate;cmd.node=1;cmd.session=session;cmd.seq=nextSeq(commandSeq);cmd.round=round;cmd.limit=1000;
   Pending command;assert(command.begin(cmd));assert(command.due(0)); // first packet lost
   assert(command.due(120));uint8_t bytes[WireSize];encode(command.frame,bytes);Frame received;assert(decode(bytes,WireSize,received));
   Target target;assert(commandWindow.accept(received.seq));target.activate(received,120000);
   Frame ack=received;ack.type=Type::Ack;ack.seq=nextSeq(eventSeq);ack.value=received.seq;
   // First ACK lost; resend command. Duplicate must not move stimulus clock.
   assert(command.due(240));assert(!commandWindow.accept(received.seq));assert(target.started==120000);
   assert(command.ack(ack));
   Frame event=received;event.seq=nextSeq(eventSeq);uint32_t reaction=0;
   if(round%2){event.type=target.press(370000,reaction);event.value=reaction;assert(event.type==Type::Hit);}
   else {assert(target.expired(1120000));event.type=target.press(1120000,reaction);event.value=0;assert(event.type==Type::Miss);}
   Pending outgoing;assert(outgoing.begin(event));assert(outgoing.due(400)); // first event lost
   assert(outgoing.due(520));encode(outgoing.frame,bytes);assert(decode(bytes,WireSize,received));
   assert(eventWindow.accept(received.seq));score.add(received.type,received.value);
   Frame eventAck=received;eventAck.type=Type::Ack;eventAck.value=received.seq;eventAck.seq=nextSeq(commandSeq);
   // Lost ACK produces duplicate event; no score change.
   assert(outgoing.due(640));assert(!eventWindow.accept(received.seq));assert(outgoing.ack(eventAck));
   eventAck.session++;assert(!outgoing.ack(eventAck));
  }
  assert(score.hits==5&&score.misses==5&&score.meanUs()==250000);
 }
 std::cout<<"PASS 10 simulated sessions x 10 rounds with lost commands/events/ACKs and duplicates\n";
}
