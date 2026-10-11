# Cut Assembly

Scene sequencing, cut order, duration math.

## Assembly algorithm

1. Read boards.json. Extract every board in order.
2. Read scenes.json. Verify every board has a scene.
3. Verify every scene's durationInFrames equals its board's durationFrames.
4. Walk the boards in order. For each board:
   a. Add the scene to the master via <Series.Sequence> or <TransitionSeries.Sequence>.
   b. Set durationInFrames = board.durationFrames.
   c. If not the last board, add a transition wrapper between this scene and the next.
5. Verify the sum of durations equals brief.runtime.frames.
6. Emit the cut list.

## Beat snap (v2)

When `rhythm.beatGrid.required` is true, or the producer asks for a beat-synced cut, propose cut positions against the music grid after the music stem exists (stage 11):

1. Read `music.json` for the stem and the cue's start on the master timeline.
2. `beat_grid.py grid <stem> --fps <fps> --offset-ms <cue start>` writes `grid.json` (see `ms-music-supervisor/references/beat-grid.md`).
3. `beat_grid.py snap --grid grid.json --cuts <cut frames> --snap-frames <rhythm.beatGrid.snapFrames>` proposes shifts of at most `snapFrames` frames.
4. Accept a shift only when it keeps cut-on-action peaks and VO anchors intact (VO tolerance 1 frame). Record every decision, accepted or not, in `timeline.json` under `cut.beatSnap`.
5. A cut that could not snap while `required` is true is CUT-15.

Picture is locked only after this step is settled; a snap after picture lock is a rollback.

## Cut list

Every cut between scene N and scene N+1 carries:

- cutIndex — 1-based
- frame — the frame of the cut (equals scene N's frameEnd, equals scene N+1's frameStart)
- fromSceneId
- toSceneId
- transition — the transition type
- durationInFrames — the transition duration from the motion bucket

Rules:

- cutIndex increments from 1.
- frame is an integer.
- transition matches the board pair.
- durationInFrames is 6-90 and within the frozen motion bucket.

## Duration math

- totalDuration = sum(scene.durationInFrames for every scene)
- Transitions do not extend the total. The transition duration is absorbed within the two adjacent scenes' durations.
- A 12-frame dissolve between scene N (60 frames) and scene N+1 (240 frames) means the dissolve overlaps 12 frames of the two scenes; the total remains 300.
- The final frame of the master equals runtimeFrames - 1.

## Reordering

Reordering scenes requires a boards change. The editor does not reorder. If the client asks for a reorder:

1. Roll back to gate 5 (ms-storyboard-artist).
2. Update boards.json.
3. Rebuild affected scenes if their durations change.
4. Re-run gates 5 through 11.
5. Re-run this stage.

## Adding or removing a scene

Same rule: this stage does not add or remove. Adding a scene means a new board, which means a rollback to gate 5. Removing a scene means the board is killed, which means a rollback to gate 5.

## Duration mismatch

If a scene's durationInFrames does not match its board's durationFrames, the pipeline halts. The scene is rebuilt by stage 8, not stretched here.

## Transitions that change duration

Some transitions (e.g., a scale transition that overlaps) can appear to change duration. They do not. The Remotion <TransitionSeries> handles the overlap internally; the total duration is still the sum of the sequence durations.

## Coverage

For every frame in 0 to runtimeFrames:

- Exactly one scene claims it, either directly or via an overlapping transition.
- No gaps.
- No overlaps outside a transition's internal overlap.

## Cut rhythm

- Cuts should land on the board's transition frames by construction.
- If the cut rhythm feels off when previewed, the fix is at stage 5 (boards), not here.

## Runtime assertion

After assembly:

assert(totalDuration === brief.runtime.frames)

If the assertion fails, the master is not built. The pipeline halts with a specific delta.

## Rejected patterns

- Adding filler frames to hit the runtime
- Trimming scene durations to hit the runtime
- Reordering scenes to improve flow without a boards change
- Skipping a scene because it feels redundant
- Duplicating a scene to fill a gap
- Introducing a new scene that has no board
