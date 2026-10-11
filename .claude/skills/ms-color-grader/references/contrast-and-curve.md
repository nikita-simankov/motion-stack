# Contrast and Curve

Contrast curve math, palette contrast preservation.

## Curve definition

An ordered array of anchors { in, out } in 0-1.

Example S-curve:
{ 0.00, 0.00 }
{ 0.25, 0.22 }
{ 0.75, 0.78 }
{ 1.00, 1.00 }

Rules:

- At least 3 anchors.
- Monotonic in both in and out.
- in values strictly increasing.
- out values non-decreasing.
- First anchor at in 0, last anchor at in 1.
- out values in [0, 1].

## Interpolation

Between anchors, interpolation is monotone cubic (PCHIP) to prevent overshoot. Linear interpolation is allowed only when monotone cubic is unavailable.

## Application

- Applied per channel in the token colorspace, or as a luma curve with chroma preservation, per the token's method (default: luma curve with chroma preservation).
- Applied before the LUT.
- Applied to every pixel of every frame.

## Palette contrast preservation

The rule that overrides all others: after applying the curve, every palette color used in the picture must retain its contrast minimum.

Procedure:

1. For each palette color used, sample its RGB.
2. Apply the curve to the color.
3. Compute its luminance.
4. Compute the contrast ratio against the background it appears over.
5. Verify the ratio >= the token minimum.

If any palette color fails:

- Adjust the curve's midtones to preserve the ratio, or
- Route back to gate 6 to revise the palette, or
- Route back to gate 6 to revise the curve.

Do not ship a graded master with a palette color below its contrast minimum. Ever.

## Rejected curves

- Non-monotonic anchors
- Curves with fewer than 3 anchors
- Curves that clip more than 5% of the histogram
- Curves that reduce contrast for any palette color below minimum
- Curves with any anchor outside [0, 1]

## Midtone handling

- A mild S-curve increases contrast without crushing shadows or blowing highlights.
- The default curve should not push midtones more than 5% in either direction.
- A stronger curve is allowed when the token specifies it and the palette check passes.

## Encoding

The curve is applied as a 1D LUT per channel, or as a combined 3D LUT with the grade LUT and clamps. Combining reduces per-frame cost.

## Determinism

The curve is deterministic. Same anchors, same output.

## Reporting

Record the curve anchors in grade.json. Record the measured max anchor delta (should be 0 for a fixed curve).

## Rollback

Changing the curve after freeze is a rollback to gate 6.

## Example: preserving a warm accent

Palette:

- background #0A0A0A
- textPrimary #F5F5F5
- accentPrimary #F59E0B

A curve that crushes highlights to 0.85 will reduce the accent's luminance and may fail contrast against a white CTA text. Preserve the accent by moving the top anchor to 1.0 and reducing the mid-anchor delta. Verify the accent's saturation shift stays within tolerance.
