# Run State

Registry, dashboard, versioning, and JSON schema. Load on any turn that reads or writes run state.

============================================================
RUN REGISTRY
============================================================

Persisted to runs/<project-id>/run.json. Re-reported every turn unless --quiet and unchanged.

project-id slug from brief
stage current skill
gate open / passed / failed / skipped
artifacts stage -> version -> path
blockers open items, printed top-of-message
revision count per stage
time in stage wall time per stage
cost tokens and revisions per stage
approvals who, when, with notes
mode manual / auto
flags active flags
intake locked intake summary
render-log Remotion render jobs, lambda invocations, chunk progress
voice-log ElevenLabs generation calls, model used, character count
token-version tokenVersion of style-tokens.json (1 or 2); migration records approved migrations

============================================================
RUN DASHBOARD
============================================================

/ms-command status renders:

BLOCKERS
<none | list>

GATES

# stage gate status rev time

1 ms-brief-intake Brief locked passed 0 2m
2 ms-topic-research Facts verified passed 1 6m
3 ms-concept-developer Concept selected OPEN 0 3m

ARTIFACTS
v1 runs/<id>/brief.md
v1 runs/<id>/dossier.md
v2 runs/<id>/concepts.md

RENDER
composition <id> frames 900 fps 30 status pending
mode local / lambda
chunks <n> completed <n>

VOICE
model eleven_multilingual_v2
voice_id <id>
characters <n>

COST
stages complete 2/17 revisions 1 tokens 41k wall 11m

NEXT
approve | revise <notes>

============================================================
ARTIFACT VERSIONING
============================================================

- Every stage writes v1, v2, v3 to runs/<id>/<stage>/
- Each version carries gate notes, timestamp, and revision reason
- Rollback targets a version, re-opens the gate, and marks downstream artifacts stale
- Stale downstream artifacts must be re-run before their gates can pass
- Remotion compositions versioned as full source trees with defaultProps snapshots

============================================================
RUN.JSON SCHEMA
============================================================

{
"projectId": "string",
"stage": "string",
"gate": "open | passed | failed | skipped",
"artifacts": {
"<stage>": {
"currentVersion": "v1",
"versions": [
{ "version": "v1", "path": "string", "notes": "string", "reason": "string", "ts": "ISO8601" }
]
}
},
"blockers": ["string"],
"revisionCount": { "<stage>": 0 },
"timeInStage": { "<stage>": "duration" },
"cost": { "tokens": 0, "revisions": 0, "wall": "duration" },
"approvals": [
{ "stage": "string", "gate": "string", "who": "string", "when": "ISO8601", "notes": "string" }
],
"mode": "manual | auto",
"flags": ["string"],
"intake": { "Q1": "string", "Q2": "string", "...": "..." },
"renderLog": [
{ "composition": "string", "frames": 0, "fps": 30, "mode": "local | lambda", "chunks": 0, "completed": 0, "status": "pending | running | done | failed" }
],
"tokenVersion": 2,
"migrations": [
{ "from": 1, "to": 2, "tone": "punchy", "approvedBy": "string", "when": "ISO8601" }
],
"voiceLog": [
{ "model": "string", "voiceId": "string", "characters": 0, "ts": "ISO8601" }
]
}
