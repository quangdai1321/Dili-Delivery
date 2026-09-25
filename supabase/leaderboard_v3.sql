-- Dili Delivery leaderboard v3: weekly board + last week's podium (Champion Trophy hat).
-- Run once after leaderboard.sql and leaderboard_v2.sql: Dashboard → SQL Editor → New query → paste → Run. Safe to re-run.
-- Weeks start Monday 00:00 UTC. The weekly board is built from normal ('all') runs; no new column needed.

create index if not exists scores_all_time_idx on public.scores (mode, created_at desc, score desc);

-- p_mode: 'all' | 'daily' (with p_day) | 'week'
drop function if exists public.get_leaderboard(text, int, int, uuid);
create function public.get_leaderboard(p_mode text, p_day int default null, p_limit int default 10, p_device uuid default null)
returns table (rank bigint, name text, score int, deliveries int, combo int, zone int, loop int, skin text, is_me boolean)
language sql stable set search_path = '' as $$
  with pool as (
    select s.* from public.scores s
    where (p_mode = 'week' and s.mode = 'all' and s.created_at >= date_trunc('week', now()))
       or (p_mode <> 'week' and s.mode = p_mode and s.day is not distinct from p_day)
  ), best as (
    select distinct on (p.device_id) p.* from pool p order by p.device_id, p.score desc, p.created_at
  )
  select rank() over (order by b.score desc), b.name, b.score, b.deliveries, b.combo, b.zone, b.loop, b.skin,
         b.device_id = p_device
  from best b
  order by b.score desc, b.created_at
  limit least(greatest(p_limit, 1), 50);
$$;

drop function if exists public.get_my_rank(text, int, uuid);
create function public.get_my_rank(p_mode text, p_day int, p_device uuid)
returns table (rank bigint, total bigint, score int)
language sql stable set search_path = '' as $$
  with best as (
    select s.device_id, max(s.score) as score from public.scores s
    where (p_mode = 'week' and s.mode = 'all' and s.created_at >= date_trunc('week', now()))
       or (p_mode <> 'week' and s.mode = p_mode and s.day is not distinct from p_day)
    group by s.device_id
  )
  select (select count(*) + 1 from best b2 where b2.score > me.score), (select count(*) from best), me.score
  from best me where me.device_id = p_device;
$$;

-- where did this device finish LAST week? (null if it didn't play). week_start identifies the week for the client.
create or replace function public.last_week_rank(p_device uuid)
returns table (rank bigint, total bigint, week_start date)
language sql stable set search_path = '' as $$
  with best as (
    select s.device_id, max(s.score) as score from public.scores s
    where s.mode = 'all'
      and s.created_at >= date_trunc('week', now()) - interval '7 days'
      and s.created_at <  date_trunc('week', now())
    group by s.device_id
  )
  select (select count(*) + 1 from best b2 where b2.score > me.score), (select count(*) from best),
         (date_trunc('week', now()) - interval '7 days')::date
  from best me where me.device_id = p_device;
$$;

grant execute on function public.get_leaderboard(text, int, int, uuid) to anon, authenticated;
grant execute on function public.get_my_rank(text, int, uuid) to anon, authenticated;
grant execute on function public.last_week_rank(uuid) to anon, authenticated;
