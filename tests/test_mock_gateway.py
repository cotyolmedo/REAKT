import asyncio
import json
import sys
import unittest
from pathlib import Path
import websockets
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from mock_gateway import MockGateway

class GatewayContractTest(unittest.IsolatedAsyncioTestCase):
 async def asyncSetUp(self):
  self.gateway=MockGateway()
  self.server=await websockets.serve(self.gateway.handle,'127.0.0.1',0)
  self.uri='ws://127.0.0.1:'+str(self.server.sockets[0].getsockname()[1])
 async def asyncTearDown(self):
  if self.gateway.task:self.gateway.task.cancel()
  self.server.close();await self.server.wait_closed()
 async def test_complete_and_reconnect(self):
  async with websockets.connect(self.uri) as ws:
   self.assertEqual(json.loads(await ws.recv())['status'],'idle')
   await ws.send(json.dumps({'v':1,'id':'test1','command':'start','rounds':2,'limit_ms':1500}))
   while True:
    snapshot=json.loads(await asyncio.wait_for(ws.recv(),2))
    if snapshot['status']=='completed':break
   self.assertEqual(snapshot['hits'],2);self.assertEqual(len(snapshot['events']),2)
   self.assertEqual(len({e['id'] for e in snapshot['events']}),2)
  async with websockets.connect(self.uri) as ws:
   recovered=json.loads(await ws.recv());self.assertEqual(recovered,snapshot)
   await ws.send(json.dumps({'v':1,'id':'test1','command':'start','rounds':2,'limit_ms':1500}))
   self.assertEqual(json.loads(await ws.recv())['session_id'],snapshot['session_id'])
 async def test_reject_range_and_cancel(self):
  async with websockets.connect(self.uri) as ws:
   await ws.recv()
   await ws.send(json.dumps({'v':1,'id':'bad','command':'start','rounds':51,'limit_ms':1500}))
   self.assertEqual(json.loads(await ws.recv())['type'],'error')
   await ws.send(json.dumps({'v':1,'id':'start','command':'start','rounds':50,'limit_ms':1500}))
   await ws.recv()
   await ws.send(json.dumps({'v':1,'id':'stop','command':'stop'}))
   while True:
    state=json.loads(await asyncio.wait_for(ws.recv(),2))
    if state['status']=='cancelled':break
   self.assertFalse(state['active'])
if __name__=='__main__':unittest.main(verbosity=2)
