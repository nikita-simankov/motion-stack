# Audio Layering

Layering, gain staging, and mix bus structure for the SFX stem.

## Bus structure

The SFX stem is a single WAV file, but internally it is a mix of category buses:

- bus.impact
- bus.transition
- bus.ui
- bus.ambient
- bus.accent
- bus.riser
- bus.stinger

Each bus has:

- input gain (dB)
- category loudness target (LUFS short-term)
- optional ducking sidechain from the VO stem
- optional bus limiter (off by default)

## Gain staging

Per placement:

1. Start with the source peak (measured at -3 dBFS or wherever the library asset sits).
2. Gain to the category target minus the peak-to-loudness delta of the source.
3. Apply fades (8 frames in, 12 frames out by default).
4. Route to the category bus.
5. Sum on the bus.
6. Apply ducking if the placement overlaps a VO line.
7. Sum all buses to the stem.
8. Master the stem to the token's sfxLUFS and truePeakDBTP.

## Peak-to-loudness

Every source asset has a peak-to-loudness ratio (PLR). A tight impact has a high PLR; an ambient bed has a low PLR.

- Impact: PLR 12-18 dB. Target short-term -14 LUFS. Peak after gain: -1 dBFS.
- Transition: PLR 10-14 dB. Target -20 LUFS. Peak: -6 dBFS.
- UI: PLR 8-12 dB. Target -24 LUFS. Peak: -12 dBFS.
- Ambient: PLR 4-8 dB. Target -28 LUFS. Peak: -20 dBFS.
- Accent: PLR 8-12 dB. Target -28 LUFS. Peak: -16 dBFS.
- Riser: PLR 10-14 dB. Target -20 LUFS. Peak: -8 dBFS.
- Stinger: PLR 12-16 dB. Target -16 LUFS. Peak: -2 dBFS.

These are starting points. The mix decides the final.

## Layering rules

When two or more SFX layer on the same board:

- Sub-band (< 120 Hz): only one element at a time. Impacts own this band.
- Low-mid (120-500 Hz): up to two elements. Duck one by 3 dB.
- Mid (500 Hz - 2 kHz): up to two elements. Duck one by 3 dB.
- Upper-mid (2-5 kHz): up to two elements. Duck one by 3 dB.
- High (5 kHz+): up to three elements. No ducking.

The rule protects against sum-and-clip at the mix bus.

## Bus limiter

Off by default. Turned on only when:

- The stem cannot hit the token target without clipping
- A stinger or impact exceeds the true-peak ceiling
- The client asks for a louder perceived mix

When on, use a soft-knee limiter at -1 dBFS, not a hard clipper.

## Reverb and space

No reverb is added at this stage. Reverb is a design decision that belongs to the source asset, not the mix.

Exceptions, with reason:

- A synthesized SFX with an explicit reverb param in its spec
- A library asset that carries a natural reverb tail shorter than 200 ms

## Stereo width

- Mono placements route to both channels equally.
- Stereo library assets preserve their stereo image.
- Do not widen mono assets beyond their original image.
- The stem is stereo.

## Sum-to-master

The final mix is the sum of all category buses. It is not a limiter-heavy mix. The stem should feel produced but not squashed.

## Determinism

Layering and gain staging are deterministic given the same inputs. Fades and gains are frame-anchored. No randomness at render time.
