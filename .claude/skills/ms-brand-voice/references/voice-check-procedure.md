# Voice Check Procedure

Deterministic check procedure.

## Inputs

- artifact — the file or manifest to check
- rubric — voice.json
- stage — the stage that owns the artifact
- platform — the platform the artifact is for (when applicable)
- flags — strict (default), verbose, report-only

## Procedure

1. Load the rubric.
2. Load the artifact.
3. Extract every text string from the artifact:
   - VO lines
   - On-screen text
   - Captions
   - Metadata fields
   - Thumbnail text
   - CTA
   - Hashtags
4. For each attribute:
   a. Compare the artifact's register to the attribute.
   b. Compare to the paired example.
   c. Record pass, fail, or unclear.
5. For each platform in scope:
   a. Compare the artifact's register to the platform's tone shift.
   b. Record pass or fail.
6. Scan for preferred terms. Record matches.
7. Scan for avoided terms. Record matches.
   - 1-2 matches: minor defect
   - 3+ matches: major defect
8. Scan for banned terms. Record matches.
   - Any match: blocker
9. Compare against paired examples for alignment.
10. Emit the check report.

## Determinism

Same artifact + same rubric → same result. No randomness. No judgment drift.

## Recording

The check report is recorded in the stage's artifact manifest under brandVoiceCheck:

{
"passed": true | false,
"checkedAt": "ISO8601",
"artifact": "string",
"attributes": [
{ "id": "ATTR-01", "result": "pass", "example": "EX-01", "line": "string" }
],
"toneShifts": [
{ "platform": "linkedin", "result": "pass" }
],
"vocabulary": {
"preferredMatched": ["practitioners"],
"avoidedMatched": ["seamless"],
"avoidedCount": 1
},
"banned": [
{ "term": "guaranteed", "line": "string", "severity": "blocker" }
],
"codes": ["BRD-03"],
"notes": "string"
}

## Failures

- BRD-05 or BRD-10 — blocker. Halt.
- BRD-01, BRD-02, BRD-04, BRD-06, BRD-08, BRD-09 — major. Halt the gate.
- BRD-03, BRD-07 — minor. Record.

## Routing

- Any failure routes to the current stage, not to ms-brand-voice.
- The stage re-runs its own artifact.
- The stage re-runs its voice check.
- The stage re-runs its gate.

## Rejected patterns

- Checking only the VO and not the on-screen text
- Checking only the video and not the metadata
- Checking with a stale rubric
- Checking without recording the result
- Passing a stage with a failing voice check
- Waiving a banned term without a client sign-off in run.json.approvals

## Report-only mode

When --report-only is set, the check runs but does not fail the gate. Used for audit only.

## Verbose mode

When --verbose is set, the report includes:

- Per-attribute reasoning
- Per-platform register comparison
- Every preferred and avoided term matched
- Every banned term with context
