# Grade Protocol

## Retoken

Triggered by /ms-color-grader retoken <token-id>.

1. Verify the token belongs to the grade or texture section of style-tokens.json.
2. Verify the client has authorized a rollback to gate 6.
3. Roll back to gate 6.
4. Apply the token change.
5. Re-run gate 6 through 13.
6. Re-lock the grade.

No grade token is editable at stage 13 without a rollback.

## LUT swap

Triggered by /ms-color-grader lut <lut-id>.

1. Verify the LUT exists and is hashed.
2. Verify the client has authorized a rollback to gate 6.
3. Roll back to gate 6.
4. Update style-tokens.grade.lutId.
5. Re-run gate 6 through 13.

## Apply texture

Triggered by /ms-color-grader apply-texture.

1. Apply grain, halation, chromatic aberration, and vignette in order.
2. Skip the grade operations.
3. Render a preview.
4. Run texture-specific QC.
5. Update grade.json.

## Apply grade

Triggered by /ms-color-grader apply-grade.

1. Apply contrast curve, LUT, clamps, rolloff, and output transform in order.
2. Skip texture.
3. Render a preview.
4. Run grade-specific QC.
5. Update grade.json.

## QC

Triggered by /ms-color-grader qc.

1. Render a preview.
2. Read scopes: waveform, vectorscope, histogram.
3. Run the palette contrast check.
4. Verify black and white points.
5. Verify texture intensities.
6. Verify output transform.
7. Update grade.json.qa.

## Preview

Triggered by /ms-color-grader preview.

1. Render the graded master at --preview-scale.
2. Save to runs/<id>/previews/grade.mp4.
3. Hash the file.
4. Update grade.json.
5. Return the path.

## Audit

Triggered by /ms-color-grader audit.

1. Verify master hash matches timeline.json.
2. Verify every operation is in order.
3. Verify every operation's parameters match the tokens.
4. Verify the palette contrast.
5. Verify the black and white points.
6. Verify the texture.
7. Verify the output transform.
8. Verify the LUT hash.
9. Emit an audit diff.

## Report

Triggered by /ms-color-grader report.

1. Emit the operation table.
2. Emit the palette contrast table.
3. Emit the black and white point report.
4. Emit the LUT report.
5. Emit the determinism result.
6. Do not modify grade.json.

## Rollback

Triggered by ms-command rollback.

1. Re-open gate 13.
2. Restore the requested grade.json version.
3. Restore the referenced LUT and texture seeds.
4. Re-render the graded preview.
5. Re-run QC.
6. Require explicit re-approval.

## Stop conditions

Stop and present when:

- Every operation applied in order
- Every operation within tolerance
- Palette contrast all pass
- Black and white points within 1
- LUT loaded and hashed
- Output transform applied last
- Preview renders without error
- Determinism check passes
- No GRD-xx codes open
- grade.json and grade.md written

Do not keep grading past this point. Do not present a graded master with any open GRD-xx.
