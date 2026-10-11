# Thumbnail Pipeline

Auto-extraction and designed thumbnail.

## Auto-extracted candidates

Triggered by /ms-finishing-suite thumbnails.

1. Identify key frames from boards.json and concept.json:
   - the hook peak (typically the highest motion or the hook number's final frame)
   - the proof peak (the strongest claim's landing frame)
   - the CTA frame
2. Render stills at those frame indices from the graded master via npx remotion still.
3. Export at the platform's thumbnail resolution:
   - 16:9 → 1280x720
   - 9:16 → 1080x1920
   - 1:1 → 1080x1080
   - 4:5 → 1080x1350
4. Save to deliverables/thumbnails/frame-<index>.png.
5. Hash each.

Rules:

- 3-5 candidates per aspect.
- No candidate from a transition frame.
- No candidate from a frame with a caption obscuring the subject.
- No candidate from a frame with a UI element occupying more than 40% of the canvas.

## Designed thumbnail

Triggered when brief.Q20 is B or C.

1. Produce src/thumbnails/Designed.tsx as a Remotion composition.
2. Size it to the platform's thumbnail resolution.
3. Use the frozen tokens and asset manifest only.
4. Include the title, key claim, or hook image per the concept.
5. Render via renderStillOnWeb() or npx remotion still.
6. Save to deliverables/thumbnails/designed.png.
7. Hash.

Rules:

- No new assets. Only assets from assets.json.
- Text legible at 25% scale.
- Title contrast against background >= 4.5:1.
- No more than 6 words of text unless the concept requires.
- No text over a busy area without a scrim or overlay.
- Font from style-tokens.type only.

## Chosen thumbnail

- Recorded in master.json.thumbnails.chosen
- Copied into every platform folder as thumbnail.png
- Hashed in sha256sums.txt

## Rules

- Every aspect in the platform set has a thumbnail.
- Every thumbnail is at the platform's resolution.
- Every thumbnail is hashed.
- No thumbnail is delivered without a source (auto-extracted frame index or designed source path).

## Rejected

- Thumbnails from ungraded masters
- Thumbnails with a watermark
- Thumbnails with a caption obscuring the subject
- Designed thumbnails using fonts or colors not in the tokens
- Thumbnails above the platform's size limit (YouTube: 2 MB)
- Thumbnails below the platform's minimum resolution

## Determinism

- Auto-extraction is deterministic.
- Designed thumbnail rendering is deterministic (same source, same output).

## Reference

A contact sheet of all candidates is preserved at runs/<id>/previews/thumbnails-contact.png for review.
