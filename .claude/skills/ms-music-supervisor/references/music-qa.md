# Music QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-cue checks

MU-01 Cue has no license record
Fix: add license or replace the cue

MU-02 Cue license invalid for a target platform
Fix: replace the cue or restrict the platform

MU-03 Cue license expires inside the publication window
Fix: replace the cue, extend the license, or adjust the window

MU-04 Cue not Content ID cleared but YouTube is a target
Fix: clear the track or replace it

MU-05 Cue not cleared for monetization but the video is monetized
Fix: clear the track, replace it, or mark the video unmonetized

MU-06 Cue frame range outside the runtime
Fix: adjust the frame range

MU-07 Cue duration less than 15 frames
Fix: extend the cue or merge with an adjacent cue

MU-08 Cue overlaps another cue without a layering reason
Fix: separate or record the layering

MU-09 Hit cue lands more than 1 frame off its anchor
Fix: adjust the offset

MU-10 Cue's energy arc fights the concept's arc
Fix: replace the cue or re-cut

MU-11 Cue has vocals that fight the VO
Fix: replace with an instrumental or reduce vocal density

MU-12 Cue's tempo differs from the ideal by more than 5% and no stretch was applied
Fix: replace the cue or apply a max 3% stretch

## Per-stem checks

- Integrated loudness within 0.5 LU of the token target
- True peak <= the token truePeakDBTP
- Ducking is applied under VO
- Lift-back is smooth
- No clipping on the bus
- No phase issues
- Mono compatibility verified
- Fade-in and fade-out match tokens

## Per-cue sheet checks

- Every cue has a row
- Every column is populated
- No discrepancy between music.json and cue-sheet.csv
- CSV hashes match the recorded hash

## Thresholds

- Loudness tolerance: 0.5 LU
- True peak tolerance: at or below target
- Hit alignment tolerance: 1 frame
- Tempo tolerance: 3% stretch maximum, 5% mismatch maximum

## Reporting

For each cue:

- All QA codes raised
- The accepted license
- The duck amount

For the stem:

- Integrated loudness
- True peak
- Maximum short-term loudness
- Loudness range (LRA)
- Peak-to-loudness ratio (PLR)

## Sign-off

The music stem cannot pass gate 11 with any open MU-xx. Any open code halts the pipeline.

## Silence posture

A run with posture "no-music" does not raise MU-01. It emits an empty cue sheet with a reason.

## Determinism

Music mixing is deterministic. Re-render and compare hashes as part of QA.

## Legal note

MU-01 through MU-05 are legal blockers, not aesthetic ones. Never override them. If a license is unclear, the pipeline halts.
