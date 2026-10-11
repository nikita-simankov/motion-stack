# Revision Protocol

## Single-question revision

Client sends: "revise 5"

1. Re-ask question 5 only, with the same lettered choices.
2. Overwrite the field in brief.json.
3. If the new answer contradicts another field, present a reconciliation question before proceeding.
4. Re-render brief.md.
5. Re-print the Intake Summary.
6. Ask: "lock brief? [yes / revise <n>]".

Do not re-ask any other question. Do not unwind answered fields.

## Post-lock revision

If the brief is already locked and the client wants a change:

1. Re-open gate 1.
2. Mark all downstream artifacts stale.
3. Apply the revision to brief.json.
4. Re-run the contradiction check across the whole brief, not just the changed field.
5. Re-render brief.md.
6. Re-ask for lock.

## Rollback

If ms-command issues rollback for stage 1:

1. Restore the requested brief.json version.
2. Re-open gate 1.
3. Mark downstream stale.
4. Do not auto-lock. Require explicit "lock brief? [yes]".

## Contradiction reconciliation

When two fields conflict, present the reconciliation as a single question with lettered choices. Never present two questions. Never resolve silently.

Format:

"Conflict: <field A> says <value>, <field B> says <value>.
A Keep <field A>, adjust <field B>
B\* Keep <field B>, adjust <field A>
C Change both — I'll specify
D Other

Which?"

Apply the answer, clear the contradiction entry, continue.
