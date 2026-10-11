# Music Editing

Cutting cues to picture, hit alignment, tempo mapping.

## Cutting to picture

1. Read boards.json. Extract:
   - Every transition frame
   - Every landing frame
   - The CTA frame
   - The hook frame range
2. Read concept.json. Extract the structural family and its energy arc.
3. Select or compose cues per the musical brief.
4. For each cue, decide the offset and duration to land on picture.
5. Trim or loop the cue to fit the runtime.
6. Adjust gain per cue so the mix lands on the token target.
7. Record the cut.

## Hit alignment

A hit cue lands within 1 frame of its intended frame.

Procedure:

1. Identify the intended frame (a cut, a landing, a CTA).
2. Set cue.frameAnchor to that frame.
3. Compute cue.frameStart = anchor - preRollFrames.
4. Compute cue.frameEnd = anchor + tailFrames.
5. Verify the cue's peak lands on the anchor. If not, adjust cue.offsetMs.
6. Record the alignment.

Pre-roll and tail by cue type:

- hit — preRoll 2 frames, tail 14 frames
- drop — preRoll 6 frames, tail 30 frames
- transition — preRoll 12 frames, tail 12 frames
- stinger — preRoll 12 frames, tail 45 frames

## Beat grid (v2)

Extract the beat grid from the finished music stem with `scripts/beat_grid.py` and hand `grid.json` to the editor for cut snapping. Beat positions are reliable; the BPM figure is approximate (octave errors happen), so tempo mapping below uses measured beat positions where it matters. Details and the audio-reactive rules: `beat-grid.md`.

## Tempo mapping

If the cue has a tempo and the boards have a rhythm, align them.

Procedure:

1. Measure the cue's tempo (BPM).
2. Measure the board cut intervals.
3. Compute the ideal tempo for the cuts: tempo = 60 / (avgCutIntervalSeconds / beatsPerBar).
4. If the cue's tempo differs by more than 5%, either:
   - Time-stretch the cue (max 3%) to match
   - Choose a different cue
   - Do not stretch beyond 3% — it produces audible artifacts

Rules:

- Never time-stretch more than 3%.
- Never pitch-shift.
- Never loop a cue more than twice without variation.
- Never fade a cue out mid-phrase unless the cut demands it.

## Energy arc

The cue's energy must match the concept's arc.

Per structural family:

- claim-first — flat, one lift at the proof, settle
- question-first — slow build, release at the answer
- contrast — A energy, B energy, return to A
- demonstration — rising with each demo step
- story — three-act arc
- list — per-item micro-lifts
- absurd-escalation — escalating, no release until the landing
- counterintuitive — resistance (lower energy) then release

Record the arc shape in music.json under musicalBrief.energyArc.

## Trimming

- Trim from the beginning or end, never the middle.
- Never cut a musical phrase mid-note.
- Never cut a cue on a beat that lands within 2 frames of a board cut — let the board cut own the moment.

## Looping

- Looping is allowed for main cues when the source is shorter than the runtime.
- Loop at a bar boundary.
- Cap at two loops.
- Vary the mix on the second loop (drop one element or add a lift) to avoid monotony.

## Silence

- Silence is a valid cue. Use it to land the CTA when the video needs a breath.
- A silence cue spans a frame range with source "silence".
- Silence is recorded in the cue sheet.

## Rejected patterns

- Time-stretching more than 3%
- Fading a cue out mid-phrase without intent
- Layering a hit cue over a drop cue at the same anchor without reason
- Using a cue outside its licensed use (e.g., a background cue as a stinger)
- Cutting a cue to fit a runtime without regard for the tempo
