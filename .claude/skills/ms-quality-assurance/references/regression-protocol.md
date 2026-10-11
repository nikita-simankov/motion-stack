# Regression Protocol

Regression review procedure.

## Trigger

Regression runs automatically after any revision that re-opens a gate upstream of stage 15. Regression can also be triggered explicitly by /ms-quality-assurance regression.

## Rule

After any revision, QA re-runs all prior checks, not just the failed one.

Rationale: a fix at one stage can break another stage's contract. Fixing grade contrast might require a LUT change that shifts the palette, which then fails a caption contrast check downstream. Fixing audio loudness might require a re-master that shifts a frame, which then fails an alignment check.

## Procedure

1. Identify the stage that was revised.
2. Identify every downstream artifact that was marked stale.
3. Verify every stale artifact was re-run.
4. Re-run the full QA review, every criterion, every code.
5. Compare the new QA report to the prior QA report.
6. Emit the diff: criteria changed, defects resolved, defects introduced.
7. If the new report passes the floor and has no open blockers or majors: pass.
8. If the new report fails: route defects and halt.

## Diff

The diff includes:

- Criteria: score before, score after, delta
- Defects: resolved, introduced, unchanged
- Hash chain: verified unchanged except at the revised stage and downstream

## Non-regression checks

Regression also verifies:

- No previously passing criterion dropped below its floor
- No previously resolved defect reappeared
- No previously passing legal check now fails
- No previously passing accessibility check now fails

Any regression in these areas is a blocker.

## Root cause

If a regression introduces a defect at a stage that was not revised, that stage's contract is broken. The defect is routed to the stage that was revised, not to the stage where the symptom appeared.

## Rollback

If the regression cannot be resolved without unwinding the revision:

1. Roll back the revision.
2. Re-open the original gate.
3. Re-run the full chain from the original stage.
4. Re-run QA.

## Report

The regression report is appended to qa.json under a regression field:

{
"triggered": true,
"againstStage": "ms-color-grader",
"priorScore": 51,
"currentScore": 53,
"criteriaDeltas": [
{ "criterion": "visualCoherence", "before": 3, "after": 4, "delta": 1 }
],
"defectsResolved": ["D001"],
"defectsIntroduced": [],
"hashChainVerified": true,
"notes": "string"
}

## Stop conditions

Regression stops when:

- Every criterion is re-scored
- Every defect is re-verified
- The hash chain is verified
- The diff is emitted

Regression does not stop early. A partial regression is not a regression.
