# Dili Delivery — V3

Browser game for the Dlicom AI Game Jam. One HTML file plus `assets/` (Dili render and Dlicom logo for the menu). No build step, no backend. All music and sound effects are synthesized live with WebAudio.

## Run
Open `index.html` in a modern browser. (`index.v1.html` is the original prototype.)

**Install as an app:** the game is a PWA (`manifest.webmanifest` + `sw.js`). Chrome/Edge/Android show **📲 Install app** on the menu; on iPhone use Share → Add to Home Screen. Once loaded it also plays **offline**: the page is network-first (new deploys arrive on the next visit) and assets are cache-first.

## Gameplay
Each shift starts with 60 seconds.

1. Follow the **yellow dots** to the 📦 and pick it up. The order timer starts now.
2. Follow the **green dots** to the 🏠 and drop it off.
3. Dodge cars, scooters and roadworks.

| Rule | Effect |
|---|---|
| Delivered under par time | Bonus **x2**, +2s extra shift time |
| No crash during the order | Bonus **x3** |
| Consecutive deliveries | Combo +1 (+50 per combo level). Traffic gets faster as combo rises |
| Crash | Combo reset, −3s. Each extra crash on the same order costs 1s more (up to −6s) |
| Crash while carrying | The 📦 is knocked out of your hands and lands back in the road. Grab it again; the order clock keeps running |
| Close call (a car passes within a hair) | +25 points (+5 per combo level), brief slow-motion |
| Every delivery | +4s shift time (+3s from delivery 12, +2s from delivery 24) |
| Every 3 deliveries | Pick an upgrade: Speed, Dash, Shield, Magnet, +10s |
| Clearing a zone | +8s shift time |

From the Night District on, some cars are **road ragers** (red roof stripe). They honk, flash their lights and speed up when Dili is in their lane ahead of them.

### Daily Challenge
A 📅 **Daily #N** button on the menu (or press **D**). Everyone gets the same city layouts, the same orders and the same upgrade offers that day. Your best score and number of attempts are saved per day.

### Chasing your best
- The HUD shows **▲/▼ vs PB**: your score compared with your best run at the same moment.
- The game over screen tells you how close you came: "The package was 13m from the door", "Only 120 points short of your best", "1 delivery away from ❄️ SNOW PEAK", or how many seconds crashes cost you. It adds a short taunt based on what hit you.
- **Share** creates a score card image. On phones it opens the share sheet with the image attached. On desktop it opens a prefilled post on X and downloads the image for you to attach.

### Zones
| # | Zone | Reached after | Hazard |
|---|---|---|---|
| 1 | 🏙️ Downtown | start | Light traffic |
| 2 | 🐴 Country Village | 5 deliveries | **Animals** on dirt roads: 🐎 horses gallop in long straight runs (a kick knocks you back and costs 2s), 🐄 cows stop to graze in the way, 🐔 chickens slow you down. DASH hops past them |
| 3 | 🌃 Night District | 9 | Dark, alleys, 💢 road-rager cars |
| 4 | 🏜️ Desert Dunes | 13 | **Sand** slows Dili down; **sandstorms** blind you and push you sideways |
| 5 | ⛈️ Neon Storm | 17 | Rain, low visibility, lightning |
| 6 | ⚓ Sunset Harbor | 22 | **Trains**: signals flash red and a bell rings, then a train sweeps the track |
| 7 | 🏮 Night Market | 27 | **Crowds** wander the streets: bumping into people knocks you back, and cars stop for them |
| 8 | ❄️ Snow Peak | 33 | **Ice**: Dili slides. Snowfall, snowman roadblocks |
| 9 | 🌙 Moon Base | 39 | **Meteors** land on red target circles. Low gravity, floaty movement |
| ∞ | 🌙 Moon Base II, III… | every 8 more | +15% traffic, train and meteor speed per loop |

### 🎯 Zone goals
Every zone has its own side objective, shown at the top of the screen and on the zone card. Completing it pays +300 per zone (times the loop), +15 🪙 and +5s. The zone card shows whether you made it. Complete all 9 for the 🎯 Goal Getter achievement.

| Zone | Goal |
|---|---|
| 🏙️ Downtown | 3 clean deliveries (no crash) |
| 🐴 Country Village | 3 deliveries without bumping an animal |
| 🌃 Night District | 3 close calls with cars |
| 🏜️ Desert Dunes | 2 deliveries without touching sand |
| ⛈️ Neon Storm | 2 FAST deliveries |
| ⚓ Sunset Harbor | Grab 2 power-ups |
| 🏮 Night Market | 3 deliveries without bumping anyone |
| ❄️ Snow Peak | Jump 2 barriers with DASH |
| 🌙 Moon Base | Dodge 5 meteors up close |

### Zone bosses
The last delivery of every zone is a **💀 BOSS order**. Deliver it while the zone's boss hazard is active to defeat it (+500 per loop, +25 🪙, +6s):

| Zone | Boss |
|---|---|
| 🏙️ Downtown | 🚚 Monster Truck: chases you along the shortest path |
| 🐴 Country Village | 🐎 Stampede: a whole extra herd of faster horses |
| 🌃 Night District | 🌑 Blackout: near-darkness, every driver is a road rager |
| 🏜️ Desert Dunes | 🌪️ Mega Sandstorm: a sandstorm that never stops, strong wind |
| ⛈️ Neon Storm | ⚡ Thunderstorm: lightning strikes the glowing circles |
| ⚓ Sunset Harbor | 🚆 Train Rush: trains come back almost immediately |
| 🏮 Night Market | 🎆 Festival Crowd: three times the crowd |
| ❄️ Snow Peak | ☃️ Avalanche: giant snowballs drop where you're heading |
| 🌙 Moon Base | ☄️ Meteor Storm: meteors three times as often |

Achievements: 💀 Boss Slayer (first boss) and 👹 Boss Hunter (all 9, unlocks the BOSS HORNS hat).

### 🚧 Jump barriers
Low striped barriers block some alleys (the traffic-free shortcuts). Walk into one and you crash; **DASH to jump it** (+50 points, +1 🪙). Every dash is now a little hop.

### Power-ups
From the 2nd delivery a power-up appears on the road every ~12s (max 2, gone after 15s, seeded like the rest of the run): 🛡️ **Shield** (absorbs a crash), 🧲 **Magnet** (8s, 1.8x pickup range, pulls coin-shower coins), 🚀 **Turbo** (6s, +35% speed), 👻 **Ghost mode** (5s, pass through everything), ⏱️ **+5 seconds**. Active ones show as timers next to the coin counter.

### Order types (from the 4th delivery)
| Order | Rule | Reward |
|---|---|---|
| 🔥 Urgent | A countdown starts at pickup. Too late and the order is lost | x2 |
| 🥚 Fragile | One crash while carrying and it breaks | x2 |
| 👑 VIP | Much longer trip | x3 |
| 📦 2 Drops | One pickup, two doors, any order | Each door counts as a delivery |

### Random events (every ~25–35s)
🚓 **Police chase** (a cop follows the shortest path to you for 10s; escape for +150) · 🌫️ **Thick fog** (visibility shrinks around Dili; not in the already-dark zones) · 🌧️ **Flash rain** (slippery roads) · ⭐ **Happy hour** (all points x2) · 🚗 **Rush hour** (more, faster traffic) · 🪙 **Coin shower** (grab coins for the wardrobe)

### Dili Style (wardrobe) and achievements
Deliveries, close calls, zone clears and coin showers earn **🪙 coins**. Spend them in **🎨 Skins** on the menu (or press **K**):
- **Colors**: Classic blue, Sunny, Mint, and 😠 Grumpy Rose (frowns; unlocked by crashing 25 times)
- **Hats**: Delivery cap, Headphones, Party hat, 👑 Crown (reach Moon Base), 😇 Halo (10 clean deliveries in a row)
- **Dash trails**: Sparkles, Coin rain, 🔥 Fire (combo x15), 🌈 Rainbow (beat a friend's challenge)

13 achievements give coins and unlock the rare items. The equipped colour shows next to your name on the leaderboard.

### 📋 Daily missions
Three missions a day, the same for every player (picked from 12 by the date): deliveries, VIP orders, a boss, close calls, combos, coin showers, reaching Desert Dunes, clean streaks, escaping the police, special orders, dashes or the Daily Challenge. Progress adds up across runs; each mission pays 30–60 🪙 and finishing all three adds a +50 🪙 bonus. Open them from **📋 Missions** on the menu.

### 👻 Race your ghost
After a normal run, **👻 Race your ghost** (or press **G**) replays the **same city, orders and events** while a see-through Dili retraces your best run on that map. Beat it and your new run becomes the ghost. In the Daily Challenge, your best attempt of the day is the ghost automatically. Each order starts from the previous door, so a seed always produces the same chain of orders whatever route you take.

### 📸 Best moment
The game screenshots the best moment of every run a beat after it happens: 💀 a boss defeated, 🗺️ a new zone unlocked, 🔥 combo x10+, 🚓 a police escape or 👑 a VIP delivery (in that order of priority). The game over screen shows it as a polaroid, and **Share / Challenge** uses it as the picture on the score card and mentions it in the post text.

### Challenge a friend
Every run uses a random seed. **⚔️ Challenge** on the game over screen shares a link (`?c=…`). Whoever opens it plays the **same city, orders, upgrade offers and events** and sees "▼ 345 TO BEAT PHUC" on the HUD. The result appears on their game over screen.

Within each zone: 1 extra car joins every 2 deliveries, and traffic speeds up.
Between zones: a "Zone Clear" screen shows the next zone's hazard.
The menu shows which zones you have unlocked.

Personal Best (score, fastest delivery, best combo, furthest zone, best-run pace) and Daily Challenge results are saved in `localStorage` on this browser only.

## Settings
**⚙️** on the menu (top-right) or **Settings** in Pause:
- **Graphics**: Auto (adapts resolution to stay smooth) · High (always sharp) · Battery saver (lower resolution, fewer particles and ambient effects)
- **Screen effects**: Full · Reduced (no shake, zoom kicks, big flashes or speed lines)
- Music and sound effects separately, controls and vibration (phones), minimap, camera, and an FPS counter to include when you report lag

## Controls
- WASD / Arrow keys: move. Lane steering keeps Dili centred on the road: hold a direction early and Dili takes the next turn that way; diagonals and analog stick input follow the lane at full speed instead of grinding on corners
- Space / Shift: dash
- P / Esc or the ⏸ button (top-left of the map): pause. The pause menu has Resume, Restart, Quit, Fullscreen and Sound (keys: P/Esc, R, Q)
- D (menu): Daily Challenge · L (menu): leaderboard · K (menu): skins · S (game over): share / challenge
- M: sound on/off
- C: switch camera (close follow cam ↔ full map)
- F: fullscreen
- R: restart
- Mobile: a fixed **D-pad** in the bottom-left corner moves Dili (slide your thumb between arrows), **DASH** is the big button bottom-right, ⏸ top-left pauses. The first time you press START on a phone you pick **D-pad** or **Joystick**; switch any time with **Controls** on the menu (bottom-left) or in Pause. Both stay see-through until touched. The minimap is off by default on phones (Pause → Minimap). The phone vibrates on crashes and deliveries, and the screen stays awake during a run.

## Camera & rendering
- Full screen on any display: the height is fixed and the width follows the screen's aspect ratio (up to 2.4:1), so wide phones get a wider view of the city. Menus stay centred.
- Close camera zooms in and smoothly follows Dili, looking ahead in the direction of travel. A minimap and an edge arrow show where the target is.
- 3/4 perspective: buildings show their front walls and cast shadows, and cars have depth.
- Adaptive resolution: every 2s the game checks its frame time. After two slow checks in a row (under ~50fps) it renders fewer pixels (down to 0.6x), at most one step every 4s. It only steps back up between rounds (zone card, menus), never mid-play, so there is no back-and-forth stutter. Phones start at 1.5x. Long frames are sub-stepped so game speed stays real-time.
- Stutter-free effects: the UI layer uses 3 fixed sharpness tiers, and the map is never re-rendered mid-zone. Pop-up text (score pops, COMBO, banners) is rasterised once per size and reused while it animates. The delivery card is baked into a bitmap. Particles are capped at 160.
- Two layers: the world is drawn at the adaptive resolution while the HUD, text and pop-ups are drawn on a sharper layer, so text stays crisp even when a phone drops the world to 0.6x. Font: Nunito.
- The HUD is cached and only redrawn when a shown value changes. Roadworks and hurdles are baked into the map texture (only their blinking lights are drawn live), and each car type is a pre-rendered sprite.
- The world layer is only split off when the adaptive scaler lowers it; otherwise it draws straight to the screen. On very slow devices the UI layer drops to 1x as a last resort.
- Glows, darkness, sandstorm and warning vignettes are pre-rendered sprites, not per-frame gradients, and the map texture matches the real render scale.

## Audio & effects
- Everything is synthesized live with WebAudio: a master compressor and a generated reverb give the music and effects depth, with no audio files.
- Background music: a procedural loop for the menu and for each zone, with a cymbal at every phrase and a snare fill before the next. It speeds up and adds layers as your combo grows, goes to full intensity during a boss, and gets quieter while paused.- **Ambience per zone**, from looping filtered-noise beds, a drone and small one-shot details: city air and birds (Downtown), crickets (Night District), gusting wind that roars during sandstorms (Desert), rain (Neon Storm), waves and gulls with the odd ship horn (Harbor), crowd murmur and vendor chimes (Night Market), wind and wind chimes (Snow Peak), and a hum with station beeps (Moon Base).
- **Positional sound**: honks, trains, meteors, lightning and the police siren are panned left/right by where they are on screen and get quieter with distance. The nearest car has an engine hum that rises as it approaches, with a Doppler shift.
- **Footsteps** that match the surface: road, sand crunch, snow, soft moon steps.
- **Living mix**: the music "opens up" (low-pass filter) as the combo grows, is fully open during bosses, sounds muffled while paused, and ducks under crashes, deliveries, thunder and boss stingers.

- Effects: an iris opening at the start of a run, camera zoom kicks on deliveries, combos and boss wins, star sparkles on delivery, speed lines while dashing, a red pulse on crashes, a glowing screen edge on combo milestones, coins flying to the score, hit-stop, dizzy stars and zone weather.

## Online leaderboard (Supabase)
The menu has a 🏆 **Ranking** button (or press **L**) with two boards: **All-time** and **today's Daily**. Each player appears once, with their best score. At the end of a run the score is submitted automatically. The first time, the game asks for a name (2–16 characters). The game over screen then shows your rank, e.g. "Rank #4 of 57".

Three boards: **All-time**, **This week** (resets Monday 00:00 UTC) and **today's Daily**. The **top 3 of each week** receive the exclusive 🏆 **Champion Trophy** hat and 150 🪙 the next time they open the game.

Setup (one time):
1. Create a free project at [supabase.com](https://supabase.com).
2. Open **SQL Editor**, paste [`supabase/leaderboard.sql`](supabase/leaderboard.sql) and run it.
3. Also run [`supabase/leaderboard_v2.sql`](supabase/leaderboard_v2.sql) (new zones + skins).
   Then [`supabase/leaderboard_v3.sql`](supabase/leaderboard_v3.sql) (weekly board + last week's podium).
   Then [`supabase/leaderboard_v4.sql`](supabase/leaderboard_v4.sql) (hides players' device ids: the table becomes insert-only, reads go through the functions).
4. Open **Project Settings → API**. Copy the **Project URL** and the **anon / publishable** key into `SUPABASE_URL` and `SUPABASE_KEY` near the top of the script in `index.html`.

The anon key is designed to be public. Row Level Security only lets players read scores and add new ones. They cannot edit or delete anything. The database rejects impossible scores and allows at most one submission per device every 20 seconds. Scores are still reported by the browser, so a determined cheater could post a fake one: remove it in **Table Editor → scores**. Leave the two constants empty and the leaderboard stays hidden.

## Anonymous run stats
To see how the game really runs on players' devices, each finished run (time up, quit, restart or tab closed; at least 8s of play) sends one anonymous row: average and low FPS, render scale, graphics/motion/control settings, screen size, zone reached, deliveries, score, what caused each crash, and the active boss. No names or personal data. Players can turn it off in **Settings → Share anonymous stats**.

Setup: run [`supabase/telemetry.sql`](supabase/telemetry.sql) once in the Supabase SQL Editor. The table is insert-only for the public key; read it in the dashboard (the file ends with ready-made queries). Until the table exists the game silently skips sending.

## Play online
Hosted on Vercel: https://dili-delivery-seven.vercel.app/

## Next build
1. More zones and levels.
2. QA pass.
