# Token Contract Migration: v1 to v2

`style-tokens.json` carries `tokenVersion`. v1 files have no field (read as 1). v2 adds motion craft, captions, camera, rhythm, surfaces, layout and UI additions.

## What v2 adds

| section | additions |
|---|---|
| `tokenVersion` | `2` |
| `motion` | `tone`, `aliases`, `curves`, `springs`, `roles`, `choreography`, `motionBlur`; `easings` now lists curve names (v1 names stay) |
| `type` | `families[].axes`; caption roles `caption`, `captionActive`; optional `display` |
| `captions` | `style`, `maxWordsPerPage`, `breakOnGapFrames`, `fadeFrames`, `activeColorRole`, `scrim`, `safeZoneRef`, `wordTimingSource` |
| `camera` | `rig`, `maxZoom`, `parallaxDepths`, `depthBlur` |
| `rhythm` | `beatGrid`, `audioReactive`, `maxStaticFrames` |
| `palette` | `gradients[]` (linear, radial, mesh) beside the v1 `gradientStops` |
| `texture` | `halftone`, `paper`, `lightLeak` |
| `layout` | `grid` becomes `{ columns, gutterPx, baselinePx }`; `focalPoint`; `aspectOverrides[].platformInsetsPx` |
| `uiMockup` | `cursor.curve`, `cursor.path`, `smartZoom`, `typing` (only when the run has a mockup) |
| `loop`, `look` | seamless-loop rule; look bundle provenance |
| metadata | `migratedFrom`, `reapprovalRequired` |

Unchanged: palette roles, type roles and sizes, buckets, transition set, grade, audio, iconography, imagery, the freeze rule.

## Compatibility rules

1. A v1 file stays readable. Every stage that reads tokens resolves a missing v2 section to the default in `ms-setup/tokens-v2-defaults.json`.
2. v1 easing names resolve through `motion.aliases`. v1 boards and motion notes stay valid.
3. QA on a v1 run scores the new criteria and records `STY-05` (minor): "v2 sections defaulted, not authored". It never blocks on that alone.
4. A frozen file is never edited in place. Upgrading is a new version of the stage 6 artifact.
5. The v2 file is `frozen: false` and `reapprovalRequired: true` until gate 6 is approved again. Downstream artifacts that depend on look values are marked stale only if the approved diff changes a value they used (see below).

## Procedure

```
/ms-command migrate <project-id> [--tone <tone>]
```

1. Read the current `style-tokens.json`. Stop if `tokenVersion` is already 2.
2. Run `ms-setup/migrate-tokens.sh <v1> <v2> --tone <tone>`. Tone defaults to the brief's Q5 (A authoritative, B punchy, C measured, D kinetic; "playful" only on explicit request).
3. `validate-tokens.sh` runs automatically. A failure stops the migration and prints the rule.
4. Write the result to `runs/<id>/style-tokens.v2.pending.json` (not frozen, `reapprovalRequired: true`, `migratedFrom` recorded). The frozen v1 file is not touched.
5. Re-open gate 6 and present the diff (added sections, tone-driven choices, unchanged v1 values).
6. On approve: copy the v1 file to `runs/<id>/style-tokens.v1.json` (read-only archive), write the approved v2 to `runs/<id>/style-tokens.json`, set `frozen: true`, `frozenAt`, `frozenBy`, clear `reapprovalRequired`, and run `validate-tokens.sh` again. On revise: the producer edits the pending file (stage 6 `retoken`), then validation runs again.
7. Stale rule: a v1 value is never changed by migration, so scenes built on v1 tokens stay valid. Scenes become stale only for values the approved diff changed (for example if the producer overrides `motion.roles.entrance`). The orchestrator marks those stages stale through the normal rollback path.

## Tone-driven choices

| tone | entrance | exit | blur | captions | overshoot budget |
|---|---|---|---|---|---|
| authoritative | out-quint | in-cubic | off | cue | 12% |
| punchy | out-expo | in-expo | on | word-highlight | 12% |
| measured | out-quart | in-cubic | off | cue | 12% |
| kinetic | out-expo | in-expo | on | word-highlight | 12% |
| playful | out-expo | in-expo | on | word-pop | 30%, adds `out-back` and `bouncy` |

## Tooling

| file | purpose |
|---|---|
| `ms-setup/migrate-tokens.sh` | v1 to v2 (jq). v1 values win; refuses to overwrite its input |
| `ms-setup/validate-tokens.sh` | v2 rule check: curves, aliases, roles, springs and overshoot, choreography ranges, tone rules, fonts, captions, layout, transitions |
| `ms-setup/tokens-v2-defaults.json` | the default v2 sections |
| `ms-setup/fixtures/tokens-v1.json` | a v1 sample for testing the migration |

## Dependencies bumped with v2

Scaffold pins moved from Remotion 4.0.130 to 4.0.534, and added `@remotion/motion-blur`, `@remotion/captions`, `@remotion/layout-utils`, `@remotion/noise`, `@remotion/paths`, `@remotion/shapes`, and `@remotion/media-utils`. Existing projects run `/ms-setup upgrade`, then copy the runtime: `/ms-setup scaffold` writes `src/motion/` from `ms-motion-designer/templates/motion/`.

The Python side adds optional `librosa` (beat grid). Failure to install it is a warning, not a setup failure.

## Rollback

`/ms-command rollback ms-styleframe-designer <v1 version>` restores `style-tokens.v1.json` as `style-tokens.json` and re-opens gate 6. The v2 file is kept as `style-tokens.v2.archived.json`.
