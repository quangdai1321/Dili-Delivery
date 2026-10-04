-- Dili Delivery leaderboard v5: a separate board for co-op teams (2-4 players).
-- Run once after the earlier leaderboard files: Dashboard → SQL Editor → New query → paste → Run. Safe to re-run.
--
-- The room's host submits one row per finished co-op shift. No device ids are stored: a team is its names,
-- and run_id is a random id the host shares with the team so each player can spot their own runs.
-- Like the solo board, the table can only be written (insert) by the game and read through the function.

create table if not exists public.coop_scores (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  run_id      uuid not null unique,
  names       text not null check (char_length(names) between 2 and 80),
  players     int not null check (players between 2 and 4),
  score       int not null check (score between 1 and 5000000),
  deliveries  int not null check (deliveries between 1 and 1000),
  combo       int not null default 0 check (combo between 0 and 1000),
  zone        int not null default 0 check (zone between 0 and 15),
  loop        int not null default 0 check (loop between 0 and 100),
  -- sanity cap: team deliveries score x1.5, so the cap is a bit higher than solo
  check (score <= deliveries * 12000 + 50000)
);
create index if not exists coop_scores_board_idx on public.coop_scores (score desc);
create index if not exists coop_scores_week_idx on public.coop_scores (created_at desc, score desc);

alter table public.coop_scores enable row level security;
drop policy if exists "submit coop scores" on public.coop_scores;
create policy "submit coop scores" on public.coop_scores for insert to anon, authenticated with check (true);
revoke select on public.coop_scores from anon, authenticated;
grant insert on public.coop_scores to anon, authenticated;

-- p_mode: 'all' (all time) | 'week' (since Monday 00:00 UTC). One row per team (same names, any order of shifts).
drop function if exists public.get_coop_board(text, int);
create function public.get_coop_board(p_mode text default 'all', p_limit int default 10)
returns table (rank bigint, names text, players int, score int, deliveries int, combo int, zone int, loop int, run_id uuid)
language sql stable security definer set search_path = '' as $$
  with pool as (
    select c.* from public.coop_scores c
    where p_mode <> 'week' or c.created_at >= date_trunc('week', now())
  ), best as (
    select distinct on (lower(p.names)) p.* from pool p order by lower(p.names), p.score desc, p.created_at
  )
  select rank() over (order by b.score desc), b.names, b.players, b.score, b.deliveries, b.combo, b.zone, b.loop, b.run_id
  from best b
  order by b.score desc, b.created_at
  limit least(greatest(p_limit, 1), 50);
$$;
grant execute on function public.get_coop_board(text, int) to anon, authenticated;

-- quick check (empty until the first co-op shift is submitted): select * from public.get_coop_board('all', 5);
