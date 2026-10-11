# SFX Placement

Every placement is a decision. Frame anchors, categories, and mapping.

## Placement procedure

For each board in boards.json:

1. Read the board: framing, subject, action, motionDirection, transitionIn, transitionOut.
2. Identify the board's function: does it land a beat, bridge a transition, show an interaction, hold a bed, punctuate a small moment, build tension, or close the piece?
3. Classify the SFX category (impact, transition, ui, ambient, accent, riser, stinger).
4. Find the frame anchor: the frame where the sound must land.
5. Compute frameStart and frameEnd: pre-roll for risers, tail for impacts, duration for beds.
6. Source or synthesize the SFX.
7. Set the loudness target for the category.
8. Verify the VO band is not masked; duck if required.
9. Record the placement.

## Frame anchors per category

impact
anchor = the landing frame (typically the peak of a scale or the end of a motion)
frameStart = anchor - 6
frameEnd = anchor + min(60, board.durationFrames)

transition
anchor = the transition frame
frameStart = anchor - 12
frameEnd = anchor + 12

ui
anchor = the interaction frame (click, keypress, toggle)
frameStart = anchor - 2
frameEnd = anchor + 14

ambient
anchor = board.frameStart
frameStart = board.frameStart
frameEnd = board.frameEnd

accent
anchor = the accent frame (type-on, tick, blip)
frameStart = anchor - 2
frameEnd = anchor + 10

riser
anchor = the beat the riser resolves to
frameStart = anchor - riser duration (24-90 frames)
frameEnd = anchor

stinger
anchor = the CTA frame or the final frame of the piece
frameStart = anchor - 12
frameEnd = anchor + min(45, remaining frames)

## Rules

- Anchors are integers.
- frameStart >= 0. frameEnd <= runtimeFrames.
- Duration = frameEnd - frameStart. Range 6-300 frames.
- No placement crosses a board boundary except ambient.
- Ambient placements must be bookended by frames and faded at both ends.
- If a board has multiple SFX, they must not share an anchor unless the layering is intentional and recorded.

## Silence records

For every board with no SFX, record a silence entry with a one-line reason. Silence is a decision, not an omission.

Common reasons:

- VO lands the beat; SFX would fight it
- Music bed (stage 11) carries the moment
- Silence is the design
- The board is a pause before a reveal

## Coverage rule

Every board in boards.json must appear in either:

- placements (with at least one SFX), or
- silenceRecords (with a reason)

No board is unresolved at gate time.

## Layering

Two or more SFX on the same board are allowed when they serve different functions:

- impact + accent on a landing
- riser + impact on a reveal
- ui + accent on an interaction

Rules:

- Layer count per board is capped at 3 unless the design justifies more and it is recorded.
- Layered SFX must not share the same frequency band at the same time.
- Layered SFX must not sum above the category's loudness ceiling after mix.

## Cross-board continuity

- Ambient beds span their board only.
- Riser + impact pairs span two boards and are recorded as two placements.
- Stingers close the piece and never repeat within a single video unless the design demands it and it is recorded.
