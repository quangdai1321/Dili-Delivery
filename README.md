# Dili Delivery — V3

Browser game for the Dlicom AI Game Jam. One HTML file plus `assets/` (Dili render and Dlicom logo for the menu). No build step, no backend. All music and sound effects are synthesized live with WebAudio.

## Run
Open `index.html` in a modern browser. (`index.v1.html` is the original prototype.)

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
| Crash | Combo reset, −3s |
| Every delivery | +4s shift time |
| Every 3 deliveries | Pick an upgrade: Speed, Dash, Shield, Magnet, +10s |

| Clearing a zone | +8s shift time |

### Zones
| # | Zone | Reached after | Hazard |
|---|---|---|---|
| 1 | 🏙️ Downtown | start | Light traffic |
| 2 | 🌃 Night District | 5 deliveries | Dark, alleys, more traffic |
| 3 | ⛈️ Neon Storm | 10 | Rain, low visibility, lightning |
| 4 | ⚓ Sunset Harbor | 16 | **Trains**: signals flash red and a bell rings, then a train sweeps the track |
| 5 | ❄️ Snow Peak | 23 | **Ice**: Dili slides. Snowfall, snowman roadblocks |
| 6 | 🌙 Moon Base | 31 | **Meteors** land on red target circles. Low gravity, floaty movement |
| ∞ | 🌙 Moon Base II, III… | every 8 more | +15% traffic, train and meteor speed per loop |

Within each zone: 1 extra car joins every 2 deliveries, and traffic speeds up.
Between zones: a "Zone Clear" screen shows the next zone's hazard.
The menu shows which zones you have unlocked.

Personal Best (score, fastest delivery, best combo, furthest zone) is saved in `localStorage` on this browser only.

## Controls
- WASD / Arrow keys: move
- Space / Shift: dash
- P / Esc: pause
- M: sound on/off
- C: switch camera (close follow cam ↔ full map)
- R: restart
- Mobile: drag on the left side to move, tap the right side to dash

## Camera & rendering
- Close camera zooms in and smoothly follows Dili, looking ahead in the direction of travel. A minimap and an edge arrow show where the target is.
- 3/4 perspective: buildings show their front walls and cast shadows, and cars have depth.
- Renders at the device pixel ratio for sharp visuals. Resolution lowers automatically if the device can't hold ~45fps, and long frames are sub-stepped so game speed stays real-time.

## Audio & effects
- Background music: separate procedural loops for the menu and each of the 6 zones, getting a little faster on every endless loop. It speeds up and adds layers (lead melody, extra drums) as your combo grows, and gets quieter while paused or picking upgrades.
- Effects: coins fly to the score, shockwave on delivery, result-card stars pop in one by one, combo milestone pop-ups (x3/x5/x10…), glowing combo aura, dash afterimages, dizzy stars after a crash, hit-stop, red vignette when time is low, drifting cloud shadows (Downtown), fireflies (Night) and rain splashes with lightning (Storm).

## Next build
1. Mobile polish (3/10).
2. QA pass (4/10).
