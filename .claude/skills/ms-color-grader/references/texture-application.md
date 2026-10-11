# Texture Application

Grain, halation, aberration, vignette implementation.

## Grain

Token: intensity (0-1), animated (bool), blendMode (overlay | soft-light | normal)

Implementation:

1. Generate a noise field. When animated, the noise is regenerated per frame using a seeded hash of the frame index.
2. Blend the noise over the source at the token intensity and blend mode.
3. The noise field is monochrome by default; color noise is allowed only with an explicit token.

Rules:

- No unseeded randomness.
- No reliance on system entropy.
- The grain is applied before any other texture operation.
- The grain is not applied to the audio.

## Halation

Token: threshold (0-255), radiusPx, intensity (0-1)

Implementation:

1. Threshold the source at the token threshold.
2. Blur the thresholded mask by the token radius.
3. Multiply the blurred mask by the intensity.
4. Add the result to the source.

Rules:

- The threshold is a luminance threshold.
- The blur radius is in pixels.
- Halation is applied after grain.
- Halation is not applied to areas below the threshold.

## Chromatic aberration

Token: offsetPx, mode (radial | uniform)

Implementation:

1. Offset the R and B channels by the token offset.
2. Radial mode scales the offset by distance from the frame center.
3. Uniform mode applies the offset in a fixed direction (default horizontal).

Rules:

- The offset is in pixels.
- The offset direction is either horizontal or radial; the token specifies which.
- Chromatic aberration is applied after halation.
- The offset never exceeds 4 px unless the token overrides it.

## Vignette

Token: intensity (0-1), radiusPct

Implementation:

1. Compute a radial gradient from the frame center.
2. Darken pixels outside the token radius by the token intensity.
3. The darkening uses multiply or screen depending on the source luminance (darkening for bright frames, lightening for dark frames).

Rules:

- The radius is expressed as a percentage of the smaller frame dimension.
- The intensity is at most 0.5 unless the token overrides it.
- Vignette is applied after chromatic aberration.

## Determinism

Every texture operation is deterministic:

- Grain uses a seeded noise field, seed derived from frame index.
- Halation, aberration, and vignette are pure functions of input.
- No operation reads system time or network.

## Performance

- Grain is the most expensive if the noise field is not precomputed per frame.
- Halation's Gaussian blur is the second-most expensive.
- Aberration and vignette are cheap.
- For longer videos, consider baking texture into a per-scene pre-render at stage 8, at cost of flexibility. Prefer to keep texture at stage 13.

## Rejected patterns

- CSS filter: blur()
- Tailwind's blur or backdrop-blur classes
- Non-deterministic noise
- Texture added as a static PNG overlay (does not animate)
- Any operation that runs outside Remotion

## Tolerance

- grain.intensity within ± 0.02 of token
- halation.intensity within ± 0.0125 (5%)
- halation.radiusPx within ± 1
- chromaticAberration.offsetPx within ± 0.1
- vignette.intensity within ± 0.01
- vignette.radiusPct within ± 2

## Rollback

Any change to a texture token after freeze is a rollback to gate 6.
