# Techniques

Sizes in the source diagram recipes are diagram pixels on 44 px cards; multiply
by about 1.4 for 110 to 124 px cards in a 1080p frame. Psychopomp implements
these in `crates/psychopomp/src/stage.rs` (`packet`, `StageActor`) and
`crates/psychopomp-render/src/render/stage.rs`. The larger HDR Stage uses the
restrained calibration immediately below.

## Current Stage calibration

- **Packet travel:** `smootherstep(t) = 6t⁵ − 15t⁴ + 10t³`; peak speed is 1.875
  times the average, versus cubic in-out's 3. Velocity and acceleration meet the
  hold continuously. Invert it monotonically to compute trail crossing times.
  Use `StageActor::glide` (or a `Move::Glide` camera shot) between resting
  compositions; use spring retargeting when an interruption must retain momentum.
- **Camera:** zero-bounce springs (`Move::Spring`), usually 1.0–1.8 seconds
  (opening dolly 2.2–2.6). Retain quintic glides for precisely timed resting
  moves; compare the same framing before choosing the feel. Write shots with
  the `CameraRig` (`stage.camera()`): `establish` (start 300–400 px back),
  `frame` with 140–170 px padding for a group (about 430 for one card held
  near 2×), `follow` a packet on a 0.6–0.8 s catch, `focus_on` with
  `aperture` 0.4–1.0, `orbit` 0.3–0.6 rad on a 3+ s glide, `dolly_zoom` about
  500 px on a 2.4 s glide at an impact (give it near and far depth cues to
  stretch), a 0.6 s `whip`, `handheld` near 1 only on quiet beats, and a
  slow glide `push_in` or tight `frame` on the resolution.
- **Orb contact:** intersect the packet path with the visible shell, invert its
  travel curve for contact age, then send a geodesic wave at 3.6 rad/s. A 25 ms
  attack and 480 ms exponential decay drive local light; a short 120 ms contact
  dimple gives it weight. A hemisphere-masked continuous trace connects the lit
  particles. Ports and the overall outline remain stable.
- **Rigid panels:** scale 1.035 → 1, spring duration 0.6 / bounce 0.12; y 16 → 0,
  duration 0.55 / bounce 0.16. Opacity 180 ms, blur 3 → 0 over 300 ms. Content
  follows after 65 ms on its own 0.36 / zero-bounce spring. No entrance flash.
  (`StageActor::settle_in`; `SpringPlan::PANEL` and `CONTENT` name these feels.)
- **Contact:** surge peak 0.45; cable bow 10 px, builds over 90 ms then settles
  on a 0.42 / bounce 0.28 spring. Brief flow establishes the connection, then
  returns to stillness.
- **Connections:** no default frame sweep. Fixed-size sockets resolve over 300 ms
  with smootherstep, then the wire draws on `cubic-bezier(.45, 0, .2, 1)` and
  holds quietly. Circular targets need an opaque silhouette: extend the wire
  beneath it, depth-sort packets behind it, and fade packet labels before entry.
  Measured packet labels stop short of connected bodies (`fit_between_ports`).
- **Hero entrance:** scale 0.58 → 1 on a 0.85 s / 0.2-bounce spring, blur 11 → 0
  on its own 0.7 s zero-bounce spring, angular offset −1.8 → 0 radians over
  1.25 s cubic-out (`StageActor::orb_in(.., OrbEntrance::HERO)`). Never animate
  a multiplier of absolute time for spin.
- **Material:** card flashes lift ink and rim without tinting the substrate.
  An overhead key gives the neutral rim depth; local packet reflections and
  socket floods supply color. Orb pulses only change illumination, never radius.
- **Staging:** finer, slower orb particles; small camera excursions; no standing
  neon halos. Reduce the per-primitive light sources before reducing global bloom:
  turning down bloom alone does not remove emissive halos authored into primitives.

## Hype register

For deliberately over-the-top films (see `scenes/psychopomp-intro`), keep the
quiet rules for the sweet beats and let the loud ones escalate:

- **Build:** ramp `camera.quake` linearly between shouted words (0.45 → 1.0 →
  1.5 → 2.0) under a riser that ends on the peak word; jolts still add on top.
- **Slam:** shouted text scales 1.7 → 1 on a 0.3 s / 0.3-bounce spring with a
  jolt, a 0.14 `post.zoom` streak, chroma, and a short 0.4 `post.flash`.
- **Cut to silence:** a full `post.flash` on the peak hides setting the quake to
  0 and fading everything but the hero; the sweet line lands in the stillness.

## Procedural destruction

Research foundations: [Quilez, domain warping](https://iquilezles.org/articles/warp/)
for organic density, and [GPU Gems 3, chapter 30](https://developer.nvidia.com/gpugems/gpugems3/part-v-physics-simulation/chapter-30-real-time-simulation-and-rendering-3d-fluids)
for volume rendering. Psychopomp uses an analytic procedural appearance rather
than the chapter's frame-integrated fluid simulation, preserving arbitrary-time
sampling and rewind.

- **One age:** −1 intact; 0 begins; 5.2 seconds gone. Compress the shell for
  120 ms, then release it decisively. Reverse age for the rewind.
  Preserve the intact material and occlusion at age zero. A 55 ms ignition
  handoff avoids switching every particle's size and brightness on one frame.
- **Volume:** raymarch a bounded expanding, rising density field. Low-frequency
  lobes establish silhouette; domain-warped four-octave noise sculpts folds and
  fissures. Front-to-back Beer-Lambert absorption makes cool smoke obscure the
  hot interior. Fixed quadrature avoids temporal noise crawl.
- **Bounds:** give density compact support before ray/culling bounds, or the volume
  develops straight-cut lobes. Keep the quad large enough for late smoke lift.
- **Temperature:** a brief white-yellow ignition, orange fissures, red embers,
  then nonemissive smoke. Vary heat spatially: a uniformly emissive sphere loses
  structure under highlight rolloff. Keep dark folds between bright regions.
  Cast local reflections on nearby rims; far edges and card bodies remain dark.
- **Pressure:** an inward screen-space pinch, then an expanding bipolar radial
  displacement of the existing image. Add very little ring emission; a large
  bright donut competes with the combustion.
- **Debris:** closed-form constant gravity plus linear drag; distribute speed,
  cooling, and lifetime with stable seeds. Short trails on a subset of embers
  communicate speed while most remain small points. Never accumulate positions
  from previous frames.
- **Review:** inspect 40 ms contact strips, fire-to-smoke transition, late fade,
  and reverse reconstruction. Verify labels after JSON round-trip too: centered
  text that silently reloads left-aligned destroys visual grouping.

## Source-diagram recipes

## Send

One clock per packet: `age` in seconds since dispatch, and its flight time.

| Phase | Duration | Behavior |
|---|---|---|
| Gather | 340 ms, `g = cubicOut(age / 0.34)` | Dot radius `4g`, opacity `g^1.5`. A soft disc shrinks `4 + 14(1 − g)` px onto the port at opacity `0.5 sin(πg)`. The reflection ramps up as `g^1.5`. |
| Flight | per route (0.4 to 1.6 s) | Minimum-jerk quintic by arc length. A solid near-white dot of radius 4, with no halo. |
| Landing | 720 ms, `q = time / 0.72` | See the ring. The reflection fades as `(1 − q)²`. |

- **Ring** (the dot becomes the ring): `opening = smoothstep(q / 0.24)`, fully
  open at 173 ms. Radius `2 + 2·opening + 9.1·(1 − (1 − q)²)`, stroke `4 → 1.5`,
  opacity `(1 − 0.734·opening)·(1 − q)^2.52`. A 2 px ring with a 4 px stroke
  looks exactly like the dot, so the handoff is seamless. It is a splash, not a
  shockwave.
- **Trail**: each point dims with the time since the dot crossed it:
  `heat = 0.7·(1 − since / cooling)^1.7`, with cooling 240 ms to 1.1 s.
  It is long mid-flight, short near the ends, and keeps cooling after landing.
  Stroke 1.6 px against a 1 px wire.
- **Reflection** (the border lighting up as the dot approaches): lights only the
  borders of nearby frames, never fills. Radius 80 px, strength 0.6, falloff
  through 1, 0.65, 0.16, 0 at 0, 0.3, 0.7, 1 of the radius.
- **Ember** (where it left): 2.2 s. Radius `0.1 + 0.7√t` of a 210 px size, core
  `0.6·0.26·min(t / 0.04, 1)·(1 − t)^0.9`, falling off as `(1 − r / R)^2.4`.
- **Flood** (where it arrived): 1.2 s. Travel `1 − (1 − t)^4`, width
  `0.07 + 0.6·√travel` of the card size, fade `e^(−0.9t)·(1 − smoothstep((t − 0.65) / 0.35))`,
  a Gaussian from the socket soft-capped near 5 % visible wash. The border catches
  40 % of it.

## Flashes and impacts

| Use | Curve |
|---|---|
| Name or result flash | `(1 − t / 1.2)²`, immediate attack |
| Settle-in or added row | `e^(−t / 0.234)·(1 − (t / 0.75)²)` |
| Press | `e^(−t / 0.25)·(1 − (t / 0.9)²)` |
| Inner rule, then outer border 0.14 s later | rise `sin(age / 0.18 · π/2)`, decay `(1 − (age − 0.18) / 1.1)²` |

## Pacing

React 0.3 s, step 0.8 s, settle 1.2 s, read 1 s. Rows ripple 0.12 s apart
(`author::stagger(rows, at, millis(120), ..)`). A reply launches no earlier than
`stage::reply_after(arrival)`: its 340 ms gather waits for the request, plus an
80 ms reaction.
Rewind: hold 0.15 s, then 1.25 s on `cubic-bezier(.65, 0, .25, 1)`, blurred by
its speed.
