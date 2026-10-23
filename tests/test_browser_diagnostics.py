import asyncio
from functools import partial
import http.server
from pathlib import Path
import sys
import threading
import websockets
from playwright.async_api import async_playwright
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from mock_gateway import MockGateway

async def main():
 root=Path(__file__).resolve().parents[1]
 http_server=http.server.ThreadingHTTPServer(('127.0.0.1',0),partial(http.server.SimpleHTTPRequestHandler,directory=str(root/'tools/web-diagnostics')))
 threading.Thread(target=http_server.serve_forever,daemon=True).start()
 gateway=MockGateway()
 try:
  async with websockets.serve(gateway.handle,'127.0.0.1',0) as server:
   async with async_playwright() as p:
    browser=await p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox'])
    page=await browser.new_page();errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
    await page.goto(f'http://127.0.0.1:{http_server.server_port}/')
    await page.locator('#url').fill(f'ws://127.0.0.1:{server.sockets[0].getsockname()[1]}')
    await page.locator('#connect').click()
    await page.wait_for_function("!document.querySelector('#manual').disabled")
    await page.locator('#manual').click()
    await page.wait_for_function("document.querySelector('#state').textContent.includes('completed')")
    assert 'Aciertos 1' in await page.locator('#score').inner_text()
    assert await page.evaluate("JSON.parse(localStorage.getItem('reakt-bank-history')).length")==1
    async with page.expect_download() as info:await page.locator('#export').click()
    assert (await info.value).suggested_filename=='reakt-banco-evidencia.json'
    await page.reload();assert '1 sesiones' in await page.locator('#history').inner_text()
    assert not errors,errors
    await browser.close()
    print('PASS browser/WebSocket manual round, metrics, durable history, JSON export; no JS errors')
 finally:
  if gateway.task:gateway.task.cancel()
  http_server.shutdown();http_server.server_close()

if __name__=='__main__':asyncio.run(main())
