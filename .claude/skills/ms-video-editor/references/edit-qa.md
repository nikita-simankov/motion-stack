# Edit QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-cut checks

CUT-01 Missing scene for a board in the timeline
Fix: build the scene (stage 8) or fix the boards

CUT-02 Scene duration mismatch with its board
Fix: rebuild the scene at the correct duration

CUT-03 Runtime does not equal brief.runtime.frames
Fix: identify the delta and resolve at the correct stage

CUT-04 Gap in the timeline
Fix: fill the gap with a scene or remove it from the boards

CUT-05 Overlap outside a transition
Fix: adjust scene durations or the transition duration

CUT-06 Scene appears twice in the timeline
Fix: remove the duplicate

CUT-07 Scene order does not match boards order
Fix: reorder or roll back to stage 5

CUT-08 Transition does not match the board pair
Fix: correct the transition or update the boards

CUT-09 Transition duration outside the frozen motion bucket
Fix: adjust to a bucket value

CUT-10 Transition duration < 6 or > 90 frames
Fix: adjust to the legal range

## Per-audio checks

CUT-11 Audio stem missing
Fix: produce the stem at its stage

CUT-12 Audio stem hash mismatch
Fix: re-produce the stem or accept the new hash

CUT-13 Audio stem duration > runtimeMs
Fix: re-produce the stem at the correct duration

CUT-14 Audio anchor misaligned by more than 1 frame
Fix: re-align

CUT-15 Audio clipping when stems are summed
Fix: adjust stem levels at the producing stage

CUT-16 Unintended silence in the master
Fix: identify the missing anchor or missing stem

## Per-master checks

- Master source hash matches the recorded value
- Preview renders without error
- Determinism check passes
- No CSS transitions, no CSS keyframes, no Tailwind animation classes
- No scene duplication
- Master durationInFrames equals runtimeFrames
- Master composition registered in Root.tsx

## Thresholds

- Alignment tolerance: 1 frame
- Runtime tolerance: 0 frames (exact match required)
- Transition duration: 6-90 frames
- Audio level deviation: none (stems are placed at recorded levels)

## Reporting

For each scene:

- Its frames, transition, and duration

For each audio stem:

- Path, hash, startFrom, and duration

For the master:

- Total frames, runtime ms, composition id
- Preview hash
- Determinism result

## Sign-off

The timeline cannot pass gate 12 with any open CUT-xx. Any open code halts the pipeline.

## Determinism

Re-render the master preview twice and compare hashes. Mismatch is a blocker.

Common causes:

- Unseeded randomness in a scene
- Font loading race
- Environment variable read at render time
- Network dependency
- Chrome version drift between local and Lambda

## Legal note

The editor does not clear licenses. Cue sheet and license compliance are stage 11's responsibility. Any cue sheet issue discovered here is routed back to stage 11, not resolved here.
