# Audio Alignment

Placing VO, SFX, and music stems. Stem summing.

## Stem placement

Every stem is placed at frame 0 in the master composition:

<Audio src={staticFile("audio/vo-stem.wav")} startFrom={0} />
<Audio src={staticFile("audio/sfx-stem.wav")} startFrom={0} />
<Audio src={staticFile("audio/music-stem.wav")} startFrom={0} />

Rules:

- startFrom is always 0 unless a manifest specifies an offset.
- The stem is already concatenated to the correct frame anchors.
- No per-line, per-SFX, or per-cue <Audio> elements.
- No stem is trimmed at the master level.

## Stem duration

Every stem's duration in ms must be <= runtimeMs.

If a stem is shorter than runtimeMs, silence is implied at the tail.

If a stem is longer than runtimeMs, the stem is a blocker; it was rendered at the wrong length and must be re-rendered by the producing stage.

## Stem hashes

Every stem's SHA-256 is recorded in its manifest (vo.json, sfx.json, music.json). The timeline verifies each hash matches the file on disk at gate time.

Any mismatch is a blocker.

## Stem summing

The master mixes the three stems by summing them at their recorded levels.

Recorded levels:

- vo.json does not carry a master-level gain; VO stem is mastered to its token target (-16 LUFS by default).
- sfx.json does not carry a master-level gain; SFX stem is mastered to its token target (-20 LUFS by default).
- music.json does not carry a master-level gain; music stem is mastered to its token target (-18 LUFS by default, ducked under VO).

At the master level:

- All three stems sum.
- No additional gain is applied unless mix.voGainDb, mix.sfxGainDb, or mix.musicGainDb is nonzero in timeline.json.
- No additional compression, EQ, or reverb.
- No additional fade-in or fade-out; fades belong to the stems.

## Master loudness

The master's integrated loudness after summing is checked at stage 14 (ms-finishing-suite). If it exceeds the token target, the finishing stage re-normalizes; the editor does not.

The editor's job is to place stems at their recorded levels. Any loudness correction happens at finishing.

## Alignment verification

For every VO line, SFX placement, and music cue:

1. Read the anchor frame from its manifest.
2. Verify the stem's sample at that anchor is non-zero (within a small epsilon for silence handling).
3. Verify alignment within 1 frame.

Any misalignment is a CUT-xx defect and routes back to this stage (not to the producing stage).

## Stem overlap

- VO and music overlap; music is ducked (already handled inside the stem).
- VO and SFX overlap; SFX is ducked where required (already handled inside the stem).
- SFX and music overlap; no ducking between them unless the finishing stage re-duck.
- Stingers and impacts may overlap; the stems are already mixed to avoid clipping.

Rules:

- No live ducking at the master level. Ducking is baked into the stems at their producing stages.
- No sidechain compression at the master level.

## Silent runs

If brief.Q9 is C (no VO), the VO stem is empty. Place a zero-length or silent stem.

If brief.Q12 is C (no music), the music stem is silent.

Either silent stem still occupies its <Audio> element for consistency and auditing.

## Audio QA

- Stem hashes match
- Stem durations <= runtimeMs
- Every anchor aligned within 1 frame
- No stem exceeds the master's duration
- No clipping when summed
- No unintended silence

See edit-qa.md for the full checklist.

## Rejected patterns

- Per-line <Audio> elements
- Live ducking at the master level
- Re-encoding a stem at the master level
- Trimming a stem at the master level
- Any EQ or compression at the master level
- Applying fades at the master level
