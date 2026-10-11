# Trend Benchmarks

Dated reference ranges for judging a look against current professional short-form motion work. They calibrate the QA rubric criteria "Motion craft", "Hierarchy and composition" and "Distinctiveness". They are not rules, and they expire.

Status of every number below: **starting calibration, not measurement.** The ranges are craft conventions for short-form motion at 30 fps. They have not been derived from a measured corpus. The calibration log at the bottom is where measured values replace them.

Review cadence: every quarter, or before a campaign that targets a platform whose UI has changed. Last reviewed: 2026-10-11.

## How to use

- Scene QA reads these ranges as expectations. A value outside a range is a question for the designer, not an automatic defect.
- A defect needs a rule from the token contract or the rubric anchors. A benchmark alone never fails a gate.
- When a project sets a value outside the range on purpose, the gate 6 notes record why.

## Pacing (30 fps)

| tone | median shot length | new information every | hook visual change by |
|---|---|---|---|
| authoritative | 75 to 120 frames | 60 to 90 frames | frame 45 |
| punchy | 36 to 60 frames | 30 to 45 frames | frame 30 |
| measured | 90 to 150 frames | 75 to 120 frames | frame 60 |
| kinetic | 18 to 36 frames | 18 to 30 frames | frame 20 |

## Motion

| attribute | range |
|---|---|
| entrance duration | 12 to 24 frames (short bucket) for elements, 24 to 45 for panels and scenes |
| exit duration | 60 to 70% of the entrance |
| stagger step | 2 to 6 frames, total at most 20 frames |
| camera move (push-in, pan) | 45 to 90 frames, in-out curves, total zoom at most 1.25x |
| transition | 8 to 24 frames, 6 minimum |
| distinct curves used per piece | at least 3 |
| spring overshoot | at most 12% (30% for playful) |

## Type

| attribute | range |
|---|---|
| families | 2 maximum |
| hook size, 9:16 at 1080 wide | 84 to 120 px |
| contrast between primary and secondary text size in one beat | at least 1.5x |
| caption size, 9:16 | 40 to 56 px, 2 lines maximum, at most 4 words per page for word-level styles |
| on-screen hold | at least 10 frames per word, minimum 24 |

## Captions and platform fit

- Word-level highlighted captions are the expected default for punchy and kinetic tone on vertical platforms; authoritative and measured tone use cue-level captions.
- Every readable element sits inside the platform inset box (`platform-specs.md`).
- Video autoplays muted on several platforms. The hook must read with sound off: the visual and text hook carry it, the audio hook is a bonus.

## Looks in current use

The bundle list in `looks.md` is the working set: editorial clean, cinematic grain, kinetic graphic, dark product UI, tactile analog, and brand-native. Add or retire bundles at the quarterly review, not mid-project.

## Sources consulted for the v2 revision (2026-10-11)

- Remotion documentation: motion blur guide, `createTikTokStyleCaptions`, `fitText`, `noise2D`, light leak effect (deprecation of `@remotion/light-leaks`).
- ElevenLabs text-to-speech "with timestamps" endpoint documentation (character-level alignment).
- Third-party measurements of vertical-platform UI overlays (see `platform-specs.md`); no platform-official figures were found.

## Calibration log

Fill from baseline runs (`/ms-command stage ms-quality-assurance` on a delivered master, motion proof sheet attached).

| date | project | preset | tone | median shot (frames) | curves used | stagger present | notes |
|---|---|---|---|---|---|---|---|
| | | | | | | | |
