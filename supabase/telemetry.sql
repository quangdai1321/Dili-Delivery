-- Dili Delivery: anonymous run stats (performance + where players struggle)
-- Run once: Dashboard → SQL Editor → New query → paste → Run. Safe to re-run.
-- Players can only INSERT rows; nobody can read them with the public key. You read them in the dashboard.
-- The game only sends stats when "Share anonymous stats" is ON in its Settings (default ON). No names, no personal data.

create table if not exists public.run_stats (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  device_id   uuid not null,            -- random id stored in the player's browser (same one the leaderboard uses)
  version     text,
  reason      text check (reason in ('time','quit','restart','abandon')),
  mode        text,                     -- normal / daily / challenge / retry
  touch       boolean,
  dpr         real,
  screen_w    int,
  screen_h    int,
  gfx         text,                     -- auto / high / saver
  motion      text,                     -- full / reduced
  ctrl        text,                     -- dpad / stick / keyboard
  avg_fps     real,
  low_fps     real,                     -- fps at the slowest 5% of frames
  res_scale   real,                     -- final render scale (1 = one canvas pixel per CSS pixel)
  duration    real,                     -- seconds of play
  zone        int,                      -- zone id reached (0..7)
  loop        int,
  deliveries  int,
  score       int,
  crashes     jsonb,                    -- {"car":3,"train":1,...}
  boss        text                      -- boss active when the run ended, if any
);
create index if not exists run_stats_time_idx on public.run_stats (created_at desc);

alter table public.run_stats enable row level security;
drop policy if exists "send stats" on public.run_stats;
create policy "send stats" on public.run_stats for insert to anon, authenticated with check (true);
grant insert on public.run_stats to anon, authenticated;
revoke select on public.run_stats from anon, authenticated;

-- light server-side guard: at most one row per device every 10 seconds
create or replace function public.run_stats_before_insert() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  new.created_at := now();
  if exists (select 1 from public.run_stats where device_id = new.device_id and created_at > now() - interval '10 seconds') then
    return null;  -- silently drop
  end if;
  return new;
end $$;
drop trigger if exists run_stats_before_insert on public.run_stats;
create trigger run_stats_before_insert before insert on public.run_stats
  for each row execute function public.run_stats_before_insert();

-- ---------------------------------------------------------------------------
-- Handy queries (run them in the SQL Editor):
--
-- Phones vs desktop performance, last 7 days
--   select touch, count(*) runs, round(avg(avg_fps)::numeric,1) avg_fps, round(avg(low_fps)::numeric,1) low_fps,
--          round(avg(res_scale)::numeric,2) res_scale
--   from run_stats where created_at > now() - interval '7 days' group by touch;
--
-- Which zone do runs end in?
--   select zone, count(*) from run_stats where reason = 'time' group by zone order by zone;
--
-- What hits players the most?
--   select key as cause, sum(value::int) hits from run_stats, jsonb_each_text(crashes) group by key order by hits desc;
--
-- Slowest setups (low fps on phones)
--   select screen_w, screen_h, dpr, gfx, round(avg(avg_fps)::numeric,1) fps, count(*)
--   from run_stats where touch group by 1,2,3,4 having count(*) >= 3 order by fps limit 20;
