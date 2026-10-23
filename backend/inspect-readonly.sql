-- Run in the SQL editor of the verified reakt project. Metadata only; no credentials or user rows.
begin read only;
select current_database() as database_name, version() as postgres_version;
select table_name, column_name, data_type, is_nullable
from information_schema.columns where table_schema='public'
order by table_name, ordinal_position;
select schemaname, tablename, rowsecurity from pg_tables
where schemaname='public' order by tablename;
select schemaname, tablename, policyname, roles, cmd, qual, with_check
from pg_policies where schemaname='public' order by tablename, policyname;
select table_name, grantee, privilege_type from information_schema.role_table_grants
where table_schema='public' and grantee in ('anon','authenticated','PUBLIC')
order by table_name, grantee, privilege_type;
select to_regclass('public.reakt_sessions') as sessions,
       to_regclass('public.reakt_results') as results,
       to_regclass('public.reakt_events') as events,
       to_regclass('supabase_migrations.schema_migrations') as migration_history;
rollback;
