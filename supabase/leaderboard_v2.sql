-- Dili Delivery leaderboard v2: new zones (ids 6 = Desert Dunes, 7 = Night Market) and the player's Dili skin.
-- Run once after leaderboard.sql: Dashboard → SQL Editor → New query → paste → Run. Safe to re-run.
-- Until this runs, the game still submits scores (it retries without the skin, with the zone capped at 5).

alter table public.scores add column if not exists skin text check (skin is null or char_length(skin) <= 24);

alter table public.scores drop constraint if exists scores_zone_check;
alter table public.scores add constraint scores_zone_check check (zone between 0 and 15);

-- same as v1, plus the skin column in the result (return type changes, so drop first)
drop function if exists public.get_leaderboard(text, int, int, uuid);
create function public.get_leaderboard(p_mode text, p_day int default null, p_limit int default 10, p_device uuid default null)
returns table (rank bigint, name text, score int, deliveries int, combo int, zone int, loop int, skin text, is_me boolean)
language sql stable set search_path = '' as $$
  with best as (
    select distinct on (s.device_id) s.*
    from public.scores s
    where s.mode = p_mode and s.day is not distinct from p_day
    order by s.device_id, s.score desc, s.created_at
  )
  select rank() over (order by b.score desc), b.name, b.score, b.deliveries, b.combo, b.zone, b.loop, b.skin,
         b.device_id = p_device
  from best b
  order by b.score desc, b.created_at
  limit least(greatest(p_limit, 1), 50);
$$;
grant execute on function public.get_leaderboard(text, int, int, uuid) to anon, authenticated;
