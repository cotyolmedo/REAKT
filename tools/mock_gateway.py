#!/usr/bin/env python3
"""Software-only WebSocket fixture. Never represents physical ESP32 measurements."""
import argparse
import asyncio
import json
import uuid
import websockets

class MockGateway:
 def __init__(self):
  self.clients=set();self.task=None;self.last_command=None
  self.state={'v':1,'type':'snapshot','session_id':'','status':'idle','active':False,
   'round':0,'rounds':0,'limit_ms':1500,'target':0,'hits':0,'misses':0,'early':0,
   'mean_us':0,'events':[],'nodes':[1], 'error':'SIMULACIÓN: no hardware',
   'diagnostics':{'simulated':True}}
 async def publish(self):
  if self.clients:await asyncio.gather(*(c.send(json.dumps(self.state)) for c in list(self.clients)),return_exceptions=True)
 async def rounds(self):
  try:
   for i in range(1,self.state['rounds']+1):
    self.state.update(round=i,target=1);await self.publish();await asyncio.sleep(.1)
    self.state['events'].append({'id':self.state['session_id']+':'+str(i),'round':i,'node':1,'kind':'hit','reaction_us':250000})
    self.state['hits']=i;self.state['mean_us']=250000;await self.publish()
   self.state.update(status='completed',active=False);await self.publish()
  except asyncio.CancelledError:pass
 async def handle(self,client):
  self.clients.add(client)
  try:
   await client.send(json.dumps(self.state))
   async for raw in client:
    try:
     cmd=json.loads(raw)
     if cmd.get('v')!=1 or not isinstance(cmd.get('id'),str):raise ValueError('invalid contract')
     name=cmd.get('command')
     if cmd['id']==self.last_command or name=='status':await client.send(json.dumps(self.state));continue
     if name=='stop':
      self.last_command=cmd['id']
      if self.task:self.task.cancel()
      self.state.update(status='cancelled',active=False);await self.publish()
     elif name in ('start','manual'):
      if self.state['active']:raise ValueError('session already active')
      rounds=cmd.get('rounds');limit=cmd.get('limit_ms')
      if type(rounds)!=int or not 1<=rounds<=50 or type(limit)!=int or not 100<=limit<=10000:raise ValueError('invalid range')
      self.last_command=cmd['id']
      self.state.update(session_id=str(uuid.uuid4()),status='running',active=True,round=0,
       rounds=1 if name=='manual' else rounds,limit_ms=limit,hits=0,misses=0,early=0,mean_us=0,events=[])
      self.task=asyncio.create_task(self.rounds())
     else:raise ValueError('unknown command')
    except (ValueError,TypeError) as e:await client.send(json.dumps({'type':'error','error':str(e)}))
  finally:self.clients.discard(client)
 async def heartbeat(self):
  while True:await asyncio.sleep(1);await self.publish()

async def serve(host,port):
 gateway=MockGateway()
 async with websockets.serve(gateway.handle,host,port,max_size=32768):
  print(f'Mock gateway listening on {host}:{port}; SIMULATION ONLY',flush=True)
  await gateway.heartbeat()
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--host',default='127.0.0.1');p.add_argument('--port',type=int,default=8765);a=p.parse_args()
 asyncio.run(serve(a.host,a.port))
