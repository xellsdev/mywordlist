alter table public.words
  add column if not exists known boolean not null default false;
