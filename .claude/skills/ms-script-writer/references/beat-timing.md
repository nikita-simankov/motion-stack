# Beat Timing

Frames, not seconds. At 30fps: 1s = 30 frames.

## Allocation per runtime

### 15s — 450 frames

Hook: 0-60
Body: 60-390
CTA: 390-450
Beats: 2-3 total (hook + 1-2 body + CTA)
Per-beat min: 60 frames
Per-beat max: 180 frames

### 30s — 900 frames

Hook: 0-60
Body: 60-780
CTA: 780-900
Beats: 4-6 total (hook + 3-4 body + CTA)
Per-beat min: 60 frames
Per-beat max: 300 frames

### 60s — 1800 frames

Hook: 0-60
Body: 60-1620
CTA: 1620-1800
Beats: 6-9 total (hook + 5-7 body + CTA)
Per-beat min: 90 frames
Per-beat max: 360 frames

### 90s — 2700 frames

Hook: 0-90
Body: 90-2460
CTA: 2460-2700
Beats: 8-12 total (hook + 7-10 body + CTA)
Per-beat min: 90 frames
Per-beat max: 450 frames

## Rules

- Beat boundaries are exact frame numbers, not approximations.
- Ranges are contiguous. No gaps. No overlaps.
- Every beat except connective carries at least one claim id.
- A beat shorter than the per-beat min is merged with the adjacent beat.
- A beat longer than the per-beat max is split into two beats with distinct purposes.
- The CTA beat is never longer than 120 frames. If it needs more, it belongs in the body.

## Edge cases

### Runtime change mid-script

Re-run retime. Do not stretch existing beats. Reallocate from the allocation table and rewrite any VO line that no longer fits.

### Beat overrun

If a beat overruns because a claim needs more setup, either:

- Split the claim into two claims and use two beats
- Cut the claim
  Never pad a beat with filler VO.

### Beat underrun

If a beat underruns because the claim is thin, either:

- Merge with the adjacent beat
- Replace the claim with a stronger one from the dossier
  Never pad a beat with a restated claim.

### Silence

Silence is a beat. It carries a frame range and no text. It is used for landing a point, before a reveal, or after the CTA. Never use silence to pad.

## Timing table

Emitted on every script revision:

Beat Frames Duration VO words Est. sec Budget sec Delta
B1 0-90 90 12 4.6 3.0 +1.6
B2 90-330 240 42 16.3 8.0 +8.3 OVERRUN
...
CTA 780-900 120 14 5.4 4.0 +1.4

Any row with Delta > +10% of budget is flagged as OVERRUN and must be rewritten before gate.
