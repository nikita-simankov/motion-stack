# Picture Lock

Freeze procedure. Hash. Downstream freeze.

## Lock procedure

1. Verify every gate criterion is met (see SKILL.md, GATE 12).
2. Compute the SHA-256 of src/Master.tsx and src/Root.tsx.
3. Compute the SHA-256 of every stem file.
4. Compute the SHA-256 of the preview render.
5. Write timeline.json with locked: true, lockedAt, and masterSourceHash.
6. Append to run.json.approvals:
   { "stage": "ms-video-editor", "gate": "Picture lock", "who": "<approver>", "when": "<ISO8601>", "notes": "<client notes>" }
7. Set run.json.stage to "ms-color-grader".
8. Set the gate for stage 12 to "passed".
9. Emit the gate table.
10. Dispatch ms-color-grader.

## Downstream freeze

After lock:

- No scene duration changes
- No cut moves
- No transition changes
- No audio anchor moves
- No scene added or removed
- No scene source change that alters rendered frames

The following stages operate on the locked picture:

- ms-color-grader applies grade
- ms-finishing-suite applies output transform, captions, and master encode
- ms-quality-assurance reviews
- ms-social-distributor generates platform-native cuts
- ms-social-calendar schedules

None of these stages alter the picture's frame timing.

## Rollback

Any change to the picture after lock requires a rollback:

1. Re-open gate 12.
2. Set timeline.json.locked to false.
3. Clear masterSourceHash.
4. Mark all downstream artifacts stale.
5. Apply the change (scene edit, cut change, transition change, audio move).
6. Re-render the preview.
7. Re-run edit QA.
8. Require explicit re-lock.

Rollback reasons are recorded in run.json.approvals with a code:

- RL-SCENE — a scene change
- RL-CUT — a cut change
- RL-TRANS — a transition change
- RL-AUDIO — an audio anchor change
- RL-RUNTIME — a runtime change

## Runtime changes

A runtime change is a rollback to gate 3 (concept) or gate 4 (script) depending on scope:

- Small runtime change (e.g., +0.5s) — rollback to gate 4 (script), retime lines, rebuild boards if needed, rebuild scenes, re-assemble.
- Large runtime change (e.g., from 30s to 60s) — rollback to gate 3, re-concept, re-script, re-board, rebuild.

The editor never stretches the timeline to accommodate a runtime change.

## Hash integrity

- masterSourceHash is recorded in run.json and timeline.json.
- Any change to Master.tsx or Root.tsx after lock invalidates the hash.
- The finishing stage verifies the hash before master encode.
- Any mismatch halts the pipeline with a specific error.

## Preview hash

- The preview hash is recorded at lock.
- The hash is re-verified at the finish stage.
- Any drift between the preview hash and the rendered master hash (accounting for resolution) is a QA defect.

## Audit

Triggered by /ms-video-editor audit.

1. Verify the master source hash matches the recorded value.
2. Verify every stem hash matches.
3. Verify the total runtime equals brief.runtime.frames.
4. Verify every board is represented.
5. Verify every transition matches its board pair.
6. Verify every audio anchor aligned within 1 frame.
7. Emit an audit diff.

## Rejected patterns

- Editing the master source without rolling back
- Regenerating a stem without rolling back
- Moving a cut by a frame without rolling back
- Any downstream stage writing to Master.tsx or Root.tsx
- Any downstream stage editing timeline.json
