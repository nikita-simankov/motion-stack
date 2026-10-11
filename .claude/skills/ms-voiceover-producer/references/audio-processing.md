# Audio Processing

Per-line and per-stem processing. Uses ffmpeg as invoked by Remotion; do not install ffmpeg globally.

## Per line

1. Trim silence
   - Leading: keep the first 30ms if the line begins with a plosive; trim the rest
   - Trailing: keep the last 30ms; trim the rest
   - Never trim inside a word

2. Peak normalization
   - Target -3 dBFS
   - Use ffmpeg loudnorm with linear=true for a single pass, or two-pass for accuracy
   - Reject any line whose peak after trim exceeds -1 dBFS (indicates clipping in the source)

3. Fades
   - 6-frame fade-in and 6-frame fade-out at the line's fps (default 30fps = 200ms)
   - Prevents pops at frame boundaries after concatenation

4. Resample
   - 48000 Hz, 24-bit PCM
   - No dithering at this stage; dithering happens at master

5. Save
   - runs/<id>/audio/lines/<lineId>.wav
   - SHA-256 recorded in vo.json

## Per stem

1. Build the timeline
   - Insert each line at its frameStart converted to samples: sampleStart = frameStart / fps \* sampleRate
   - Insert explicit silence for silence lines
   - No crossfades between lines unless the script specifies overlap

2. Concatenate
   - Single WAV file at 48kHz 24-bit
   - No normalization during concatenation

3. Master
   - Integrated loudness to style-tokens.audio.voLUFS (default -16)
   - True peak ceiling to style-tokens.audio.truePeakDBTP (default -1)
   - Fade-in and fade-out as token-defined (default 6 and 12 frames)
   - No compression, no EQ, no reverb

4. Export
   - WAV 48kHz 24-bit for the sound stage
   - MP3 192kbps for review
   - Both files hashed and recorded

## Loudness targets

From style-tokens.audio:

- voLUFS — default -16 LUFS integrated
- truePeakDBTP — default -1 dBTP
- fadeInFrames — default 6
- fadeOutFrames — default 12

Tolerance:

- Integrated: within 0.5 LU of target
- True peak: <= target (never above)

## ffmpeg commands (reference)

Loudness analysis:
ffmpeg -i input.wav -af loudnorm=I=-16:TP=-1:LRA=11:print_format=json -f null -

Two-pass loudnorm:
Pass 1: ffmpeg -i input.wav -af loudnorm=I=-16:TP=-1:LRA=11:print_format=json -f null -
Pass 2: ffmpeg -i input.wav -af loudnorm=I=-16:TP=-1:LRA=11:measured_I=... -c:a pcm_s24le output.wav

Resample:
ffmpeg -i input.mp3 -ar 48000 -sample_fmt s32 -ac 1 output.wav

Fade in/out (200ms at 30fps):
ffmpeg -i input.wav -af "afade=t=in:d=0.2,afade=t=out:st=<duration-0.2>:d=0.2" output.wav

Trim silence:
ffmpeg -i input.wav -af "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.03,areverse,silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.03,areverse" output.wav

Concatenate at frame anchors: build a silence-padded WAV per line and concat via concat demuxer, or compose directly in a DAW-equivalent script.

## Sample rate and bit depth

- Lines: 48000 Hz, 24-bit PCM
- Stem: 48000 Hz, 24-bit PCM
- Delivery to sound stage: WAV 48kHz 24-bit
- Delivery to finishing: WAV 48kHz 24-bit (or lossless per platform spec)

## Rejected patterns

- Any compression before the sound stage
- Any EQ before the sound stage
- Any reverb before the sound stage
- Any loudness normalization above the token target
- Any fade shorter than 3 frames or longer than 15 frames
- Any sample rate below 48kHz

## Determinism

Audio processing is deterministic given the same inputs and settings. Verify by re-running the pipeline on the same lines and diffing the SHA-256.

If hashes differ, check:

- ffmpeg version drift
- Non-deterministic loudnorm parameters (use measured_I from a fixed pass)
- Floating-point differences in a non-deterministic filter

## Archive

- Every attempt and intermediate file is kept under runs/<id>/audio/archive/.
- Archive is not used downstream; it exists for audit and rollback.
