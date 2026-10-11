# Motion Protocol

## Scene

Triggered by /ms-motion-designer scene <board-id>.

1. Read the board.
2. Produce src/scenes/<boardId>/index.tsx and any element files.
3. Register the composition in Root.tsx.
4. Render a local preview at --preview-scale.
5. Update scenes.json.
6. Report.

## Rebuild

Triggered by /ms-motion-designer rebuild <scene-id> or after a source change.

1. Re-read the board.
2. Diff against the current source.
3. Re-generate the scene.
4. Re-render the preview.
5. Recompute the preview hash.
6. Update scenes.json.

## Preview

Triggered by /ms-motion-designer preview <scene-id> or /ms-motion-designer preview-all.

1. Render at --preview-scale.
2. Save to runs/<id>/previews/<scene-id>.mp4.
3. Hash the file.
4. Update scenes.json.
5. Return the path.

## Register

Triggered by /ms-motion-designer register or automatically on scene build.

1. Scan src/scenes/.
2. For each scene, verify a matching board exists.
3. Produce or update the <Composition> entries in Root.tsx.
4. Verify every Composition has an id, component, durationInFrames, fps, width, height, and defaultProps.
5. Recompute compositionRegistry in scenes.json.

## Audit

Triggered by /ms-motion-designer audit.

1. Walk every board and every scene.
2. Verify one-to-one mapping.
3. Verify every motion note in boards.json maps to a Remotion primitive in the scene source.
4. Run `ms-setup/audit-motion.sh src/scenes --tokens runs/<id>/style-tokens.json --json`. Any error blocks the audit; every warning is listed (see `motion-lint.md`). This replaces the manual CSS and Tailwind scan.
5. Verify every asset used exists in assets.json.
6. Verify every token used exists in style-tokens.json.
7. Verify determinism by re-rendering one scene twice.
8. Emit an audit diff: scenes unchanged, changed, added, removed.

## Proof sheet

Triggered by /ms-motion-designer proofsheet <scene-id>.

1. Render stills every 3 frames at --preview-scale into runs/<id>/previews/<scene-id>-sheet/.
2. Build a contact sheet (ffmpeg tile) and a velocity plot for each hero element (position delta per frame).
3. Save both next to the preview. The plot makes a linear move, a missing settle, or a dead hold visible at a glance.
4. Attach the paths to scenes.json.

## Perf

Triggered by /ms-motion-designer perf.

1. Measure render time per scene at --preview-scale.
2. Estimate render time at master resolution.
3. Estimate Lambda render time and cost.
4. Report bundle size.
5. Compare to brief.Q16 budget tier.
6. Emit a table and any warnings.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested scenes.json version.
2. Restore the scene source from version control.
3. Re-render previews for the restored scenes.
4. Re-open gate 8.
5. Mark downstream stale.

## Stop conditions

Stop and present when:

- Every board has a built scene
- Every scene registers in Root.tsx
- Every scene renders without error at --preview-scale
- Determinism check passes for at least one scene
- No CSS transitions, no Tailwind animation classes
- Every motion note maps to a Remotion primitive
- Previews exist for every scene
- scenes.json and scenes.md written

Do not keep building past this point. Do not present a scene set that fails any of the eight.
