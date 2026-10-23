import http from 'node:http';
import {readFile} from 'node:fs/promises';
const root = new URL('../../', import.meta.url);
const server = http.createServer(async (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('Content-Security-Policy', "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; connect-src 'self' https://hvaoezcsgqepcttaznof.supabase.co; frame-ancestors 'none'");
  try {
    if (req.method !== 'GET') { res.writeHead(405).end(); return; }
    if (req.url === '/config') {
      res.setHeader('Content-Type', 'application/json');
      res.end(await readFile(new URL('app/supabase-public.json', root)));
    } else if (req.url === '/') {
      res.setHeader('Content-Type', 'text/html; charset=utf-8');
      res.end(await readFile(new URL('./index.html', import.meta.url)));
    } else res.writeHead(404).end();
  } catch { res.writeHead(503).end('Configuración pública local no disponible.'); }
});
server.listen(8766, '127.0.0.1', () => console.log('Auth local: http://127.0.0.1:8766 — contraseña solo en navegador; servidor no recibe credenciales.'));
