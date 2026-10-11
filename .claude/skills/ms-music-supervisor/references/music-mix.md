# Music Mix

Ducking, gain staging, mix bus, loudness.

## Bus structure

- bus.music.main
- bus.music.transition
- bus.music.hit
- bus.music.stinger

Each cue routes to its bus. Buses sum to the music stem.

## Gain staging

Per cue:

1. Source peak measured at whatever level the library provided.
2. Gain to the cue's target short-term loudness.
3. Route to bus.
4. Sum.
5. Apply ducking against the VO stem.
6. Sum all buses to the stem.
7. Master to the token's musicDuckLUFS integrated and truePeakDBTP.

## Target short-term loudness per cue type

main -20 LUFS
intro -18 LUFS
transition -22 LUFS
drop -16 LUFS
hit -14 LUFS
out -20 LUFS
stinger -16 LUFS
silence n/a

The integrated music stem target is the token musicDuckLUFS (default -18).

## Ducking

Ducking is sidechain-triggered by the VO stem.

- Attack: 8 frames (default)
- Release: 24 frames (default)
- Duck amount: token musicDuckLUFS delta from the cue's pre-duck level (default -18 dB for main beds)
- Ducking is applied per cue, not per bus
- Ducking is not applied during VO-silent sections

Implementation:

1. Load the VO stem.
2. Compute the VO's short-term envelope in the 300 Hz - 3.4 kHz band.
3. For each music cue, compute the cue's envelope in the same band.
4. If the VO is active and the cue's energy exceeds -30 dBFS in the band, apply the duck amount.
5. Release the duck when the VO drops below the threshold for 24 frames.

Record per cue:

- ducked: true | false
- duckAmountDb
- sidechainSource
- attackFrames
- releaseFrames

## Lift-back

Music lifts back to full level in VO-silent sections.

- Lift-back is the release of the duck.
- Lift-back is smooth, not a step.
- No lift-back during VO unless the VO is silent for at least 24 frames.

## Mix bus headroom

- Leave at least 3 dB of headroom on the music bus.
- Leave at least 1 dB of headroom on the total stem before the master limiter.
- Master limiter is off by default; on only if the stem cannot hit the target without clipping.

## Master

- Integrated loudness to token musicDuckLUFS (default -18)
- True peak ceiling to token truePeakDBTP (default -1)
- Fade-in and fade-out: 6 frames and 12 frames from tokens
- No compression that changes the energy arc
- No EQ beyond what the library source provides

## Stereo

- Stereo field preserved from the source
- No widening beyond the source
- Mono-compatible (check against a mono sum)

## Determinism

Music mixing is deterministic given the same inputs. Verify by re-rendering and comparing hashes.

## Anti-patterns

- Ducking with a hard gate (pumping)
- Ducking on the whole bus instead of per cue
- Lift-back with a step instead of a ramp
- Over-limiting to hit a louder target than the token
- Widening a mono source to fake stereo
- Any reverb added at the mix stage (reverb belongs to the source cue)
