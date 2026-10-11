# Voice Protocol

## Check

Triggered by /ms-brand-voice check <stage> <artifact> or automatically at any stage whose gate requires a voice check.

1. Load the rubric.
2. Load the artifact.
3. Extract every text string.
4. Run the check procedure.
5. Emit the check report.
6. Route any failure to the current stage.
7. Record the result in the artifact's manifest.

## Check-all

Triggered by /ms-brand-voice check-all <project-id>.

1. Walk every artifact in the run.
2. Run the check on each.
3. Emit a consolidated report.
4. Route any failure to the owning stage.

## Attributes

Triggered by /ms-brand-voice attributes <project-id>.

1. Emit the attribute list.
2. Emit the paired examples.
3. Do not modify the rubric.

## Tone

Triggered by /ms-brand-voice tone <platform>.

1. Emit the platform's tone shift.
2. Emit the context shifts.
3. Do not modify the rubric.

## Vocab

Triggered by /ms-brand-voice vocab <project-id>.

1. Emit the preferred and avoided term lists.
2. Emit any whitelisted terms.
3. Do not modify the rubric.

## Banned

Triggered by /ms-brand-voice banned <project-id>.

1. Emit the banned term list.
2. Emit the detection rules.
3. Do not modify the rubric.

## Examples

Triggered by /ms-brand-voice examples <project-id>.

1. Emit the paired examples per attribute.
2. Do not modify the rubric.

## Diff

Triggered by /ms-brand-voice diff <project-id>.

1. Compare the run's artifacts against the rubric.
2. Emit per-attribute drift.
3. Emit per-platform tone mismatch.
4. Emit vocabulary misses.
5. Emit banned term occurrences.

## Import

Triggered by /ms-brand-voice import <voice-file> or by --client <profile>.

1. Validate the file against voice-schema.json.
2. Verify all required sections.
3. Verify every attribute has a paired example.
4. Verify every platform in the brief's platform set has a tone shift.
5. Verify the banned term list is non-empty.
6. Freeze the rubric.
7. Record in run.json.

## Audit

Triggered by /ms-brand-voice audit <project-id>.

1. Verify the rubric was frozen.
2. Verify every stage that requires a check has one recorded.
3. Verify no stage passed its gate with a failing check.
4. Verify every failure was routed and resolved.
5. Emit an audit diff.

## Rollback

Triggered by ms-command rollback.

1. If the rollback targets a stage that had a voice check, the check is re-opened.
2. The stage re-runs.
3. The check re-runs.
4. The result is recorded.

## Stop conditions

Stop and present when:

- Every required artifact has a check recorded
- Every failure is routed
- Every check is deterministic
- The rubric is frozen

This skill does not have its own gate. It supports the gates of the stages it checks.

## Rejected patterns

- Modifying the rubric without a rollback to the freeze
- Passing a stage without a check
- Waiving a banned term without a client sign-off
- Checking against a stale rubric
- A check without a paired example reference
- A check without a recorded result
