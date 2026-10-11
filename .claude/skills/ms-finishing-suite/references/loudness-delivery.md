# Loudness Delivery

Loudness measurement and correction.

## Targets

From the platform spec table:

- Integrated: -14 LUFS
- True peak: -1 dBTP

Tolerance:

- Integrated: within 0.5 LU
- True peak: at or below target

## Measurement

Measure on the encoded master, not on the pre-encode mix.

- Integrated loudness: ITU-R BS.1770-4
- True peak: oversampled 4x, ITU-R BS.1770
- Loudness range (LRA): EBU R128

Tool: ffmpeg loudnorm in analysis mode, or an EBU R128 meter.

ffmpeg command:
ffmpeg -i master.mp4 -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null -

## Correction

If a master misses the target:

1. Extract the audio stream.
2. Apply loudnorm two-pass with the measured values.
3. Re-mux the corrected audio into the video container without re-encoding the video.
4. Re-measure.

ffmpeg:
Pass 1: ffmpeg -i master.mp4 -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null -
Pass 2: ffmpeg -i master.mp4 -af loudnorm=I=-14:TP=-1:LRA=11:measured_I=... -c:v copy -c:a aac -b:a 192k corrected.mp4

Rule: never re-encode the video to fix loudness. Only the audio is re-encoded.

## Deviations

If the master's integrated loudness is off by more than 0.5 LU after correction, halt. Options:

- Re-mix the audio at the stem level (rollback to stage 12)
- Reduce the correction target by the deviation and correct in two steps
- Accept the deviation with explicit client override

Default: rollback to stage 12 for a re-mix. Loudness corrections that require more than one pass usually indicate a stem problem.

## Platform overrides

If the brief's platform set includes a platform with a different loudness target, the master for that platform is corrected to that target. The platform spec table wins.

## Delivery

Every master is delivered with its measured loudness recorded in master.json:

- integratedLUFS
- truePeakDBTP
- loudnessRangeLU

## Rejected

- Delivering a master without a loudness measurement
- Delivering a master with integrated loudness outside 0.5 LU of target
- Delivering a master with true peak above target
- Re-encoding the video to fix loudness

## Determinism

Loudness measurement is deterministic. Re-measure and compare.

## Reference

A reference render with the target loudness is preserved at runs/<id>/previews/loudness-check.mp4 for audit.
