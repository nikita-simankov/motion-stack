# Edit Protocol

## Assemble

Triggered by /ms-video-editor <project-id>.

1. Read all manifests.
2. Verify boards, scenes, and stems.
3. Build the master composition in src/Master.tsx.
4. Register the master composition in Root.tsx.
5. Render the preview at --preview-scale.
6. Run edit QA.
7. Write timeline.json and timeline.md.
8. Emit the gate table.

## Scene

Triggered by /ms-video-editor scene <scene-id> or after a scene rebuild.

1. Verify the scene exists in scenes.json.
2. Verify the scene's duration matches its board.
3. Replace the scene's <TransitionSeries.Sequence> in the master.
4. Re-render the preview.
5. Update timeline.json.
6. Re-run edit QA.

## Recut

Triggered by /ms-video-editor recut <transition-id>.

1. Verify the transition matches the board pair.
2. Replace the transition in the master.
3. Re-render the preview.
4. Update timeline.json.
5. Re-run edit QA for the affected cut only.

## Retime

Triggered by /ms-video-editor retime or by a scene duration change.

1. Recompute all downstream frame anchors.
2. Update timeline.json.
3. Update audio anchors if any shift (they should not, but verify).
4. Re-render the preview.
5. Re-run edit QA.

Retime is only called during assembly, before picture lock. After lock, retime is a rollback.

## Align audio

Triggered by /ms-video-editor align-audio.

1. Recompute stem anchors from the manifests.
2. Verify the anchors match the current timeline.
3. If a mismatch, adjust startFrom or re-produce the stem.
4. Update audioMap in timeline.json.
5. Re-render the preview.
6. Re-run edit QA.

## Preview

Triggered by /ms-video-editor preview.

1. Render the master at --preview-scale and --preview-fps.
2. Save to runs/<id>/previews/master.mp4.
3. Hash the file.
4. Update timeline.json.
5. Return the path.

## Lock

Triggered by /ms-video-editor lock or by an explicit approve at the gate.

1. Verify every gate criterion.
2. Compute master source hash.
3. Compute stem hashes.
4. Compute preview hash.
5. Write timeline.json with locked: true.
6. Append to run.json.approvals.
7. Advance the pipeline stage.

## Audit

Triggered by /ms-video-editor audit.

1. Verify the master source hash matches.
2. Verify every stem hash matches.
3. Verify the total runtime equals brief.runtime.frames.
4. Verify every board is represented.
5. Verify every transition matches its board pair.
6. Verify every audio anchor aligned within 1 frame.
7. Emit an audit diff.

## Report

Triggered by /ms-video-editor report.

1. Emit the cut list.
2. Emit the runtime.
3. Emit the audio mapping.
4. Emit the master composition id and preview path.
5. Do not modify timeline.json.

## Rollback

Triggered by ms-command rollback or by a downstream picture change request.

1. Re-open gate 12.
2. Set timeline.json.locked to false.
3. Clear masterSourceHash.
4. Mark downstream stale.
5. Apply the change.
6. Re-render the preview.
7. Re-run edit QA.
8. Require explicit re-lock.

## Stop conditions

Stop and present when:

- Master composition exists and registers in Root.tsx
- Master durationInFrames equals brief.runtime.frames
- Every board is represented in order
- Every transition matches its board pair
- Every audio stem is placed at frame 0 with startFrom: 0
- Every stem hash matches
- Preview renders without error
- Determinism check passes
- No CUT-xx codes are open
- timeline.json and timeline.md written

Do not keep editing past this point. Do not present a timeline with any open CUT-xx.
