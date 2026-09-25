-- Dili Delivery leaderboard v4: stop exposing players' device ids.
-- Run once after leaderboard.sql, _v2 and _v3: Dashboard → SQL Editor → New query → paste → Run. Safe to re-run.
--
-- Before this, anyone could `GET /rest/v1/scores?select=device_id,name` with the public key, then post scores
-- under another player's device id. The game never reads the table directly (it only inserts and calls the
-- functions below), so we remove direct reads and let the functions read the table with their owner's rights.

drop policy if exists "read scores" on public.scores;
revoke select on public.scores from anon, authenticated;

-- the functions only return names, scores and an is_me flag (never device ids); search_path is already pinned to ''
alter function public.get_leaderboard(text, int, int, uuid) security definer;
alter function public.get_my_rank(text, int, uuid) security definer;
alter function public.last_week_rank(uuid) security definer;

-- quick check (should return rows): select * from public.get_leaderboard('all', null, 5, null);
