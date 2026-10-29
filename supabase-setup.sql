create table if not exists public.words (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade default auth.uid(),
  english text not null,
  spanish text not null,
  meaning text not null,
  notes text not null default '',
  created_at timestamptz not null default now()
);

alter table public.words enable row level security;

grant select, insert, update, delete on public.words to authenticated;

drop policy if exists "Users can view their own words" on public.words;
create policy "Users can view their own words"
  on public.words for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert their own words" on public.words;
create policy "Users can insert their own words"
  on public.words for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own words" on public.words;
create policy "Users can update their own words"
  on public.words for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own words" on public.words;
create policy "Users can delete their own words"
  on public.words for delete
  to authenticated
  using ((select auth.uid()) = user_id);
