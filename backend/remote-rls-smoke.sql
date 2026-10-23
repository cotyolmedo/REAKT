-- Run as database administrator after setting reakt.test_user_id to a real,
-- confirmed Auth user's UUID on the same connection. No credentials are needed.
-- Rows are synthetic and all writes are rolled back, including on a test error.
begin;
select set_config('request.jwt.claim.sub', (
  select id::text from auth.users
  where id = current_setting('reakt.test_user_id')::uuid
    and email_confirmed_at is not null
), true);
select set_config('reakt.test_session', gen_random_uuid()::text, true);
select set_config('reakt.other_identity', gen_random_uuid()::text, true);
set local role authenticated;
do $$
declare
  s uuid := current_setting('reakt.test_session')::uuid;
  u uuid := auth.uid();
begin
  if u is null then raise exception 'A confirmed test user is required'; end if;
  insert into public.reakt_sessions(id,user_id,status,rounds,limit_ms,captured_at)
  values(s,u,'cancelled',1,1000,now());
  insert into public.reakt_sessions(id,user_id,status,rounds,limit_ms,captured_at)
  values(s,u,'cancelled',1,1000,now()) on conflict(id) do update set status=excluded.status;
  if (select count(*) from public.reakt_sessions where id=s) <> 1 then
    raise exception 'Idempotent session upsert failed'; end if;
  insert into public.reakt_results values(s,u,0,0,0,0)
    on conflict(session_id) do update set hits=excluded.hits;
  insert into public.reakt_events values(s::text||':1',s,u,1,1,'early',0)
    on conflict(id) do update set reaction_us=excluded.reaction_us;
  if not exists(select 1 from public.reakt_results where session_id=s) or
     not exists(select 1 from public.reakt_events where session_id=s) then
    raise exception 'Child write/read failed'; end if;
  begin
    update public.reakt_sessions set rounds=51 where id=s;
    raise exception 'Invalid rounds were accepted';
  exception when check_violation then null; end;
  begin
    update public.reakt_sessions set user_id=current_setting('reakt.other_identity')::uuid where id=s;
    raise exception 'Owner reassignment was accepted';
  exception when insufficient_privilege then null; end;
  begin
    delete from public.reakt_sessions where id=s;
    raise exception 'Client DELETE was accepted';
  exception when insufficient_privilege then null; end;
end $$;
-- Different JWT subject only; this is not a second real Auth login.
select set_config('request.jwt.claim.sub',current_setting('reakt.other_identity'),true);
do $$
declare s uuid := current_setting('reakt.test_session')::uuid;
begin
  if exists(select 1 from public.reakt_sessions where id=s) or
     exists(select 1 from public.reakt_results where session_id=s) or
     exists(select 1 from public.reakt_events where session_id=s) then
    raise exception 'Other identity can read owner data'; end if;
  update public.reakt_sessions set status='interrupted' where id=s;
  if found then raise exception 'Other identity updated owner data'; end if;
  begin
    insert into public.reakt_results values(s,auth.uid(),0,0,0,0)
      on conflict(session_id) do update set hits=excluded.hits;
    raise exception 'Other identity upsert was accepted';
  exception when insufficient_privilege or foreign_key_violation then null; end;
end $$;
reset role;
set local role anon;
do $$
begin
  begin
    perform 1 from public.reakt_sessions;
    raise exception 'Anonymous SELECT was accepted';
  exception when insufficient_privilege then null; end;
end $$;
reset role;
select 'RLS smoke assertions passed; synthetic writes will be rolled back' as result;
rollback;
