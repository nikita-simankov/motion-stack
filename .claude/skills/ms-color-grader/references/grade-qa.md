# Grade QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-operation checks

GRD-01 Operation order does not match the pipeline
Fix: reorder or re-apply

GRD-02 Operation parameter outside token tolerance
Fix: re-apply at the token value

GRD-03 Palette color below contrast minimum after grade
Fix: adjust the curve, the LUT, or roll back to gate 6

GRD-04 Black point measured off by more than 1
Fix: adjust the clamp or roll back to gate 6

GRD-05 White point measured off by more than 1
Fix: adjust the clamp or roll back to gate 6

GRD-06 LUT not loaded
Fix: verify the LUT path, the .cube format, and the colorspace

GRD-07 LUT hash mismatch
Fix: re-hash or restore the LUT

GRD-08 Texture intensity outside tolerance
Fix: re-apply at the token value

GRD-09 Chromatic aberration offset outside tolerance
Fix: re-apply at the token value

GRD-10 Vignette radius outside tolerance
Fix: re-apply at the token value

GRD-11 Output transform not last
Fix: reorder

GRD-12 Determinism check failed
Fix: identify the non-deterministic operation

GRD-13 Grade uses a CSS filter or Tailwind filter
Fix: replace with a Remotion primitive

GRD-14 Grade requires a third-party compositor
Fix: rebuild in Remotion

GRD-15 Grade applied to a picture-locked master whose hash does not match
Fix: re-lock the master or roll back to stage 12

## Per-master checks

- Master hash matches timeline.json
- Grade pipeline order correct
- Every operation's parameters match the tokens
- Preview renders without error
- Determinism check passes
- Palette contrast all pass
- Black and white points within tolerance
- Texture within tolerance
- Output transform last
- No CSS filters

## Thresholds

- Palette contrast: at or above token minimum
- Black/white point: within 1
- Grain intensity: ± 0.02
- Halation intensity: ± 5%
- Chromatic aberration: ± 0.1 px
- Vignette intensity: ± 0.01
- Vignette radius: ± 2 pct
- Anchor delta in contrast curve: 0 (fixed)
- Determinism: exact hash match

## Reporting

For every operation:

- Applied params
- Measured value
- Pass/fail

For the master:

- Preview hash
- Determinism result
- Palette contrast table

## Sign-off

The graded master cannot pass gate 13 with any open GRD-xx. Any open code halts the pipeline.

## Legal and brand note

A grade that breaks the brand palette is a brand defect, not just a color defect. It surfaces in every future video. Do not ship a graded master that breaks the palette contrast rule, even if the client requests it. Roll back to gate 6 and revise the palette or the curve together.

## Determinism note

Any change to Remotion version, Chrome version, or the LUT file invalidates the determinism check. Re-run the check after any such change.
