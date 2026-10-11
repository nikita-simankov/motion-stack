# Changelog

## 2.0.0 — token contract v2: motion craft

Raises the craft of the output. v1 enforced that motion was frame-driven and token-bound; v2 adds what good motion looks like, as tokens that a linter and the QA rubric can check. See the README section "Motion craft and token contract v2".

### Breaking changes

- **Remotion pins moved from 4.0.130 to 4.0.534**, all packages together. New packages: `@remotion/motion-blur`, `@remotion/captions`, `@remotion/layout-utils`, `@remotion/noise`, `@remotion/paths`, `@remotion/shapes`, `@remotion/media-utils`.
- **React 19 is required** (was 18.3.1). `@remotion/transitions` 4.0.534 references React 19 internals even though its peer range says `>=16.8`; on React 18.3.1 the bundle fails with `export '__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE' ... was not found in 'react'`. `@types/react` and `@types/react-dom` are 19.x.
- **QA score is out of 75, not 60.** Three new high-weight criteria: motion craft, hierarchy and composition, distinctiveness. A master that passed under v1 can fail on these. Standard mode still needs 4 or more on high criteria.
- **The QA rubric has one source of truth** (`ms-quality-assurance/references/review-rubric.md`). `ms-command/references/qa-rubric.md` is now a pointer plus the criteria list. The two copies had drifted: one said every criterion needed 4, the other said medium and low needed 3. Standard mode (high 4+, medium and low 3+) is the rule; `--strict` requires 4+ everywhere.
- **`layout.grid` is an object** (`{ columns, gutterPx, baselinePx }`), not a string.
- **Scenes may not import `Easing` or inline a spring config**, and `interpolate()` needs a named easing unless marked `// ms:linear`. Hand-written v1 scenes that did these will fail the motion lint (ANIM-04, 06, 10).

### Added

- Token contract v2 (`tokenVersion: 2`): named curves, five curve roles, spring presets, choreography, motion blur, captions, camera, rhythm, surfaces, layout grid and platform insets, UI additions, loop rule, look provenance. v1 files stay readable; v1 easing names resolve through aliases.
- Motion runtime templates (`src/motion/`): token-driven `tween`, `springOf`, `staggerOffset`; `KineticText` and `NumberRoll`; `WordCaptions`; `CameraRig` and `ParallaxLayer`; `SmartZoom`; `MotionBlur`; `MeshGradient`. Transitions: token-driven `whip` and `shapeWipe`. Native `iris` documented.
- Word-level captions (`word-highlight`, `word-pop`) from ElevenLabs character timestamps, plus `vo.json` `lines[].words`.
- Platform UI safe-zone insets for 9:16 (third-party measurements; see the provenance note in `platform-specs.md`).
- Look bundles mapped to intake Q7, a layout system, mesh gradients, glass, halftone, paper, light leak.
- Beat grid and cut snapping, audio-reactive rules, seamless-loop rule.
- QA: motion craft, hierarchy and composition, distinctiveness anchors; defect codes ANIM-06 to ANIM-16, TYP-01 to 04, CMP-01 to 04, CAP-01 to 04, STY-05, CUT-15 to 17, VO-09; a motion proof sheet.
- Tooling: `migrate-tokens.sh`, `validate-tokens.sh`, `audit-motion.sh`, `proof_sheet.py`, `loop_check.py`, `words_from_alignment.py`, `beat_grid.py`. `/ms-setup verify` self-tests all of them.
- Commands: `/ms-command migrate`, `/ms-styleframe-designer migrate` and `validate`, `/ms-motion-designer proofsheet`, `--look <bundleId>`.

### Fixed

- `ms-setup/setup.sh` exited silently after OS detection on every supported OS. `detect_os` ended with `[ ... ] && fail ...`, which returns 1 when the test is false and tripped `set -e`. It now uses explicit `if` blocks. This blocked the scaffold step on a clean machine.
- The animation-pattern examples did not follow the rules they documented (unclamped `interpolate`, a hand-written spring config, a time-based kinetic example). They now pass the motion lint.
- The `whip` transition used a raw `filter: blur()` on a linear progress; it now uses token-driven motion blur on an `in-out-expo` move.

### Upgrading

1. `/ms-setup upgrade`, then `/ms-setup scaffold`.
2. `/ms-command migrate <project-id> [--tone <tone>]` and approve the re-opened gate 6.
3. `/ms-setup verify`.

Rollback: `/ms-command rollback ms-styleframe-designer <v1 version>` restores the archived v1 tokens and re-opens gate 6.

### Known limitations

- Not run end to end. A full 17-stage production needs a live ElevenLabs connection and a Claude session per stage. The runtime templates, token tools, lint, proof sheet, loop checker, word-timing converter and beat grid were tested on their own (see the README for what was verified).
- The ElevenLabs `with-timestamps` call and its SDK method name are taken from the public documentation and were not exercised against the live API. Confirm the method name against the installed SDK at setup.
- Safe-zone figures are third-party and disagree between sources. The table takes the conservative figure for each.
- Look bundles, pacing ranges and choreography defaults are starting calibrations, not measurements. `trend-benchmarks.md` has a calibration log for replacing them with values measured from baseline runs.
- The motion lint is a text heuristic. It can miss indirect patterns and can warn on legitimate ones (ANIM-07, ANIM-09, ANIM-13 are warnings for that reason).
- `HtmlInCanvasMotionBlur` is documented but not the default: its preview needs a Chrome flag. `CameraMotionBlur` ghosts counting numbers, so blur stays on transforms.
- 60 fps and generative image or video plates were considered and left out of this release.
