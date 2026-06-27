create table if not exists public.launch_subscribers (
  id bigint generated always as identity primary key,
  email text not null unique,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.launch_subscribers enable row level security;

drop policy if exists "public can join launch subscribers" on public.launch_subscribers;
create policy "public can join launch subscribers"
on public.launch_subscribers
for insert
to anon, authenticated
with check (
  email is not null
  and length(trim(email)) >= 5
);

-- Optional next step:
-- Attach your welcome-email automation or Edge Function to new rows in
-- public.launch_subscribers so each signup receives the ClutchRP welcome email
-- and future launch-update broadcasts.
