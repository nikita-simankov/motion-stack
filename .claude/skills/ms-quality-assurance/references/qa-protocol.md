# QA Protocol

## Score

Triggered by /ms-quality-assurance score.

1. Read every artifact in the chain.
2. Score each criterion.
3. Emit the score table.
4. Update qa.json.score.

Score does not modify artifacts.

## Defects

Triggered by /ms-quality-assurance defects.

1. Compile every defect with a code, artifact, frame, severity, and responsible stage.
2. Emit the defect table.
3. Update qa.json.defects.

## Route

Triggered by /ms-quality-assurance route <defect-id>.

1. Read the defect.
2. Determine the responsible stage from the code.
3. Determine the rollback target gate.
4. Set the route.
5. Update qa.json.defects.

## Regression

Triggered by /ms-quality-assurance regression or automatically after a revision.

See references/regression-protocol.md.

## Legal

Triggered by /ms-quality-assurance legal.

1. Verify every asset license.
2. Verify every music cue license.
3. Verify every attribution and disclosure.
4. Verify every consent record.
5. Emit the legal review.
6. Update qa.json.legal.

## Brand

Triggered by /ms-quality-assurance brand.

1. Verify voice attributes.
2. Verify tone for the target platform.
3. Verify vocabulary.
4. Verify no banned terms.
5. Emit the brand review.
6. Update qa.json.brand.

## Accessibility

Triggered by /ms-quality-assurance accessibility.

1. Verify contrast.
2. Verify captions.
3. Verify no color-only signaling.
4. Verify no seizure-threshold flashing.
5. Emit the accessibility review.
6. Update qa.json.accessibility.

## Approve

Triggered by /ms-quality-assurance approve.

1. Verify every gate condition.
2. Set qa.json.gate.passed = true.
3. Append to run.json.approvals.
4. Advance the pipeline stage to ms-social-distributor.
5. Emit the gate table.

## Reject

Triggered by /ms-quality-assurance reject or when a defect is open.

1. Compile the routing table.
2. Set qa.json.gate.passed = false.
3. Mark the responsible stages with new revision counts.
4. Roll back to the earliest gate in the routing table.
5. Mark downstream artifacts stale.
6. Emit the routing table.
7. Halt the pipeline pending revision.

## Audit

Triggered by /ms-quality-assurance audit.

1. Compare the current qa.json to the prior version.
2. Emit the diff: criteria changed, defects resolved, defects introduced.
3. Verify the hash chain.
4. Do not modify qa.json.

## Report

Triggered by /ms-quality-assurance <project-id> or automatically.

1. Compile the QA report: score, defects, legal, brand, accessibility, gate.
2. Emit qa.json and qa.md.
3. Hash both.

## Escalation

Triggered by the conditions in references/escalation-protocol.md.

1. Halt the pipeline.
2. Emit the escalation brief.
3. Wait for the client's letter.
4. Apply the resolution.
5. Re-run the affected gate(s).
6. Re-run QA.

## Rollback

Triggered by ms-command rollback.

1. Re-open gate 15.
2. Restore the requested qa.json version.
3. Re-run the review.
4. Require explicit re-approval.

## Stop conditions

Stop and present when:

- Every criterion scored
- Every defect compiled with a code and a route
- Legal, brand, and accessibility reviewed
- Hash chain verified
- Score floor evaluated
- qa.json and qa.md written

Do not keep reviewing past this point. Do not approve with any open blocker or major.
