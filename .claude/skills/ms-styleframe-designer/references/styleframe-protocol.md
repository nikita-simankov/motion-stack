# Styleframe Protocol

## Expand

Triggered by /ms-styleframe-designer expand <family-id>.

1. Locate the family in styleframes.json.
2. Add a variant on a single axis not already covered.
3. Attach token references.
4. Recompute coverage and drift check.
5. Write styleframes.json and styleframes.md.

Expansion does not change the token contract. If the new variant requires a new token, that is a retoken, not an expand.

## Retoken

Triggered by /ms-styleframe-designer retoken <token-id>.

1. Verify the token is not yet frozen, or that the client has authorized a rollback.
2. Change the token value.
3. Re-run contrast checks if a palette token.
4. Re-run compatibility checks if a type, motion, or audio token.
5. Re-run the drift check against every style frame.
6. Write style-tokens.json.

If frozen:

1. Re-open gate 6.
2. Mark all downstream artifacts stale.
3. Apply the retoken.
4. Re-verify.
5. Require explicit lock.

## Compare

Triggered by /ms-styleframe-designer compare <variant-a> <variant-b>.

1. Present side by side.
2. Score each variant on: contrast, legibility, motion compatibility, brand fit, board fit.
3. Recommend one.
4. Wait for client letter.

## Import

Triggered by /ms-styleframe-designer import <token-file> or by --client / --preset.

1. Read the token file.
2. Validate against the schema.
3. Flag conflicts with the platform spec table.
4. Merge into style-tokens.json with source: "imported".
5. Re-run contrast and compatibility checks.
6. Do not freeze until the client approves.

Imported tokens cannot be edited without an override flag.

## Audit

Triggered by /ms-styleframe-designer audit.

1. Verify every board in boards.json maps to at least one family.
2. Verify every family has a selected variant.
3. Verify every token is a spec, not a reference.
4. Verify palette contrast minimums.
5. Verify motion language compatibility with boards.json.
6. Verify UI mockup spec completeness when Q8 is C or D.
7. Verify audio tokens match the platform spec table.
8. Emit an audit diff: tokens unchanged, changed, added, removed.

## Migrate

Triggered by /ms-styleframe-designer migrate or /ms-command migrate.

1. Read runs/<project-id>/style-tokens.json. Stop if `tokenVersion` is already 2.
2. Resolve the tone: `--tone`, else the brief's Q5 (A authoritative, B punchy, C measured, D kinetic).
3. Run `ms-setup/migrate-tokens.sh <v1> runs/<project-id>/style-tokens.v2.pending.json --tone <tone>`. v1 values always win.
4. `validate-tokens.sh` runs automatically. A failure stops here and prints the rule.
5. Present the diff: sections added, tone-driven choices, every v1 value unchanged. Re-open gate 6.
6. On approve: archive the v1 file as style-tokens.v1.json (read-only), write the approved v2 as style-tokens.json with `frozen: true`, clear `reapprovalRequired`, validate again, record the migration in run.json.
7. On revise: `retoken` edits the pending file; validate again.
8. Mark a downstream stage stale only if an approved change altered a value it used.

Full procedure and compatibility rules: `token-migration-v1-to-v2.md`.

## Validate

Triggered by /ms-styleframe-designer validate.

1. Run `ms-setup/validate-tokens.sh runs/<project-id>/style-tokens.json`.
2. Report each failure with its rule. Failures are blockers at gate 6.
3. A v1 file is reported as v1 (read-compatible) and is not a failure; QA records STY-05.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested style-tokens.json and styleframes.json versions.
2. Re-open gate 6.
3. Unset frozen on style-tokens.json.
4. Mark downstream stale.
5. Do not auto-freeze. Require explicit lock.

## Stop conditions

Stop and present when:

- At least 3 families produced, each with at least 1 variant
- Every board mapped to a family
- Every token authored as a spec
- Contrast, motion, UI, and audio checks pass
- validate-tokens.sh reports a valid tokenVersion 2 file
- Drift check passes
- styleframes.json, styleframes.md, style-tokens.json written

Do not keep polishing past this point. Do not present a style frame set that fails any of the six.
