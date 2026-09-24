-- Dili Delivery online leaderboard
-- Run once in Supabase: Dashboard → SQL Editor → New query → paste → Run.
-- Safe to re-run.

create table if not exists public.scores (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  device_id   uuid not null,                       -- random id stored in the player's browser
  name        text not null check (char_length(name) between 2 and 16),
  mode        text not null check (mode in ('all', 'daily')),
  day         int,                                 -- yyyymmdd for daily runs, null otherwise
  score       int not null check (score between 1 and 5000000),
  deliveries  int not null check (deliveries between 1 and 1000),
  combo       int not null default 0 check (combo between 0 and 1000),
  zone        int not null default 0 check (zone between 0 and 5),
  loop        int not null default 0 check (loop between 0 and 100),
  check ((mode = 'daily') = (day is not null)),
  -- sanity cap: a delivery is worth at most a few thousand points
  check (score <= deliveries * 8000 + 50000)
);
create index if not exists scores_board_idx on public.scores (mode, day, score desc);
create index if not exists scores_device_idx on public.scores (device_id, created_at desc);

-- Row Level Security: anyone may read and add scores; nobody may edit or delete them from the client.
alter table public.scores enable row level security;
drop policy if exists "read scores" on public.scores;
create policy "read scores" on public.scores for select to anon, authenticated using (true);
drop policy if exists "submit scores" on public.scores;
create policy "submit scores" on public.scores for insert to anon, authenticated with check (true);
grant select, insert on public.scores to anon, authenticated;

-- Server-side clean-up and rate limit: one score per device every 20 seconds (a shift lasts 60s+).
create or replace function public.scores_before_insert() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  new.created_at := now();
  new.name := btrim(regexp_replace(new.name, '\s+', ' ', 'g'));
  if char_length(new.name) < 2 then raise exception 'name too short'; end if;
  if exists (select 1 from public.scores
             where device_id = new.device_id and created_at > now() - interval '20 seconds') then
    raise exception 'too many submissions, slow down';
  end if;
  return new;
end $$;
drop trigger if exists scores_before_insert on public.scores;
create trigger scores_before_insert before insert on public.scores
  for each row execute function public.scores_before_insert();

-- Top N: each device's best score for a board ('all' or 'daily' + day).
create or replace function public.get_leaderboard(p_mode text, p_day int default null, p_limit int default 10, p_device uuid default null)
returns table (rank bigint, name text, score int, deliveries int, combo int, zone int, loop int, is_me boolean)
language sql stable set search_path = '' as $$
  with best as (
    select distinct on (s.device_id) s.*
    from public.scores s
    where s.mode = p_mode and s.day is not distinct from p_day
    order by s.device_id, s.score desc, s.created_at
  )
  select rank() over (order by b.score desc), b.name, b.score, b.deliveries, b.combo, b.zone, b.loop,
         b.device_id = p_device
  from best b
  order by b.score desc, b.created_at
  limit least(greatest(p_limit, 1), 50);
$$;

-- The caller's own rank on a board.
create or replace function public.get_my_rank(p_mode text, p_day int, p_device uuid)
returns table (rank bigint, total bigint, score int)
language sql stable set search_path = '' as $$
  with best as (
    select s.device_id, max(s.score) as score
    from public.scores s
    where s.mode = p_mode and s.day is not distinct from p_day
    group by s.device_id
  )
  select (select count(*) + 1 from best b2 where b2.score > me.score),
         (select count(*) from best),
         me.score
  from best me
  where me.device_id = p_device;
$$;

grant execute on function public.get_leaderboard(text, int, int, uuid) to anon, authenticated;
grant execute on function public.get_my_rank(text, int, uuid) to anon, authenticated;
