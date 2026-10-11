# Recut Composition

Native cut procedure, re-timing, re-rendering.

## Native cut procedure

For every platform in the platform set:

1. Determine the platform's aspect from the platform rules.
2. If the master's aspect matches, note the match. Otherwise, mark the cut as an aspect change.
3. Determine the platform's duration cap.
4. If the master's duration fits, note the fit. Otherwise, mark the cut as a duration change.
5. Determine the platform's codec, bitrate, and loudness.
6. Produce the platform cut by rendering from the master composition with the platform's aspect and duration.
7. Hash the output.

## Aspect change

An aspect change is a re-render, not a crop or a resize.

Procedure:

1. Read the master composition.
2. Apply the aspect-aware tokens from style-tokens.layout.aspectOverrides.
3. Re-render at the platform's aspect.
4. The re-render uses the same scenes, the same audio, the same captions.
5. No source code changes.

Rules:

- Aspect-aware tokens adjust margins, safe areas, and, when necessary, layout.
- The re-render preserves the picture-locked frame timing.
- The re-render preserves the audio stems.
- No CSS transitions, no Tailwind animation classes in any aspect-specific overrides.

## Duration change

A duration change is a re-cut, not a truncate or a speed-up.

Procedure:

1. Read the master timeline and the concept's beat map.
2. Determine which beat to cut to fit the platform's duration cap.
3. Priority of preservation:
   a. Hook (first 2 seconds)
   b. CTA
   c. The proof or landing beat
   d. The context beat
   e. The connective beat
4. Cut the lowest-priority beat first.
5. Re-time the remaining beats contiguously.
6. Re-render from the master composition with the new timeline.
7. Re-anchor the VO, SFX, and music stems to the new frame anchors.
8. Re-run loudness.

Rules:

- Never speed up the video to fit the cap.
- Never truncate the CTA.
- Never drop the hook.
- Never drop the strongest proof to preserve a connective beat.
- Never add a new beat that does not exist in the master.
- The re-cut preserves the concept's structural family.

## Re-cut timeline construction

The re-cut timeline is a Remotion composition:

- Same picture-locked scenes, sequenced per the re-cut
- Same audio stems, re-anchored
- A <Series> or <TransitionSeries> with durations equal to the re-cut's beat durations

Rules:

- The re-cut timeline is a new <Composition>, not a modification of the master.
- Composition id: <slug>-<platform>-cut
- The re-cut timeline inherits the master's audio and picture
- The re-cut timeline is rendered at the platform's aspect, codec, bitrate, and loudness
- The re-cut timeline is hashed

## Re-anchoring audio

When the runtime changes:

1. Read the original VO, SFX, and music manifests.
2. For each VO line, SFX placement, and music cue:
   a. Determine whether it belongs to a kept beat or a cut beat.
   b. If kept, shift its frame anchor by the total duration of any cut beats before it.
   c. If cut, drop it.
3. Re-render the stems at the new anchors.
4. Re-run loudness.

Rules:

- A VO line that spans a cut boundary is either fully kept or fully dropped.
- A music cue that spans a cut boundary is faded at the boundary and re-cut.
- SFX placements on a cut beat are dropped.
- No line, cue, or placement is stretched.

## Re-render pipeline

Local:
npx remotion render <slug>-<platform>-cut out/<platform>/master.mp4

Lambda:
npx remotion lambda render <serve-url> <slug>-<platform>-cut --frames-per-lambda=20 --memory=3009

Rules:

- Frames per Lambda: equal chunk size except the last, per Remotion Lambda rules.
- Determinism: re-render produces identical hashes.

## Caption re-anchoring

When the runtime changes:

1. Re-map every caption cue to the new frame anchors.
2. Re-emit burned captions, SRT, and VTT per platform.
3. Re-verify reading speed per cue.

## Thumbnail re-generation

Every platform cut generates its own thumbnail:

1. Auto-extract 3-5 candidates from the platform cut.
2. Optionally render a designed thumbnail at the platform's resolution.
3. Choose the thumbnail.
4. Hash.

## Determinism

Every re-cut is deterministic. Same inputs, same source, same hash.

## Rejected patterns

- Speeding up the video to fit a duration cap
- Truncating the CTA
- Dropping the hook
- Adding new beats to a re-cut
- Cropping or resizing a master instead of re-rendering
- Using the same captions across all platforms without re-anchoring when the runtime differs
- Using CSS transitions or Tailwind animation classes in aspect-specific overrides
