# Escalation Protocol

Escalation procedure with lettered choices.

## Triggers

Escalation is required when:

- Three failed revisions on the same stage
- A defect cannot be routed to a single stage
- A legal defect that the client wants to override
- A rubric disagreement between QA and the client
- A hash mismatch that cannot be explained
- A determinism failure that repeats after a fix
- A regression that reintroduces a resolved defect

## Procedure

1. Halt the pipeline.
2. Compile the escalation brief: what happened, what was attempted, what remains unresolved.
3. Present the client with lettered choices (A-D plus E) Other).
4. Wait for the client's letter.
5. Apply the resolution.
6. Re-run the affected gate(s).
7. Re-run QA.
8. If resolved, pass. If not, escalate again with new options.

## Escalation format

Every escalation presents:

- The reason for escalation
- The prior attempts (with timestamps and outcomes)
- The cost so far (tokens, wall time, revisions)
- The options with lettered choices, one starred as the recommendation

Example:

"Escalation. Three failed revisions on stage 13 (ms-color-grader).

Attempts:
v1 — palette contrast failed on textSecondary (3.1:1, needs 3.5:1 for medium weight)
v2 — curve adjusted, textPrimary dropped to 4.2:1 (needs 4.5:1)
v3 — LUT swapped, accent hue shifted 4 degrees (tolerance 2)

Options:
A Roll back to gate 6 and revise the palette to widen contrast headroom
B\* Roll back to gate 6 and reduce the curve's mid-tone push
C Accept the accent hue shift with a written override
D Kill the grade entirely and deliver the ungraded master
E Other

Which?"

## Non-negotiables

- Legal defects cannot be waived by the client. They halt until resolved.
- Accessibility defects cannot be waived by the client without a written override and a public disclosure.
- Determinism failures cannot be waived.

## Recording

Every escalation is recorded in run.json under an escalations field:

{
"escalationId": "E001",
"triggeredAt": "ISO8601",
"reason": "string",
"attempts": [
{ "version": "v1", "outcome": "string", "ts": "ISO8601" }
],
"costSoFar": { "tokens": 0, "wallMs": 0, "revisions": 0 },
"options": [
{ "letter": "A", "label": "string", "recommended": false },
{ "letter": "B", "label": "string", "recommended": true }
],
"resolvedAt": "ISO8601 | null",
"resolution": "string | null"
}

## Post-escalation

After resolution:

1. Apply the change.
2. Re-run the affected gate(s).
3. Re-run QA, including regression.
4. If QA passes, advance.
5. If QA fails, re-escalate.

## Bounds

An escalation chain that runs more than three times for the same defect triggers a project-level escalation with the client's producer, not the pipeline.

A project that cannot resolve a defect after three escalations is paused pending a scope, budget, or creative reset.
