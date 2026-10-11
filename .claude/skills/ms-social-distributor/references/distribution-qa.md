# Distribution QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-platform checks

CPT-01 Missing platform in the pack
Fix: produce the cut for the missing platform

CPT-02 Cut is a resize of another cut, not native
Fix: re-render at the platform's aspect

CPT-03 Aspect mismatch
Fix: re-render at the correct aspect

CPT-04 Duration exceeds the platform cap
Fix: re-cut from the beat map

CPT-05 Codec or bitrate mismatch
Fix: re-encode

CPT-06 Loudness out of spec
Fix: re-run the loudness pass

CPT-07 Caption missing
Fix: generate captions for the platform

CPT-08 Caption reading speed over 20 cps
Fix: split the cue

CPT-09 Thumbnail missing or at wrong resolution
Fix: generate the thumbnail

CPT-10 Metadata field missing
Fix: populate the field

CPT-11 First line identical to another platform
Fix: rewrite the first line per platform

CPT-12 Hashtag set identical to another platform
Fix: rewrite the hashtag set per platform

CPT-13 CTA string identical to another platform
Fix: rewrite the CTA per platform

CPT-14 Banned hashtag present
Fix: remove and replace

CPT-15 Attribution string missing when a license requires it
Fix: append the attribution string

CPT-16 Disclosure string missing
Fix: append the disclosure string

CPT-17 Hash mismatch
Fix: re-hash or regenerate

CPT-18 Placeholder string present
Fix: replace with real content

CPT-19 Watermark from another platform present
Fix: re-render without the watermark

CPT-20 Determinism check failed
Fix: identify the non-deterministic step

## Per-pack checks

- Every platform in brief.Q4 present
- Every platform folder contains the correct files
- Every file hashed and listed in sha256sums.txt
- pack.json present and hashed
- No master delivered to a platform whose aspect it does not match

## Per-copy checks

- First line differs across platforms
- Caption body differs across platforms
- CTA differs across platforms
- Hashtag set differs across platforms
- Every required attribution present
- Every required disclosure present
- No banned hashtags
- No claims unsupported by the dossier
- No platform exceeds its field limits

## Per-hook checks

- Hook lands inside the platform's first-2-second window (or 0.5 seconds on TikTok)
- Hook uses only footage in the master
- Hook uses only frozen tokens
- Hook is distinct from other platforms' hooks

## Thresholds

- Loudness tolerance: 0.5 LU
- True peak tolerance: at or below target
- Duration cap: platform-specific, hard limit
- Caption cps: <= 20
- Caption duration: >= 12 frames
- Hash: exact match
- Determinism: exact hash match

## Reporting

Per platform:

- Aspect, resolution, codec, bitrate, duration
- Loudness
- Caption presence
- Thumbnail presence
- Metadata completeness

Per pack:

- Every file with its hash
- pack.json hash
- sha256sums.txt hash

## Sign-off

The distribution pack cannot pass gate 16 with any open CPT-xx. Any open code halts the pipeline.

## Legal note

Attribution and disclosure strings are legal. Do not ship a distribution pack missing a required attribution. Roll back to stage 7 or 11 to clear the license.
