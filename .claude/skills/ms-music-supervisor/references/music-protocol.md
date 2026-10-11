# Music Protocol

## Cue

Triggered by /ms-music-supervisor cue <cue-id> or automatically during sourcing.

1. Determine the cue type from the musical brief.
2. Source or compose the cue.
3. Record the license at selection time.
4. Place the cue at its frame range.
5. Update music.json.
6. Update the cue sheet.

## Replace

Triggered by /ms-music-supervisor replace <cue-id>.

1. Archive the current cue under runs/<id>/audio/music/archive/.
2. Source a replacement.
3. Re-run licensing checks.
4. Update music.json and the cue sheet.
5. Re-run QA for the cue.
6. Re-mix if needed.

## Source

Triggered by /ms-music-supervisor source.

1. Derive the musical brief.
2. Search the cleared libraries in order.
3. Shortlist and listen.
4. Rank and select.
5. Record licenses.
6. Place cues.

## Compose

Triggered by /ms-music-supervisor compose.

1. Confirm budget tier and posture.
2. Brief a composer or generate an original cue.
3. Deliver as a stem with separated elements.
4. Align to the energy arc.
5. Record the original license.

## Cut

Triggered by /ms-music-supervisor cut --to-picture.

1. Read boards.json and concept.json.
2. Align the cue's downbeats to the board cuts.
3. Adjust the cue's offset and duration.
4. Verify hit alignment.
5. Update music.json.

## Duck

Triggered by /ms-music-supervisor duck.

1. Load the VO stem.
2. Compute the VO envelope in the 300 Hz - 3.4 kHz band.
3. Apply ducking to each cue per the token amount.
4. Update music.json per cue.
5. Re-mix the stem.

## Mix

Triggered by /ms-music-supervisor mix.

1. Re-run gain staging per cue.
2. Re-run ducking against the VO stem.
3. Re-master the stem.
4. Update music.json.
5. Re-run QA.

## Cue sheet

Triggered by /ms-music-supervisor cuesheet.

1. Walk every cue in music.json.
2. Emit cue-sheet.csv.
3. Emit the human table in music.md.
4. Hash the CSV.
5. Record in music.json.

## License

Triggered by /ms-music-supervisor license.

1. Emit a license report per cue.
2. Flag any cue with a restricted territory, a monetization mismatch, a Content ID mismatch, or an expiry inside the publication window.
3. Do not modify music.json.

## Audit

Triggered by /ms-music-supervisor audit.

1. Verify every cue has a license.
2. Verify every cue's frame range.
3. Verify every hit alignment.
4. Verify the stem's loudness and true-peak targets.
5. Verify the cue sheet matches music.json.
6. Emit an audit diff.

## Report

Triggered by /ms-music-supervisor report.

1. Count cues by type.
2. Sum sources (library, composed, client).
3. Emit cost from the recorded library tier.
4. Emit license summary.
5. Do not modify music.json.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested music.json version.
2. Restore the referenced music files from the archive.
3. Re-emit the cue sheet.
4. Re-render the stem.
5. Re-open gate 11.
6. Mark downstream stale.

## Stop conditions

Stop and present when:

- Every cue has a valid license
- Every cue's frame range is within the runtime
- Every hit cue lands within 1 frame of its anchor
- The stem meets loudness and true-peak targets
- Ducking is applied under VO
- The cue sheet is emitted with every required column
- No MU-xx codes are open
- music.json, music.md, cue-sheet.csv, and music-stem.wav written

Do not keep sourcing past this point. Do not present a music stem with any open MU-xx.
