# Texture and Grade

Texture and grade are locked here so the grade stage has a spec, not a guess.

## Texture tokens

### grain

- intensity 0-1 (default 0.08)
- animated true|false (default true)
- blendMode overlay | soft-light | normal (default overlay)

### halation

- threshold 0-255 (default 200)
- radiusPx (default 4)
- intensity 0-1 (default 0.25)

### chromaticAberration

- offsetPx (default 1)
- mode radial | uniform (default radial)

### vignette

- intensity 0-1 (default 0.15)
- radiusPct (default 70)

Texture is applied at stage 13. Tokens are the target.

## Grade tokens

### targetGamma

sRGB (default) | Rec.709 | linear | Rec.2020

### targetGamut

Rec.709 (default) | DCI-P3 | Rec.2020

### lutId

string (a named LUT in the project LUT library) or null

### contrastCurve

Ordered array of { in, out } anchor points, both in 0-1
Default mild S-curve:
{ 0.00, 0.00 }
{ 0.25, 0.22 }
{ 0.75, 0.78 }
{ 1.00, 1.00 }

### blackPoint

Integer 0-255 (default 0)

### whitePoint

Integer 0-255 (default 255)

### highlightRolloff

soft (default) | hard

## Application order

1. Texture (grain, halation, chromatic aberration, vignette)
2. Grade (contrast curve, LUT, black and white point clamp)
3. Highlight rolloff
4. Output transform to target gamma and gamut

The order is fixed. Any deviation is a GRD-xx defect.

## Rules

- Grade is applied at stage 13 as a Remotion post-process
- No CSS filters, no Tailwind filters
- No third-party compositor outside Remotion
- LUTs are loaded as .cube files at render time, never baked into source assets
- Grade tokens match the palette. A grade that crushes a palette color below contrast minimum fails.

## --no-grade flag

When set:

- The grade section is marked deferred: true
- Gate 6 cannot pass without explicit client override, recorded in run.json.approvals
- Stage 13 re-opens gate 6 when it authors the grade, and the client re-approves

## Rollback

Any change to a texture or grade token after freeze is a rollback to stage 6. It is not editable at stage 13.
