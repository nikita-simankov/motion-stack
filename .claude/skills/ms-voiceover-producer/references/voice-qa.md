# Voice QA

Checks and thresholds. Every failure is a VO-xx code and a gate rejection.

## Per-line checks

VO-01 Overrun beyond 10%
Condition: audio.durationMs > targetMs \* 1.10
Fix: regenerate with speed up to +0.15, adjust punctuation, else escalate to stage 4

VO-02 Underrun below 60%
Condition: audio.durationMs < targetMs \* 0.60
Fix: regenerate with speed down to -0.10, or extend with tail silence if beat allows

VO-03 Clipping
Condition: peak sample >= 0 dBFS in the raw output
Fix: regenerate; if persistent, adjust the voice or the model

VO-04 Truncation
Condition: line begins or ends mid-word (verified by listening or by waveform envelope analysis)
Fix: regenerate; check that the text sent to the API is not truncated

VO-05 Audible artifact
Condition: click, plosive, breath, or mouth noise above the acceptance threshold
Fix: regenerate; adjust stability

VO-06 Model drift / timbre mismatch
Condition: spectral comparison to prior lines exceeds a defined distance
Fix: check that model_id, voice_id, and voice_settings are unchanged; regenerate

VO-07 Alignment off by >1 frame
VO-09 Word timings required but missing, overlapping, outside the line, or not integer frames
Condition: rendered start or end frame differs from script frame anchor by more than 1
Fix: re-align the line; if the line is at the correct duration but off by a consistent offset, adjust the start sample

VO-08 Loudness out of spec
Condition: integrated LUFS outside target ± 0.5 LU
Fix: re-master the stem

VO-09 True-peak out of spec
Condition: truePeak > target truePeakDBTP
Fix: re-master the stem

VO-10 Missing audio for a scripted line
Condition: line exists in script.json and has no accepted audio file
Fix: generate the line

## Per-stem checks

- All lines present
- Concatenation boundaries free of clicks
- No phase issues
- Integrated loudness within target ± 0.5 LU
- True peak <= target
- No silence gaps where none are scripted
- No audio in silence lines

## Thresholds

- Integrated loudness tolerance: 0.5 LU
- True peak tolerance: at or below target (never above)
- Duration tolerance: -40% to +10% of target
- Alignment tolerance: 1 frame
- Spectral drift tolerance: defined per voice; defaults set in the studio config

## Regeneration policy

- On any single VO-xx for a line, regenerate the line up to --max-regen attempts (default 3)
- On persistent failure, escalate to stage 4 for text change or to the client for voice change
- Never paper over a failure by trimming on screen

## Reporting

For each line, record:

- All QA codes raised across attempts
- The accepted attempt
- The regeneration count

For the stem, record:

- Every check run
- The measured values
- The pass/fail per check

## Determinism note

ElevenLabs output is not bit-identical across calls. Regeneration may produce a different take. Accept the take that passes QA. Do not compare hashes across takes as a QA criterion.

## Sign-off

The VO stem cannot pass gate 9 with any open VO-xx. Any open code halts the pipeline.
