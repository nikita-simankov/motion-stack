# Sound QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-placement checks

SD-01 Missing placement for a board with a designated cue
Fix: produce the placement or record a silence with a reason

SD-02 Placement has no license or synthesis spec
Fix: add the license record or synthesis spec

SD-03 Placement's frame anchor is not an integer
Fix: round to the nearest frame

SD-04 Placement duration outside 6-300 frames
Fix: extend or shorten the source

SD-05 Placement crosses a board boundary (non-ambient)
Fix: split into two placements or shorten

SD-06 Placement loudness exceeds its category ceiling
Fix: gain down

SD-07 Placement masks the VO band during a VO line without ducking
Fix: apply ducking or move the placement

SD-08 Placement uses a source without a license record
Fix: add license or replace the source

SD-09 Placement uses a synthesized SFX without a spec
Fix: add the spec or replace with a library asset

SD-10 Placement was added for a board with no designated cue and no reason
Fix: remove or record a reason

## Per-stem checks

- Integrated loudness within 0.5 LU of the token target
- True peak <= token truePeakDBTP
- No clipping in the stem
- No phase issues between layered elements
- No audible gaps where placements exist
- No audible duplication of the same source on adjacent boards without intent
- Ambient beds fade at their boundaries
- Transients preserved (no compression artifacts)

## Per-category checks

- Impact: peak <= -1 dBFS after gain; no reverb tail longer than the placement
- Transition: sweep direction matches the board's motion direction
- UI: transient sharp, no tail
- Ambient: consistent level across the bed, fades at boundaries
- Accent: no reverb, clean transient
- Riser: ends exactly on the target frame
- Stinger: unique within the video, no accidental repetition

## Thresholds

- Loudness tolerance: 0.5 LU
- True peak tolerance: at or below target (never above)
- Duration tolerance: within 1 frame of the placement duration
- Alignment tolerance: 1 frame
- VO-band masking threshold: -22 dBFS in 300 Hz - 3.4 kHz

## Reporting

For each placement:

- All QA codes raised
- The accepted source
- The duck amount if applicable

For the stem:

- Integrated loudness
- True peak
- Maximum short-term loudness
- Loudness range (LRA)
- Peak-to-loudness ratio (PLR)

## Sign-off

The SFX stem cannot pass gate 10 with any open SD-xx. Any open code halts the pipeline.

## Silence

A board with a silence record does not raise SD-01. It is a valid decision.

## Determinism

SFX rendering is deterministic given the same inputs. Re-render and compare hashes as part of QA.
