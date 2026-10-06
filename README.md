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

Dili runs at 185 px/s (Speed upgrade: +12% per level, max 5). DASH recharges in 2.0s (−15% per Dash level).

### 🎓 First-run tutorial
A new player's first shift walks through 4 hands-on steps in a card at the bottom of the screen: **Move** (WASD/arrows, or the D-pad/joystick on phones) → **Pick up** the 📦 (yellow dots) → **Deliver** to the 🏠 (green dots, dodge cars) → **DASH** (SPACE, or the ⚡ button). Each step ticks ✓ the moment you do it, including a step you already did early. On phones a pulsing ring points at the D-pad and the DASH button. Finishing gives +10s and +20 🪙. The card turns see-through when Dili or the target is behind it. **SKIP ›** closes it for good. It shows by itself only on the very first run. Replay it any time with **Settings → 🎓 Tutorial → REPLAY** (from the menu), or open the game with `?tutorial` at the end of the URL (it shows once per page load, even for veterans).

From the Night District on, some cars are **road ragers** (red roof stripe). They honk, flash their lights and speed up when Dili is in their lane ahead of them.

### 🤝 Co-op (online, 2-4 players)
**🤝 CO-OP** on the menu (idea from @NaikwadiRe49999). Team scores have their own **🤝 CO-OP** tab in the ranking: the host submits the shift when it ends (best shift per team, names like ANN + BEN + CAT, your teams highlighted); this needs `supabase/leaderboard_v5_coop.sql`, and until it is run the tab just says it is not set up yet. Create a room, send the invite link (or the 4-letter code) to up to 3 friends, and deliver together in the same city (a 5th player is told the room is full):
- 2 to 4 Dilis, one shared shift clock, score, combo and order. Each player moves their own Dili locally, so controls feel exactly like solo.
- **Pass the package**: whoever carries it walks apart from a teammate and then touches them to hand it over (+50); with several teammates close by, the nearest one gets it. A package that was passed scores **x1.5 as a TEAM DELIVERY**. Either of you can pick up and deliver.
- Traffic, orders, zones, bosses, random events and upgrades follow the room's host; trains, meteors, animals and boss strikes hit each player on their own screen. A crash by either player costs the team time, and drops the package if that player held it.
- Teammates show with their skin and a name in their own colour (also their dot on the minimap); the host has a 👑 in the lobby, and the HUD says who has the package. Co-op never stops the shared world: pausing (or picking an upgrade) only parks your own Dili while traffic and the clock keep going, switching windows or apps doesn't auto-pause, and your friend sees "⏸ NAME is away". If one of you quits, the other keeps the shift going solo; both can start the next shift together from the lobby.
- Rooms survive reloads: the room code sits in the address bar (`?coop=CODE`), so reloading brings you back to the same room. Whoever is in a room with no host for a few seconds (or gets a knock while the old host is silent) takes over as host, and if two hosts meet, one steps down. Closing the tab tells your friend right away. **🔑 JOIN ANOTHER ROOM** switches to a friend's code.
- Co-op runs stay off the leaderboard and personal bests; coins still count for each player.
- Network: a Supabase Realtime **broadcast** room (`dili-coop-CODE`), straight over WebSocket with the publishable key; nothing is written to the database. Every message reaches everyone in the room, so bigger rooms send less often (host 7→5/s, others 10→5/s): about 17 messages/s delivered for 2 players, ~40 for 3 and ~60 for 4. The free Realtime quota (about 100 messages/s for the whole project, and a monthly cap) only fits a couple of busy rooms at once; a paid plan raises it. `?coopnet=local` swaps the network for a BroadcastChannel between two tabs (used by the tests).

### 💀 Boss Rush
A **💀 BOSS RUSH** button on the menu (between Daily and Ranking). You go straight into the boss of every zone, one after another: Monster Truck → Stampede → Blackout → … → Meteor Storm. Before each boss there is a **3-second breather** ("NEXT BOSS: 🐎 STAMPEDE · 3·2·1"). The clock stops and the boss order can't be picked up yet. Each boss takes 3 hits. Hits give +4s, a defeat +6s and the zone card +8s. When time runs out, the result is how many of the 11 bosses you took down, and your time for a full clear. The HUD shows `💀 BOSS RUSH 3/11`. There are no random events and no zone goals. Boss Rush keeps its own record (`BOSS RUSH BEST 7/11 bosses · FULL CLEAR 212.4s`). It never touches the leaderboard, your normal personal best, ghosts or zone unlocks. Sharing posts "I took down 7/11 bosses" with the game link (no challenge link).

### Daily Challenge
A 📅 **Daily #N** button on the menu (or press **D**). Everyone gets the same city layouts, the same orders and the same upgrade offers that day. Your best score and number of attempts are saved per day.

### Chasing your best
- The HUD shows **▲/▼ vs PB**: your score compared with your best run at the same moment.
- The game over screen tells you how close you came: "The package was 13m from the door", "Only 120 points short of your best", "1 delivery away from ❄️ SNOW PEAK", or how many seconds crashes cost you. It adds a short taunt based on what hit you.
- **Share** creates a score card image. On phones it opens the share sheet with the image attached. On desktop it opens a prefilled post on X and downloads the image for you to attach.

### 📱 Phones
- **Portrait screens** (including in-app browsers such as X's that never rotate): the landscape game is turned 90° to fill the whole screen, so you just turn the phone sideways. Touches are rotated back to game coordinates. When the browser itself rotates to landscape, the game switches back to the normal layout.
- **Touch controls are big by default**: the D-pad, joystick and DASH button scale with the screen (at least 1.15x, up to 1.8x on small or short screens), and the ⏸ button is bigger on touch.
- On-screen text is kept short: zone tips, goals, event and boss intros, and tutorial hints are one short line each.

### Zones
| # | Zone | Reached after | Hazard |
|---|---|---|---|
| 1 | 🏙️ Downtown | start | Light traffic |
| 2 | 🐴 Country Village | 5 deliveries | **Animals** on dirt roads: 🐎 horses gallop in long straight runs (a kick knocks you back and costs 2s), 🐄 cows stop to graze in the way, 🐔 chickens slow you down. DASH hops past them |
| 3 | 🌃 Night District | 9 | Dark, alleys, 💢 road-rager cars |
| 4 | 🏖️ Sunny Beach | 13 | Boardwalk, palms and gulls. 🦀 **Crabs** scuttle around: a pinch knocks you back and costs 1s |
| 5 | 🏜️ Desert Dunes | 17 | **Sand** slows Dili down; **sandstorms** blind you and push you sideways |
| 6 | 🐒 Jungle Trail | 21 | 🐒 **Monkeys steal your package!** The thief runs away from you (the path and arrow follow it). Catch it within 9s to get the package back (+3 🪙) or the order fails. DASH past monkeys to stay safe |
| 7 | ⛈️ Neon Storm | 25 | Rain, low visibility, lightning |
| 8 | ⚓ Sunset Harbor | 29 | **Trains**: signals flash red and a bell rings, then a train sweeps the track |
| 9 | 🏮 Night Market | 34 | **Crowds** wander the streets: bumping into people knocks you back, and cars stop for them |
| 10 | ❄️ Snow Peak | 39 | **Ice**: Dili slides. Snowfall, snowman roadblocks |
| 11 | 🌙 Moon Base | 45 | **Meteors** land on red target circles. Low gravity, floaty movement |
| ∞ | 🌙 Moon Base II, III… | every 8 more | +15% traffic, train and meteor speed per loop |

### 🎯 Zone goals
Every zone has its own side objective, shown at the top of the screen and on the zone card. Completing it pays +300 per zone (times the loop), +15 🪙 and +5s. The zone card shows whether you made it. Complete all 11 for the 🎯 Goal Getter achievement.

| Zone | Goal |
|---|---|
| 🏙️ Downtown | 3 clean deliveries (no crash) |
| 🐴 Country Village | 3 deliveries without bumping an animal |
| 🏖️ Sunny Beach | 3 deliveries without getting pinched |
| 🐒 Jungle Trail | Win back 2 stolen packages |
| 🌃 Night District | 3 close calls with cars |
| 🏜️ Desert Dunes | 2 deliveries without touching sand |
| ⛈️ Neon Storm | 2 FAST deliveries |
| ⚓ Sunset Harbor | Grab 2 power-ups |
| 🏮 Night Market | 3 deliveries without bumping anyone |
| ❄️ Snow Peak | Jump 2 barriers with DASH |
| 🌙 Moon Base | Dodge 5 meteors up close |

### Zone bosses
The last delivery of every zone is a **💀 BOSS fight**. The boss has an **HP bar: 3 hits** (4 from loop II). Every boss order you deliver is one hit (+300 × hit × loop, +3 🪙, +4s) and a new boss order appears. Hits don't count as deliveries, so the next zone isn't cut short. After each hit the boss gets **angrier**: the monster truck drives faster, strikes and meteors come more often, trains return sooner, the wind pushes harder, and herds and crowds grow. The HP bar shakes on a hit and glows on the **LAST HIT**. The final hit defeats it (+800 per loop, +30 🪙, +6s):

| Zone | Boss |
|---|---|
| 🏙️ Downtown | 🚚 Monster Truck: chases you along the shortest path |
| 🐴 Country Village | 🐎 Stampede: a whole extra herd of faster horses |
| 🏖️ Sunny Beach | 🦀 Crab Invasion: crabs everywhere |
| 🐒 Jungle Trail | 🐒 Monkey Gang: twice the thieves |
| 🌃 Night District | 🌑 Blackout: near-darkness, every driver is a road rager |
| 🏜️ Desert Dunes | 🌪️ Mega Sandstorm: a sandstorm that never stops, strong wind |
| ⛈️ Neon Storm | ⚡ Thunderstorm: lightning strikes the glowing circles |
| ⚓ Sunset Harbor | 🚆 Train Rush: trains come back almost immediately |
| 🏮 Night Market | 🎆 Festival Crowd: three times the crowd |
| ❄️ Snow Peak | ☃️ Avalanche: giant snowballs drop where you're heading |
| 🌙 Moon Base | ☄️ Meteor Storm: meteors three times as often |

Achievements: 💀 Boss Slayer (first boss) and 👹 Boss Hunter (all 11, unlocks the BOSS HORNS hat).

### 🚧 Jump barriers
Low striped barriers block some alleys (the traffic-free shortcuts). Walk into one and you crash; **DASH to jump it** (+50 points, +1 🪙). Every dash is now a little hop.

### Power-ups
From the 2nd delivery a power-up appears on the road every ~12s (max 2, gone after 15s, seeded like the rest of the run): ❤️ **Repair** (+1 shield and +3s, or +6s when shields are full), 💥 **Blast** (a shockwave: cars within ~3 tiles are wrecked for +50 and +1 🪙 each and come back 3–5s later. Animals and people are stunned and can be walked through, a monkey thief drops the package, the boss truck is stunned, incoming meteors vanish), 🧲 **Magnet** (8s, 1.8x pickup range, pulls coin-shower coins), 🚀 **Turbo** (6s, +35% speed), 👻 **Ghost mode** (5s, pass through everything), ⏱️ **+5 seconds**. Active ones show as timers next to the coin counter. The HUD always shows your **3 shield slots** (🛡️🛡️○), so you can see your "health" and when Repair refills it.

### Vehicles
Each zone has its own traffic: sedans, 🚕 taxis, 🚌 buses (long and slow), vans, 🏎️ sports cars (fast, racing stripes), 🍦 ice-cream trucks, 🚜 tractors in the Village, 🏖️ beach buggies and surf vans, jeeps with a spare wheel in the Desert, Jungle and Snow, and six-wheeled 🌙 rovers with solar panels on the Moon. Every model has its own size and speed and is drawn once into a cached sprite.

### Order types (from the 4th delivery)
| Order | Rule | Reward |
|---|---|---|
| 🔥 Urgent | A countdown starts at pickup. Too late and the order is lost | x2 |
| 🥚 Fragile | One crash while carrying and it breaks | x2 |
| 👑 VIP | Much longer trip | x3 |
| 📦 2 Drops | One pickup, two doors, any order | Each door counts as a delivery |

### 🤪 Funny orders (from the 4th delivery)
Player idea: more funny things to deliver. Some normal orders turn into:
- 🍦 **Ice cream** (x2): it melts, so there's a timer like an urgent order but a bit longer, and it drips as you run. Too slow: "IT MELTED!"
- 🎈 **Balloons** (x2): Dili holds a bunch of balloons and runs 12% faster, but one crash pops them all.
- 🐟 **Stinky fish** (x2): flies buzz around Dili, a little stink cloud follows you, and the customer is not thrilled ("ew 🤢 …thanks?").
- 🎁 **Mystery box**: it shakes in Dili's hands; at the door it turns out to be socks, 15 coins, +5s, a frog (+500) or, rarely, a diamond (+1,500).
They replace part of the plain orders using the same random draw, so pickup and drop spots of a Daily or a challenge stay the same.

### Random events (every ~25–35s)
🚓 **Police chase** (a cop follows the shortest path to you for 10s; escape for +150) · 🌫️ **Thick fog** (visibility shrinks around Dili; not in the already-dark zones) · 🌧️ **Flash rain** (slippery roads) · ⭐ **Happy hour** (all points x2) · 🚗 **Rush hour** (more, faster traffic) · 🪙 **Coin shower** (grab coins for the wardrobe) · 🪂 **Dlicom Airdrop** (9 Dlicom crates float down on parachutes: a shadow and ring show where each one lands. Catch them for +3 🪙, or +12 🪙 for a rare golden 🎁. They blink and vanish after 5s)

### 🔵 Dlicom around the city
Every map has 4 rooftop billboards with the Dlicom logo, baked into the map so they cost nothing per frame. Every package (the one to pick up, the one Dili carries, the airdrop crates) carries a Dlicom logo stamp, and the trains are Dlicom-blue with the logo on the engine.
The official account is one tap away (player feedback: highlight the official Dlicom logo): the DLICOM PRESENTS logo on the menu and the **𝕏 FOLLOW @DlicomApp** button open https://x.com/DlicomApp, the splash and the game over screen show @DlicomApp next to the logo, and every shared score post ends with `@DlicomApp #DlicomGameJam`.

### 💬 Chatter
- **Customers answer** when their package arrives: *"gm! ☀️"*, *"WAGMI 🚀"*, *"faster than my wallet tx 😂"*… Slow deliveries get grumpier replies, and VIPs have their own lines.
- **🔒 Encrypted messages** (1 in 5): the bubble scrambles, then decrypts only if the delivery was FAST (+2 🪙). A slow one shows *"decrypt failed 😵"*.
- **Dili talks** in a speech bubble that follows Dili: *"gm frens"* at the start, *"ngmi 😱"* on a close call, *"LFG!! 🚀"* on combos, *"rekt 😵"* on a crash, *"that's a rug pull 😤"* when a monkey steals the package, plus lines for low time, new zones, bosses and airdrops. At most one line every 5s, so the chatter never spams.
- Bubbles are drawn once into a small bitmap and reused, and they stay on screen near the edges. The lines use their own randomness, so seeded runs, ghosts and challenges are unaffected.

### Dili Style (wardrobe) and achievements
Deliveries, close calls, zone clears and coin showers earn **🪙 coins**. Spend them in **🎨 Skins** on the menu (or press **K**):
- **Colors**: Classic blue, Sunny, Mint, Lime, Coral, Sky, Sakura, Midnight, and 😠 Grumpy Rose (frowns; unlocked by crashing 25 times)
- **Patterns** (player feedback: more ways to make Dili your own): 🐯 Tiger stripes, 🐶 Dalmatian spots and 🌌 Starry Night, painted on the body, head and cape (600-800 🪙), and ⚽ **Number 7** (777 🪙): a red football shirt with green shoulders, gold trim and a 7 on the chest
- **Hats**: Delivery cap, Headphones, Party hat, 👑 Crown (reach Moon Base), 😇 Halo (10 clean deliveries in a row)
- **Dash trails**: Sparkles, Coin rain, 🔥 Fire (combo x15), 🌈 Rainbow (beat a friend's challenge)
- **🐾 Pets** trot behind Dili in every run, sit next to Dili on the menu, and cheer (bark, meow, squawk) on each delivery. Each has a small perk: 🐶 **Puppy** (300 🪙) starts every run with +1 🛡️ shield · 🐱 **Kitty** (450 🪙) +1 🪙 per delivery · 🦜 **Parrot** (600 🪙) +15% pickup and drop range · 🐰 **Bunny** (complete 10 daily missions) DASH recharges 20% faster. Premium pets glow with an aura and sparkles: ✨ 🦊 **Fox** (700 🪙) runs 8% faster · ✨ 🐼 **Panda** (900 🪙) crashes cost 1s less · ✨ 🦄 **Unicorn** (1,200 🪙) +2 🪙 per delivery, rainbow aura · 👑 🐉 **Dragon** (1,800 🪙, legendary) every run starts with +1 🛡️ and +5s

**Preview anything**: hover a card (mouse) and Dili tries it on in the preview, pets and dash trails included; tap something locked or too expensive and you still see it on Dili for a few seconds, next to the hint on how to get it. Buying asks first (player feedback: avoid accidental purchases): tapping an item you don't own opens a **BUY THIS?** dialog with the price and what you'll have left, while Dili tries the item on in the preview. CANCEL / Esc spends nothing, BUY / Enter buys it. Items you own are equipped with one tap.

13 achievements give coins and unlock the rare items. The equipped colour shows next to your name on the leaderboard.

### 🎯 Weekly challenge
Under the daily missions there is one bigger goal for the whole week, the same for every player (e.g. deliver 150 packages, defeat 8 zone bosses, 50 close calls, combo x20 in one run). Progress adds up across all your runs from Monday 00:00 UTC. The reward is a rare skin that can only be won this way, rotating week by week: 🌌 **Galaxy** (colour), 🧙 **Wizard Hat**, ✨ **Golden** (colour). If you already own that week's skin you get 300 🪙 instead. In the wardrobe the current week's item says 🎯 THIS WEEK.

### 📋 Daily missions
Three missions a day, the same for every player (picked from 12 by the date): deliveries, VIP orders, a boss, close calls, combos, coin showers, reaching Desert Dunes, clean streaks, escaping the police, special orders, dashes or the Daily Challenge. Progress adds up across runs; each mission pays 30–60 🪙 and finishing all three adds a +50 🪙 bonus. Open them from **📋 Missions** on the menu.
New missions (idea from @Masum4990): ⏱️ **Blitz** (5 deliveries in your first 3 minutes of a run without a crash) and **zone bosses** (defeat the Monster Truck in Downtown, the Stampede in Country Village or the Blackout in Night District; only that zone's boss counts). Completing 10 daily missions in total unlocks the 📋 **Mission Pro** award and a missions-only pet: 🐰 **Bunny** (DASH recharges 20% faster).

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

### Difficulty
Traffic, trains and meteors speed up within each zone as you deliver (up to +45% by the 10th delivery of a zone, more on later loops). After your first run everything starts 8% faster (player feedback: "make levels a little more difficult"); the very first run keeps the gentler pace.

### UI feel
Screens no longer cut: switching between menu, wardrobe, settings, lobby, pause, upgrade and game over crossfades the last frame of the old screen over the new one (0.25s; the snapshot is taken before a resolution switch can wipe the canvas). Buttons ease in and out of their hover size instead of jumping, and a press sends a soft ring out of the button with a light tap sound (and a short buzz on phones).

### 🏆 Leaderboard
A wide board (feedback: bigger, with more detail about each player): each row shows the rank (medals and tinted rows for the top 3), the player's Dili in their colour, name, the zone they reached (icon and name, with the loop), best combo, deliveries and score. The header counts how many players are ranked, and a card under the list shows your rank and best score even when you are outside the top 10. Opened from the game over screen, that card shows THIS RUN next to your BEST. **🏆 LIVE #N**: during a ranked run (normal or daily) the board is loaded once at the start, and a pill above the coin counter shows where your current score would place you, popping when you pass someone. Tabs: All-time · This week · Daily · 🤝 Co-op.

## Settings
**⚙️** on the menu (top-right) or **Settings** in Pause:
- **Menus are always sharp**: the menu, ranking, skins, missions and settings render at full device resolution (up to 3x on phones), even after a laggy run lowered the in-game resolution. The next run picks up the resolution it had settled on. The menu hero image is drawn with high-quality smoothing. Stars stay out of the buttons and stats column, the stat boxes are solid, the orbiting packages pass behind Dili, and the hint lines sit on a dark panel.
- **Touch buttons** (phones): VISIBLE (default, solid D-pad / joystick and DASH) · FADED (see-through) · HIDDEN (not drawn, but they still work where they are)
- **Graphics**: **High is the default** (always sharp; saves that were on Auto move to High once) · Auto (adapts resolution to stay smooth; if it bottoms out and the device is still slow, it also switches to the lighter effect set) · High (always sharp) · Battery saver (lower resolution, fewer particles and ambient effects)
- **Screen effects**: Full · Reduced (no shake, zoom kicks, big flashes or speed lines)
- Music and sound effects separately, controls and vibration (phones), minimap, camera, and an FPS counter to include when you report lag

## Controls
- WASD / Arrow keys: move. Lane steering keeps Dili centred on the road: hold a direction early and Dili takes the next turn that way; diagonals and analog stick input follow the lane at full speed instead of grinding on corners. At a junction where both directions of a held diagonal are open, Dili picks the turn once and sticks to it until leaving the tile. It used to re-decide every frame from the current velocity, which made Dili shake in place at 82% of junctions. A test drives every junction of every zone from both directions: Dili leaves each one within 1s (1.5s on ice)
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
- Lighter frames: numbers are formatted with one shared `Intl.NumberFormat` (`toLocaleString` built a new formatter on every call). Jungle Trail's shade is baked into the map instead of a full-screen darkness pass every frame (Jungle JS per frame: p95 11.3ms → 5.5ms).
- Less CPU per frame for slower phones: text widths are cached per font instead of re-measured every frame. The HUD re-bakes at most 20 times a second. Each footstep plays one pre-rendered buffer: the 10 surface/foot variants are rendered once with an OfflineAudioContext, where each step used to build 7 audio nodes.
- Pop-up text is drawn once per line at a resolution that covers every pop-in, wobble and camera zoom, then scaled or rotated as an image. Before, a line was re-rasterised at every new scale bucket, and every frame while the big announcements wobbled. The HUD re-bakes about 15–24 times a second instead of every frame during the dash cooldown and pulses. In a 2-minute phone soak, frames over 50ms dropped from 130 to 39 and average fps went from 53.7 to 57.2.
- Stutter-free effects: the UI layer uses 3 fixed sharpness tiers, and the map is never re-rendered mid-zone. Pop-up text (score pops, COMBO, banners) is rasterised once per size and reused while it animates. The delivery card is baked into a bitmap. Particles are capped at 160.
- Two layers: the world is drawn at the adaptive resolution while the HUD, text and pop-ups are drawn on a sharper layer, so text stays crisp even when a phone drops the world to 0.6x. Font: Nunito.
- The HUD is cached and only redrawn when a shown value changes. Roadworks and hurdles are baked into the map texture (only their blinking lights are drawn live), and each car type is a pre-rendered sprite.
- The world layer is only split off when the adaptive scaler lowers it; otherwise it draws straight to the screen. On very slow devices the UI layer drops to 1x as a last resort.
- Glows, darkness, sandstorm and warning vignettes are pre-rendered sprites, not per-frame gradients, and the map texture matches the real render scale.

## Audio & effects
- Everything is synthesized live with WebAudio: a master compressor and a generated reverb give the music and effects depth, with no audio files.
- **Lead melody**: every track has its own tune, two 16-step phrases generated from the track's seed and played AABB. The notes are chord tones of the current bar, so the melody follows the harmony. It gets louder and doubles an octave up as the combo heats up. CHILL plays a soft, slow version.
- Background music: a procedural loop for the menu and for each zone, with a cymbal at every phrase and a snare fill before the next. It speeds up and adds layers as your combo grows, goes to full intensity during a boss, and gets quieter while paused.
- **Ambience per zone**, from looping filtered-noise beds, a drone and small one-shot details: city air and birds (Downtown), crickets (Night District), gusting wind that roars during sandstorms (Desert), rain (Neon Storm), waves and gulls with the odd ship horn (Harbor), crowd murmur and vendor chimes (Night Market), wind and wind chimes (Snow Peak), and a hum with station beeps (Moon Base).
- **Positional sound**: honks, trains, meteors, lightning and the police siren are panned left/right by where they are on screen and get quieter with distance. The nearest car has an engine hum that rises as it approaches, with a Doppler shift.
- **More life in the effects**: every sound gets a small random pitch (±3%, the same for all its notes), so repeated pickups and coins do not sound robotic. A doorbell "ding-dong" rings from the house on each delivery, parcels rustle when picked up, fast cars passing within ~2 tiles whoosh by (panned), and crashes add a metal clank and glass tinkle. Each zone has its own room size: dry in the countryside, beach and desert, a big echo in the night market, neon city, jungle and on the Moon.
- **Warmer effects** (feedback: "the SFX could use more polish"): square and saw voices go through a low-pass that follows the note, so they keep their arcade character without the buzz, and every note fades out with a short tail instead of stopping dead. The hissiest layers (dash, close call, power-up, crash glass, victory) moved down into the body of the sound; stars, the timer tick and crabs use rounder waves. Measured on 25 effects, the share of energy above 4kHz dropped from -13dB to -26dB on average (dash -2 → -27dB, close call -1 → -18dB), with peaks still under -7dB.
- **Footsteps** that match the surface: road, village dirt, sand crunch, snow, soft moon steps. The audible part is a mid-range tap, so they come through on phone speakers too. Left and right steps sound slightly different. They can be turned off separately in Settings → Footsteps. Measured on the final mix: steps poke about 3.5dB above the music in ARCADE and more in CHILL, with no clipping. The master bus is at gain 1.0 (was 0.55, about 5dB quieter than needed); the loudest SFX pile-up peaks around −4dB after the compressor.
- **Music style** (Settings → Music): ARCADE (upbeat, speeds up with your combo) · CHILL 🌿 (calm lo-fi take on each zone's chords: soft pads, warm e-piano, a lazy arpeggio and a soft heartbeat kick; no hats or cymbals, warm and slow) · OFF. ARCADE hats and cymbals are short and soft, and the mix never opens past ~9kHz, so there is no constant "tss". A second pass after more "chizz" feedback: the snare is now a soft thump (no noise burst), the phrase cymbal is gone, the closed hat is a faint tick, the music never opens past ~6kHz in play, and the hissy part of every ambience bed plays at about a third of its old level through a 2.6kHz low-pass (another ~15dB less energy above 5kHz). The zone ambience (rain, crickets, wind) goes through a gentle low-pass and is quieter still in CHILL: measured energy above 5kHz dropped by about 20dB in the night and rain zones.
- **Living mix**: the music "opens up" (low-pass filter) as the combo grows, is fully open during bosses, sounds muffled while paused, and ducks under crashes, deliveries, thunder and boss stingers.

- Effects: an iris opening at the start of a run, camera zoom kicks on deliveries, combos and boss wins, star sparkles on delivery, speed lines while dashing, a red pulse on crashes, a glowing screen edge on combo milestones, coins flying to the score, hit-stop, dizzy stars and zone weather.

## Online leaderboard (Supabase)
The menu has a 🏆 **Ranking** button (or press **L**) with two boards: **All-time** and **today's Daily**. Each player appears once, with their best score. The same name played on two devices (phone + PC) is merged in the game, which fetches the top 30 and keeps each name's highest row. At the end of a run the score is submitted automatically. The first time, the game asks for a name (2–16 characters). The game over screen then shows your rank, e.g. "Rank #4 of 57".

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
