# Motion Curves (token contract v2)

Named curves, spring presets, and choreography rules. Locked at gate 6 inside `style-tokens.json` under `motion`. The motion designer consumes them through `src/motion/tokens.ts` (`m.tween`, `m.springOf`, `m.staggerOffset`). Nobody types a bezier into a scene.

Why this exists: v1 gave six easing names. Everything that "ease-out" described looked the same, which is the most recognisable tell of template motion. v2 keeps the names (as aliases) and adds a curve library, spring presets, and timing rules a linter can check.

## Curve library

Each curve is a cubic bezier `[x1, y1, x2, y2]` with x1 and x2 in 0..1. Remotion form: `Easing.bezier(x1, y1, x2, y2)`. Values are the standard easings.net definitions.

| name | bezier | feel | default role |
|---|---|---|---|
| out-cubic | 0.33, 1, 0.68, 1 | gentle arrival | v1 `ease-out` alias |
| in-cubic | 0.32, 0, 0.67, 0 | gentle departure | v1 `ease-in` alias |
| in-out-cubic | 0.65, 0, 0.35, 1 | neutral A to B | v1 `ease-in-out` alias |
| out-quart | 0.25, 1, 0.5, 1 | confident arrival | cursor, measured entrances |
| out-quint | 0.22, 1, 0.36, 1 | authoritative arrival | authoritative entrances |
| out-expo | 0.16, 1, 0.3, 1 | snappy, fast-in slow-settle | punchy and kinetic entrances |
| in-expo | 0.7, 0, 0.84, 0 | quick exit | punchy and kinetic exits |
| in-out-quart | 0.76, 0, 0.24, 1 | deliberate state change | state, camera |
| in-out-expo | 0.87, 0, 0.13, 1 | dramatic scene move | long-bucket camera moves |
| out-back | 0.34, 1.56, 0.64, 1 | overshoot | playful tone only |

`linear` exists for continuous motion only: progress bars, marquees, tracking. Mark it in source with `// ms:linear`.

### v1 aliases

`ease-out` = out-cubic, `ease-in` = in-cubic, `ease-in-out` = in-out-cubic. Boards and motion notes written in v1 vocabulary stay valid. The aliases live in `motion.aliases`.

## Roles

Five roles pick a default curve so a scene does not choose one per element:

| role | used for | authoritative | punchy / kinetic | measured |
|---|---|---|---|---|
| entrance | things arriving | out-quint | out-expo | out-quart |
| exit | things leaving | in-cubic | in-expo | in-cubic |
| state | A to B in place | in-out-quart | in-out-quart | in-out-quart |
| camera | push-ins, pans, zooms | in-out-quart | in-out-quart | in-out-quart |
| cursor | UI cursor legs | out-quart | out-quart | out-quart |

Playful tone uses the punchy roles and may add `out-back`.

A scene may pick a non-role curve for emphasis, but at least two distinct curves must be in use across a scene with six or more eased motions (see ANIM-09).

## Spring presets

Springs are named. An inline `config` is rejected (ANIM-10).

| preset | damping | stiffness | mass | settle (30 fps, 1%) | overshoot | use |
|---|---|---|---|---|---|---|
| land | 12 | 180 | 0.6 | 15 frames | 10.7% | CTA, success state, a landing beat |
| snappy | 20 | 200 | 0.6 | 9 frames | 0.1% | UI pops, chips, toggles |
| soft | 18 | 90 | 1 | 19 frames | 0% | large panels, calm tone |
| heavy | 26 | 140 | 1.4 | 17 frames | 0% | big objects, weight |
| bouncy | 8 | 170 | 0.7 | 23 frames | 28.1% | playful tone only |

Settle times are measured with `measureSpring({ fps: 30, config, threshold: 0.01 })`. Overshoot follows the damping ratio: `zeta = damping / (2 * sqrt(stiffness * mass))`, and when zeta < 1 overshoot = `exp(-pi * zeta / sqrt(1 - zeta^2))`. `validate-tokens.sh` computes this and rejects any spring above `choreography.overshootMaxPct` (12 by default, 30 for playful).

## Choreography rules

All values live in `motion.choreography` and are enforced by the lint or by scene QA.

| rule | token | default | check |
|---|---|---|---|
| Exits are shorter than entrances | exitRatio | 0.65 | exit frames = round(entrance frames x 0.65), floor 6 (micro bucket) |
| Groups of 3 or more stagger | staggerStepFrames | 2 to 6 | ANIM-07 |
| Total stagger is capped | staggerCapFrames | 20 | step shrinks to floor(cap / (N - 1)); lists above 8 items reveal in groups |
| Next element overlaps the last | overlapPct | 65 | follower starts at 65% of the leader's progress |
| Springs settle inside a window | settleFrames | 8 to 24 | measured with `measureSpring` |
| Overshoot is budgeted | overshootMaxPct | 12 | computed from the spring config |
| Text is readable | readHoldFramesPerWord, minHoldFrames | 10, 24 | hold = max(24, words x 10) frames after the entrance settles; ANIM-08 at QA |
| Nothing sits dead | rhythm.maxStaticFrames | 45 | a beat with no motion beyond 45 frames needs an `isolated` framing |

The numbers are starting calibrations (see `trend-benchmarks.md`). Change them per project at gate 6, not in a scene.

### Reading the rules together

An entrance is one named curve in a bucket duration. Siblings stagger. The next element starts while the last is still settling. An exit is about two thirds the length of the entrance. A text block holds long enough to read before it leaves. The whole beat then rests, or moves on, but never sits.

## Motion blur

`motion.motionBlur` controls blur on fast moves.

- `component`: `CameraMotionBlur` (works without browser flags) or `HtmlInCanvasMotionBlur` (Remotion's current recommended implementation; preview needs Chrome's HTML-in-canvas flag, rendering needs no configuration).
- `shutterAngle` 180 and `samples` 6 by default; raise samples for hero moves only.
- `appliesTo`: `whip`, `scale`, `push-in`. Blur applies only inside declared frame ranges (`<MotionBlur ranges>`), so holds stay sharp and render time stays flat.
- Blur belongs on transforms. Do not put it around counting numbers or per-glyph reveals: the blended sub-frames ghost the digits.
- Default off for authoritative and measured tone.
- Replaces raw `filter: blur()` in custom transitions. Local and Lambda renders must match (render parity is part of scene QA).

## Compatibility with Remotion

- Curves resolve to `Easing.bezier`, springs to `spring()`, both through `makeMotion()`.
- Package versions are pinned in `ms-setup/setup.sh` (4.0.534 at the time of writing). `@remotion/motion-blur` and the rest of the packages must share that version.

## Anti-patterns

- "Ease out, 0.3s" — no curve name, seconds
- `interpolate()` without `easing` — linear by accident (ANIM-06)
- Everything on out-cubic — one curve covers more than 80% of the motion (ANIM-09)
- Five list items that all start on frame 40 — no stagger (ANIM-07)
- `spring({ config: { damping: 9 } })` — inline config (ANIM-10)
- A raw `Easing.bezier(...)` in a scene — the curve is not in the contract (ANIM-04)
- Bounce on an authoritative piece — tone violation, rejected at validation
