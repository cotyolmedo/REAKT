"""Execute proposed migration against isolated PostgreSQL; never contact Supabase."""
import pathlib
import tempfile
import unittest
import pgserver
import psycopg

ROOT = pathlib.Path(__file__).resolve().parents[1]
A = '00000000-0000-4000-8000-000000000001'
B = '00000000-0000-4000-8000-000000000002'
S = '10000000-0000-4000-8000-000000000001'

class BackendTest(unittest.TestCase):
 @classmethod
 def setUpClass(cls):
  cls.tmp=tempfile.TemporaryDirectory(prefix='reakt-postgres-')
  cls.server=pgserver.get_server(pathlib.Path(cls.tmp.name)/'data',cleanup_mode='stop')
  cls.db=psycopg.connect(cls.server.get_uri(),autocommit=True)
  cls.db.execute('create role anon; create role authenticated; create schema auth; create table auth.users(id uuid primary key)')
  cls.db.execute("create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$")
  cls.db.execute('grant usage on schema public,auth to anon,authenticated; grant execute on function auth.uid() to anon,authenticated')
  cls.db.execute('insert into auth.users values (%s),(%s)',(A,B))
  cls.db.execute((ROOT/'backend/migrations/20261022_001_reakt_mvp.sql').read_text())
 @classmethod
 def tearDownClass(cls):
  cls.db.close();cls.server.cleanup();cls.tmp.cleanup()
 def setUp(self):
  self.db.execute('reset role')
  self.db.execute('truncate public.reakt_events,public.reakt_results,public.reakt_sessions')
  self.as_user(A)
 def as_user(self,uid):
  self.db.execute('reset role');self.db.execute('set role authenticated')
  self.db.execute("select set_config('request.jwt.claim.sub',%s,false)",(uid,))
 def session(self,owner=A):
  self.db.execute("insert into public.reakt_sessions (id,user_id,status,rounds,limit_ms,captured_at) values (%s,%s,'completed',10,1500,now()) on conflict(id) do update set status=excluded.status",(S,owner))
 def test_owner_idempotent_upsert(self):
  self.session();self.session()
  self.assertEqual(self.db.execute('select count(*) from public.reakt_sessions').fetchone()[0],1)
 def test_other_user_cannot_read(self):
  self.session();self.as_user(B)
  self.assertEqual(self.db.execute('select count(*) from public.reakt_sessions').fetchone()[0],0)
 def test_other_user_cannot_insert_as_owner(self):
  self.as_user(B)
  with self.assertRaises(psycopg.errors.InsufficientPrivilege):self.session(A)
 def test_other_user_cannot_overwrite(self):
  self.session();self.as_user(B)
  with self.assertRaises(psycopg.errors.InsufficientPrivilege):self.session(B)
 def test_owner_cannot_reassign(self):
  self.session()
  with self.assertRaises(psycopg.errors.InsufficientPrivilege):self.db.execute('update public.reakt_sessions set user_id=%s',(B,))
 def test_anon_denied(self):
  self.session();self.db.execute('reset role');self.db.execute('set role anon')
  with self.assertRaises(psycopg.errors.InsufficientPrivilege):self.db.execute('select * from public.reakt_sessions')
 def test_no_client_delete(self):
  self.session()
  with self.assertRaises(psycopg.errors.InsufficientPrivilege):self.db.execute('delete from public.reakt_sessions')
 def test_child_requires_owned_parent(self):
  self.session();self.as_user(B)
  with self.assertRaises(psycopg.errors.ForeignKeyViolation):
   self.db.execute('insert into public.reakt_results values (%s,%s,1,0,0,100)',(S,B))
 def test_result_and_event_roundtrip(self):
  self.session()
  self.db.execute('insert into public.reakt_results values (%s,%s,1,0,0,100)',(S,A))
  self.db.execute("insert into public.reakt_events values (%s,%s,%s,1,1,'hit',100)",(S+':1',S,A))
  self.assertEqual(self.db.execute('select reaction_us from public.reakt_events').fetchone()[0],100)
  self.as_user(B)
  for table in ['reakt_results','reakt_events']:
   self.assertEqual(self.db.execute('select count(*) from public.'+table).fetchone()[0],0)
 def test_readonly_inspection(self):
  self.session()
  self.db.execute((ROOT/'backend/inspect-readonly.sql').read_text())
  self.assertEqual(self.db.execute('select count(*) from public.reakt_sessions').fetchone()[0],1)
 def test_invalid_rounds_rejected(self):
  self.session()
  with self.assertRaises(psycopg.errors.CheckViolation):self.db.execute('update public.reakt_sessions set rounds=51')

if __name__=='__main__':unittest.main(verbosity=2)
