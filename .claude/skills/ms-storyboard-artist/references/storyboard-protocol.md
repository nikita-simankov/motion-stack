# Storyboard Protocol

## Expand

Triggered by /ms-storyboard-artist expand <beat-id>.

1. Locate the beat in boards.json.
2. Identify the board(s) covering the beat.
3. Decide whether the beat needs a split (see board-granularity.md).
4. If split: replace the board(s) with the new boards, preserving frame coverage.
5. If not split: add motion notes, eye path, and audio detail to the existing board(s).
6. Recompute coverage. Verify the total still equals runtimeFrames.
7. Write boards.json and boards.md.

Expansion never changes the script. If the beat needs more time, that is a script problem, not a board problem.

## Resplit

Triggered by /ms-storyboard-artist resplit <beat-id>.

Same as expand, but forced: the beat will split into multiple boards whether or not the split threshold is met. Used when a motion designer or the client asks for more visual moments on a specific beat.

Log the reason in the board set under densityLog.

## Merge

Triggered by /ms-storyboard-artist merge <beat-a> <beat-b>.

1. Verify the two beats are adjacent in the script.
2. Verify the merge rules in board-granularity.md are met.
3. Replace the two boards with one merged board.
4. Recompute coverage.
5. Update the script (re-open gate 4) only if the merge changes the VO timing. Otherwise leave the script alone and note the merge in boards.json.

## Transitions

Triggered by /ms-storyboard-artist transitions.

1. Walk every board pair.
2. Verify the transition type is legal for the pair (see shot-vocabulary.md).
3. Replace weaker transitions with stronger ones where the concept benefits.
4. Re-pair transitions. Update transitionOut of B*n and transitionIn of B*(n+1).
5. Recompute the transition audit.
6. Write boards.json and boards.md.

## Audit

Triggered by /ms-storyboard-artist audit.

1. Recompute coverage. Confirm no uncovered, no overlapping, no orphan.
2. Verify every board's remotionSequence fields match its frame range.
3. Verify every transition pair matches.
4. Verify every UI board has device, state, and frameDriven = true.
5. Verify every motion note carries a Remotion primitive.
6. Verify no motion note uses CSS or Tailwind language.
7. Verify no board requires a renderer outside the brief's motion stack.
8. Emit an audit diff: boards unchanged, changed, added, removed.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested boards.json version.
2. Re-open gate 5.
3. Mark downstream stale.
4. Do not auto-approve. Require explicit approve.

## Stop conditions

Stop boarding and present when:

- Every script frame is claimed
- Every board maps to a Remotion <Sequence>
- Every transition pair matches
- Every UI board is frame-driven
- Density is within range or deviation is logged
- Boards.md rendered

Do not keep adding boards past this point. Do not present a board set that fails any of the six.
