# Brief Lock

## Procedure

1. Verify all required fields are present and non-contradictory.
2. Verify openItems is either empty or explicitly accepted by the client.
3. Write runs/<project-id>/brief.json.
4. Render runs/<project-id>/brief.md from brief.json.
5. Append an approvals entry to runs/<project-id>/run.json:
   { "stage": "ms-brief-intake", "gate": "Brief locked", "who": "<approver>", "when": "<ISO8601>", "notes": "<client notes>" }
6. Set run.json.stage to "ms-topic-research".
7. Set run.json.gate for stage 1 to "passed".
8. Emit the gate table.
9. Dispatch ms-topic-research.

## brief.md template

MOTION STUDIO — LOCKED BRIEF
project-id: <project-id>
locked-at: <ISO8601>
locked-by: <approver>
client-profile: <profile | none>
preset: <preset | none>

OBJECTIVE <code> — <note>
AUDIENCE <code> — <note>
RUNTIME <seconds>s / <frames> frames @ <fps>fps
PLATFORMS <primary> + <secondaries>
TONE <code> — <note>
CONCEPT POSTURE <code> — <note>
VISUAL DIRECTION <code> — <note>
UI MOCKUP <code> — <note>
VOICEOVER <code> — <note>
DELIVERABLES <code> — <note>
REFERENCES <code> — <urls>
MUSIC <code> — <note>
AUDIO MIX <code> — <targets>
DEADLINE <code> — <date>
APPROVAL CHAIN <code> — <approvers>
BUDGET TIER <code> — <note>
MOTION STACK <code> — <renderer>
VOICE SYNTHESIS <code> — <modelId> / <voiceId>
CAPTIONS <code> — <formats>
THUMBNAIL <code> — <note>

OPEN ITEMS <list | none>
CONTRADICTIONS <list | none>

## Gate emission

After lock, emit:

BLOCKERS
none

GATES

# stage gate status rev time

1 ms-brief-intake Brief locked passed 0 <t>
2 ms-topic-research Facts verified OPEN 0 -

ARTIFACTS
v1 runs/<project-id>/brief.json
v1 runs/<project-id>/brief.md

NEXT
dispatch ms-topic-research
