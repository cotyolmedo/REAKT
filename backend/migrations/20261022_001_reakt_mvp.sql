-- CONDITIONALLY AUTHORIZED 2026-10-22: inspect project first; apply only if no conflicts.
-- All statements run in one transaction. Existing REAKT tables cause a safe failure.
begin;
create table public.reakt_sessions (
 id uuid primary key,
 user_id uuid not null references auth.users(id),
 status text not null check (status in ('completed','cancelled','interrupted')),
 rounds integer not null check (rounds between 1 and 50),
 limit_ms integer not null check (limit_ms between 100 and 10000),
 captured_at timestamptz not null,
 received_at timestamptz not null default now(),
 unique (id,user_id)
);
create table public.reakt_results (
 session_id uuid primary key,
 user_id uuid not null,
 hits integer not null check (hits between 0 and 50),
 misses integer not null check (misses between 0 and 50),
 early integer not null check (early between 0 and 64),
 mean_us integer not null check (mean_us between 0 and 10000000),
 check (hits + misses <= 50),
 foreign key (session_id,user_id) references public.reakt_sessions(id,user_id)
);
create table public.reakt_events (
 id text primary key check (length(id) between 38 and 100),
 session_id uuid not null,
 user_id uuid not null,
 round integer not null check (round between 1 and 50),
 node integer not null check (node between 1 and 2),
 kind text not null check (kind in ('hit','miss','early')),
 reaction_us integer not null check (reaction_us between 0 and 10000000),
 check (kind = 'hit' or reaction_us = 0),
 foreign key (session_id,user_id) references public.reakt_sessions(id,user_id)
);
create index reakt_sessions_user_time on public.reakt_sessions(user_id,captured_at desc);
create index reakt_events_session on public.reakt_events(session_id);
alter table public.reakt_sessions enable row level security;
alter table public.reakt_results enable row level security;
alter table public.reakt_events enable row level security;
revoke all on public.reakt_sessions, public.reakt_results, public.reakt_events from anon;
revoke all on public.reakt_sessions, public.reakt_results, public.reakt_events from authenticated;
grant select,insert,update on public.reakt_sessions, public.reakt_results, public.reakt_events to authenticated;
create policy reakt_sessions_select on public.reakt_sessions for select to authenticated using ((select auth.uid()) = user_id);
create policy reakt_sessions_insert on public.reakt_sessions for insert to authenticated with check ((select auth.uid()) = user_id);
create policy reakt_sessions_update on public.reakt_sessions for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy reakt_results_select on public.reakt_results for select to authenticated using ((select auth.uid()) = user_id);
create policy reakt_results_insert on public.reakt_results for insert to authenticated with check ((select auth.uid()) = user_id);
create policy reakt_results_update on public.reakt_results for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy reakt_events_select on public.reakt_events for select to authenticated using ((select auth.uid()) = user_id);
create policy reakt_events_insert on public.reakt_events for insert to authenticated with check ((select auth.uid()) = user_id);
create policy reakt_events_update on public.reakt_events for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
commit;
