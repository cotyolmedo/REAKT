import {readFile} from 'node:fs/promises';
const config = JSON.parse(await readFile(new URL('../app/supabase-public.json', import.meta.url)));
if (config.SUPABASE_URL !== 'https://hvaoezcsgqepcttaznof.supabase.co') throw Error('Unexpected project');
const headers = {apikey: config.SUPABASE_ANON_KEY};
const settings = await fetch(config.SUPABASE_URL + '/auth/v1/settings', {headers, signal: AbortSignal.timeout(20000)});
if (!settings.ok) throw Error('Auth settings HTTP ' + settings.status);
console.log('Auth endpoint: HTTP 200');
for (const table of ['reakt_sessions', 'reakt_results', 'reakt_events']) {
  const response = await fetch(config.SUPABASE_URL + '/rest/v1/' + table + '?select=*&limit=1', {headers, signal: AbortSignal.timeout(20000)});
  if (![401, 403].includes(response.status)) throw Error(table + ': expected anonymous denial, got HTTP ' + response.status);
  console.log(table + ': anonymous denied (HTTP ' + response.status + ')');
}
