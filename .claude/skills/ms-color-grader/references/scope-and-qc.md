# Scope and QC

Waveform, vectorscope, histogram, contrast checks.

## Scopes

Scopes are read from the graded preview render.

### Waveform

- Luma distribution across the frame at each x-position
- Confirms black and white points
- Confirms no channel clipping

### Vectorscope

- Chroma distribution
- Confirms hues are within the token tolerance
- Confirms saturation is within the token tolerance

### Histogram

- Per-channel distribution
- Confirms no unexpected spikes
- Confirms the black and white clamps are working

## Palette contrast check

For every palette color used in the picture:

1. Sample the color at its rendered position.
2. Compute its luminance.
3. Compute contrast against the background it appears over.
4. Verify the ratio >= the token minimum.
5. Record foreground, background, ratio, minimum, pass.

Rules:

- Text-related roles (textPrimary, textSecondary, textInverse, cta, hook) have 4.5:1 or 3:1 minimums from the token.
- State colors have 3:1 minimums when used as fills.
- Any fail halts the grade.

## Black point verification

- Measure the darkest pixel in the graded frame.
- Verify it is within 1 of the token blackPoint.
- Record in grade.json.

## White point verification

- Measure the brightest pixel in the graded frame.
- Verify it is within 1 of the token whitePoint.
- Record in grade.json.

## Texture verification

Per texture operation:

- Grain: measure the noise intensity by comparing to a noise-free reference; verify within ± 0.02.
- Halation: measure the bloom intensity at the threshold edge; verify within ± 5%.
- Chromatic aberration: measure the channel offset; verify within ± 0.1 px.
- Vignette: measure the corner darkening; verify within ± 5%.

## Output transform verification

- Verify the output gamma by measuring a known mid-grey patch.
- Verify the output gamut by checking the saturation of the palette's accent.
- Record both in grade.json.

## Determinism

- Re-render the graded preview twice.
- Compare SHA-256 hashes.
- Any mismatch is a blocker.

Common causes of mismatch:

- Unseeded grain
- Time-dependent color transforms
- Cache misses on LUT loading
- Font rendering (though grading usually does not touch text)
- Chrome version drift

## Performance

- Grade operations add 15-40% to the render time.
- Combined 3D LUT reduces per-frame cost.
- Lambda renders absorb the cost for the master.

## Reporting

For every scope:

- The read (waveform min/max, vectorscope radius, histogram peaks)
- The token expectation
- Pass/fail

Store in grade.json under each operation's measured field.

## Sign-off

The graded master cannot pass gate 13 with any open GRD-xx. Any open code halts the pipeline.

## Reference render

A reference render of the graded picture is preserved at runs/<id>/previews/grade.mp4. It is the artifact the client approves at gate 13. Not the source, not the manifest.

## Rejected patterns

- Approving a grade without scopes
- Approving a grade with any palette contrast fail
- Skipping texture verification
- Re-running the render with different settings to "fix" a determinism failure
