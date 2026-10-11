# Voiceover Protocol

## Line

Triggered by /ms-voiceover-producer line <line-id>.

1. Verify the line is in script.json.
2. Verify the run's frozen parameters.
3. Generate the line.
4. Process: trim, normalize, fade, resample.
5. Align to the frame budget.
6. QA the line.
7. Save to runs/<id>/audio/lines/<line-id>.wav.
8. Update vo.json.
9. Report.

## Regen

Triggered by /ms-voiceover-producer regen <line-id>.

1. Archive the current accepted file to runs/<id>/audio/lines/archive/.
2. Regenerate with the frozen parameters.
3. Process and align.
4. QA.
5. If pass, replace the accepted file and update vo.json.
6. If fail, increment regenerationCount and retry until --max-regen.
7. On exhaustion, escalate.

## Align

Triggered by /ms-voiceover-producer align or after a script retime.

1. Read the current script.json frame anchors.
2. Compare against vo.json line frame anchors.
3. For each line with a delta, re-align by adjusting the sample offset in the stem.
4. Re-master the stem.
5. Update vo.json.
6. Re-run stem QA.

Alignment does not regenerate audio. It repositions existing audio.

## Normalize

Triggered by /ms-voiceover-producer normalize.

1. Read the stem.
2. Re-run loudness normalization to the audio tokens.
3. Re-measure.
4. Update vo.json.
5. Re-run stem QA.

## Dub

Triggered by /ms-voiceover-producer dub --lang <code>.

1. Verify the VO stem is final.
2. Call Dubbing v2 with the target language.
3. Receive and process the dubbed audio.
4. Align to the original script frame anchors.
5. Re-run stem QA for the dubbed stem.
6. Save under runs/<id>/audio/dubbed/<lang>/.
7. Update vo.json.dubbed.

## Clone

Triggered by /ms-voiceover-producer clone <voice-name>.

1. Verify reference audio (1-3 minutes, clean).
2. Verify written consent is on file.
3. Call the IVC endpoint.
4. Receive the voice_id.
5. Store in the client profile.
6. Optional verification line.
7. Report the voice_id.

Consent is required. No exceptions.

## Audit

Triggered by /ms-voiceover-producer audit.

1. Verify every scripted line has an accepted audio file.
2. Verify every line uses the frozen model_id, voice_id, and voice_settings.
3. Recompute hashes for every line and the stem.
4. Re-run stem QA.
5. Emit an audit diff.

## Report

Triggered by /ms-voiceover-producer report.

1. Sum characters by line, by model, by run.
2. Compute cost from the recorded rate.
3. Emit a table and the total.
4. Do not modify vo.json.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested vo.json version.
2. Restore the referenced audio files from the archive.
3. Re-verify hashes.
4. Re-open gate 9.
5. Mark downstream stale.

## Stop conditions

Stop and present when:

- Every non-silence line has audio
- Every line is within budget tolerance
- Every line aligns to its frame anchor
- The stem meets loudness and true-peak targets
- No VO-xx codes are open
- vo.json, vo.md, and the stems are written
- Model and voice are frozen for the run

Do not keep generating past this point. Do not present a VO stem with any open VO-xx.
