# Script Protocol

## Expand

Triggered by /ms-script-writer expand.

1. Keep the current script as v1.
2. Write an alternate script against the same concept with a different structural emphasis.
3. Score both against the script review checklist.
4. Present side by side. Client selects one.
5. The unselected script is archived to runs/<project-id>/script/alternates/.

## Tighten

Triggered by /ms-script-writer tighten or when the script overruns runtime by more than 10%.

1. Identify the three longest beats.
2. For each, cut connective phrases, hedges, and restated claims.
3. If a beat is still over, drop the weakest claim in the beat and rebalance frames.
4. Re-time all lines. Re-run the timing table.
5. Do not cut the hook, the CTA, or the strongest proof.

## Retime

Triggered by /ms-script-writer retime or by a runtime change.

1. Reallocate frames from the beat-timing table for the new runtime.
2. Keep the beat order and purposes.
3. Adjust VO frameStart and frameEnd per line.
4. Recompute estimatedSeconds and fill percentage.
5. Rewrite any line that now overruns or underruns.

## Revoice

Triggered by /ms-script-writer revoice.

1. Keep beats, on-screen text, visual notes, and audio notes unchanged.
2. Rewrite only the VO lines.
3. Re-time every line.
4. Re-run claim tracing.
5. Re-run the brand voice check.

## Audit

Triggered by /ms-script-writer audit.

1. Verify every VO line and on-screen text card traces to a claim or is logged as connective.
2. Verify every claim id exists in dossier.claims with used = true and confidence in {high, medium}.
3. Verify no untraced fact appears in the script.
4. Emit an audit diff: lines traced, lines untraced, lines reclassified as connective.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested script.json version.
2. Re-open gate 4.
3. Mark downstream stale.
4. Do not auto-lock. Require explicit approve.

## Stop conditions

Stop writing and present when:

- Runtime matches brief exactly
- Hook lands visual, text, and audio inside the first 2 seconds
- Every VO line is pre-timed and within fill range
- Every non-connective line traces to a claim
- Brand voice check passed
- CTA present and timed

Do not keep polishing past this point. Do not present a script that fails any of the six.
