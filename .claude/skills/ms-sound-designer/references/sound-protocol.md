# Sound Protocol

## Board

Triggered by /ms-sound-designer board <board-id>.

1. Read the board.
2. Identify the SFX function.
3. Classify the category.
4. Source or synthesize the SFX.
5. Place it at its frame anchor.
6. Record the placement.
7. Update sfx.json.

## Add

Triggered by /ms-sound-designer add <sfx-id> <board-id> <frame> <category>.

1. Verify the board exists.
2. Verify the anchor is within the board's range.
3. Source or synthesize the SFX.
4. Add to placements.
5. Recompute coverage.

## Replace

Triggered by /ms-sound-designer replace <sfx-id>.

1. Archive the current source under runs/\_sfx/archive/.
2. Source or synthesize a replacement.
3. Update the placement entry.
4. Recompute hashes.
5. Re-run QA for the placement.

## Synthesize

Triggered by /ms-sound-designer synthesize <spec.json>.

1. Read the spec.
2. Invoke the generator with the spec's params and seed.
3. Verify the output against the spec (duration, frequency, envelope).
4. Save to runs/\_sfx/synthesized/<sfx-id>.wav.
5. Hash and record.
6. Return the file path.

## Render

Triggered by /ms-sound-designer render or after any placement change.

1. Walk every placement.
2. Trim, fade, and gain per the placement's target.
3. Route to the category bus.
4. Sum buses.
5. Apply ducking against the VO stem.
6. Master to the token targets.
7. Export the stem to runs/<id>/audio/sfx-stem.wav and a preview MP3.
8. Hash and record.
9. Update sfx.json.

## Remix

Triggered by /ms-sound-designer remix.

1. Keep the placements unchanged.
2. Re-run gain staging and ducking.
3. Re-master the stem.
4. Update sfx.json.
5. Re-run QA.

## Audit

Triggered by /ms-sound-designer audit.

1. Verify every board has a placement or a silence record.
2. Verify every placement's license or synthesis spec.
3. Verify every placement's category ceiling.
4. Verify the stem's loudness and true-peak targets.
5. Verify the duck map against the VO stem.
6. Emit an audit diff: placements unchanged, changed, added, removed.

## Report

Triggered by /ms-sound-designer report.

1. Count placements by category.
2. Sum sourced vs synthesized.
3. Emit the license summary.
4. Emit cost if any licensed library was used with a per-use fee.
5. Do not modify sfx.json.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested sfx.json version.
2. Restore the referenced source files.
3. Re-render the stem.
4. Re-open gate 10.
5. Mark downstream stale.

## Stop conditions

Stop and present when:

- Every board is covered by a placement or a silence record
- Every placement has a license or a synthesis spec
- Every placement's duration and loudness are within spec
- No VO-band masking without ducking
- The stem meets loudness and true-peak targets
- No SD-xx codes are open
- sfx.json, sfx.md, and sfx-stem.wav written

Do not keep designing past this point. Do not present an SFX stem with any open SD-xx.
