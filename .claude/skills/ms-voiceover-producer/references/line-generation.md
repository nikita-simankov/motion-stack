# Line Generation

Per-line generation procedure. One line at a time, in script order.

## Input

- script.json — the pre-timed VO lines
- style-tokens.json — audio targets
- brief.json — model, voice, language

## Per-line procedure

1. Read the line from script.json: lineId, text, frameStart, frameEnd, durationFrames.
2. Compute targetMs = durationFrames / fps \* 1000.
3. Call the ElevenLabs text-to-speech endpoint with the frozen parameters.
4. Save the raw audio to runs/<id>/audio/raw/<lineId>-attempt<n>.<ext>.
5. Convert PCM to WAV 48kHz 24-bit for processing.
6. Trim leading and trailing silence beyond 30ms.
7. Measure durationMs.
8. Compute deltaMs = durationMs - targetMs.
9. Classify:
   - ok if abs(deltaMs) <= targetMs \* 0.10
   - overrun if deltaMs > targetMs \* 0.10
   - underrun if deltaMs < -targetMs \* 0.40
10. On overrun:
    a. Retry with speed +0.05 up to +0.15 total across attempts.
    b. If still overrun, retry with adjusted punctuation: replace em-dashes with commas, break long clauses.
    c. If still overrun after --max-regen attempts, escalate to stage 4.
11. On underrun:
    a. Retry with speed -0.05 down to -0.10.
    b. If still underrun, mark the line as extend-with-silence (add silence at the tail).
    c. If the beat is thin, escalate to stage 4.
12. On ok, save the processed file to runs/<id>/audio/lines/<lineId>.wav.
13. Record the generation log entry.

## Silence lines

Silence lines (script.json line with silence: true) skip generation. Record a targetMs and a zero-length audio entry. The stem concatenation inserts silence at the frame anchor.

## Multiple attempts

- Every attempt is recorded in generationLog.
- The final accepted attempt is referenced in lines[].audio.
- Attempts that failed QA are kept for audit but not used.

## Freeze rules

- model_id, voice_id, voice_settings, output_format are frozen for the run.
- Speed is allowed to vary between 0.90 and 1.15 per line to fit the budget.
- Changing speed beyond 1.15 or below 0.90 requires escalation to stage 4.

## Escalation to stage 4

When escalated, emit a specific request:

"Line L12 overruns by 24% at 1.15x speed. Rewrite to ~34 words at 155 wpm for a 13.5s slot (405 frames at 30fps)."

Do not silently rewrite. Do not trim on screen and hope. Escalate.

## Character counting

- Character count is the number of Unicode code points in the line.
- Only the first 40 characters are logged for PII safety.
- Total character count is summed across the run for cost.

## Cost

costEstimate.amount = characterCount \* perCharacterRate

Per-character rates by model (subject to change; record the rate used):

- eleven_multilingual_v2: standard tier
- eleven_flash_v2_5: ~50% lower than v2
- eleven_turbo_v2_5: between v2 and flash

Record the rate used in vo.json.costEstimate so the cost report is auditable.

## Rate limiting

- One line at a time. No batching.
- On 429, exponential backoff.
- On 5xx, retry up to 3 times.
- Do not parallelize generation across lines.

## Idempotency

- A line that already has an accepted audio file is not regenerated unless explicitly requested via /ms-voiceover-producer regen <line-id>.
- Regenerating a line replaces the accepted file. The previous file is archived under runs/<id>/audio/lines/archive/.
