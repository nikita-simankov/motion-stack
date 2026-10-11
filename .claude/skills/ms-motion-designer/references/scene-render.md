# Scene Render

Local render, preview render, still render.

## Local render (full resolution)

npx remotion render <composition-id> out/<scene-id>.mp4

Outputs an mp4 at composition width, height, and fps.

## Preview render

npx remotion render <composition-id> out/<scene-id>-preview.mp4 --scale=<preview-scale>

Default preview scale: 0.35. Frames stay at the composition's fps so timing reads correctly.

Preview renders are the artifact the client approves at gate 8. Not the source, not the schema — the preview.

## Still render

npx remotion still <composition-id> out/<scene-id>.png

Used for thumbnail candidates and QA stills.

## Determinism check

npx remotion render <composition-id> out/<scene-id>-run1.mp4
npx remotion render <composition-id> out/<scene-id>-run2.mp4
diff <(shasum -a 256 out/<scene-id>-run1.mp4) <(shasum -a 256 out/<scene-id>-run2.mp4)

Hashes must match. Any mismatch is a blocker. Common causes:

- Unseeded Math.random
- Date.now() at render time
- Font loading race
- External asset fetch at render time
- Environment variable read at render time

## Render time budget

Per scene at --preview-scale:

- Micro scene (<= 90 frames): <= 2s
- Short scene (<= 300 frames): <= 5s
- Medium scene (<= 600 frames): <= 12s
- Long scene (<= 1200 frames): <= 30s

Any scene over budget is flagged. Options:

- Reduce complexity
- Move heavy computation to useMemo
- Pre-compute static layers as assets (raster or svg)
- Enable Lambda for the final render

## Output paths

runs/<project-id>/previews/
B01.mp4
B02.mp4
...

Rules:

- Every scene has a preview file at gate time.
- Previews are hashed and recorded in scenes.json.
- Previews are versioned with the scene source.

## Environment

- Node 20+
- Remotion 4.0.130+ (for audio concatenation on Lambda)
- Chrome Headless Shell 123+ (auto-managed by Remotion)
- ffmpeg (auto-managed by Remotion)

Do not install a global ffmpeg. Remotion manages its own.

## Common errors

- "Composition not found" — check Root.tsx registration
- "Cannot read property X of undefined" — check defaultProps
- "Asset not found" — check staticFile path and public/ folder
- "Font not loaded" — check loadFont import and await
- "Timeout" — increase --concurrency or split the scene
- "Audio artifact at concatenation" — Lambda chunk sizes uneven, see lambda-render.md
