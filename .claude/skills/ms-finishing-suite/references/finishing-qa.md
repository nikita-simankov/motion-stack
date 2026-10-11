# Finishing QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-master checks

FIN-01 Codec mismatch
Fix: re-encode with the correct codec

FIN-02 Resolution mismatch
Fix: re-encode at the correct resolution

FIN-03 Aspect mismatch
Fix: re-encode at the correct aspect

FIN-04 Bitrate out of range
Fix: re-encode at the correct bitrate

FIN-05 Loudness out of spec (integrated)
Fix: re-run the loudness pass

FIN-06 True peak out of spec
Fix: re-run the loudness pass with a lower ceiling

FIN-07 Duration mismatch
Fix: re-encode from the correct timeline

FIN-08 Faststart not enabled
Fix: re-mux with faststart

FIN-09 Missing caption sidecar
Fix: generate SRT and VTT

FIN-10 Burned caption missing
Fix: re-encode the burned variant

FIN-11 Thumbnail missing
Fix: generate the thumbnail

FIN-12 Metadata missing or incomplete
Fix: populate every field

FIN-13 Slate missing
Fix: generate the slate

FIN-14 Cue sheet or license summary missing
Fix: re-copy from the source stages

FIN-15 Hash mismatch
Fix: re-hash or regenerate

FIN-16 Placeholder string detected
Fix: replace with real content

FIN-17 Package missing a file
Fix: regenerate the package

FIN-18 Package contains a file not in the hash list
Fix: regenerate the hash list

FIN-19 Determinism check failed
Fix: identify the non-deterministic step

FIN-20 Master uses a codec or container outside the platform spec
Fix: re-encode

## Per-caption checks

- Text matches script.json verbatim
- cps <= 20
- Duration >= 12 frames
- Frame range within runtime
- SRT parses
- VTT parses
- Burned captions visible
- No caption obscures the CTA

## Per-metadata checks

- Every field populated
- Every attribution string appended
- Every disclosure string appended
- No field exceeds the platform limit
- No placeholder strings

## Per-package checks

- Every deliverable listed in sha256sums.txt
- Every listed file present
- Every platform folder contains the correct files
- No master delivered in an aspect the platform does not accept

## Thresholds

- Loudness tolerance: 0.5 LU
- True peak tolerance: at or below target
- Duration tolerance: 0 frames
- Caption cps: <= 20
- Caption duration: >= 12 frames
- Hash: exact match
- Determinism: exact hash match

## Reporting

For every master:

- Codec, resolution, fps, bitrate, audio spec
- Loudness measurement
- Caption presence
- Thumbnail presence
- Hash

For the package:

- Every file with its hash
- package.json hash
- sha256sums.txt hash

## Sign-off

The delivery package cannot pass gate 14 with any open FIN-xx. Any open code halts the pipeline.

## Determinism

Re-encode one master twice and compare hashes. Mismatch is a blocker. Common causes:

- Encoder version drift
- Non-deterministic loudness pass (use fixed measured values)
- Chrome version drift between local and Lambda
- Remotion version drift

## Legal note

The metadata pack is a legal artifact (attributions, disclosures). Do not ship a metadata pack with a missing attribution when a license requires it. Roll back to stage 7 or 11 to clear the license.
