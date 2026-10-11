# Voice QA

Voice QA codes and severity.

## Codes

BRD-01 Attribute drift toward the "not" side
Severity: major
Example: "the best MCP pipeline in the industry" drifts toward arrogant.
Fix: owning stage rewrites the line.

BRD-02 Tone shift mismatch for the platform
Severity: major
Example: slang on LinkedIn when the brand voice does not permit.
Fix: owning stage adapts the line.

BRD-03 Avoided term present
Severity: minor
Example: "seamless" in a caption.
Fix: owning stage rewrites the line.

BRD-04 Three or more avoided terms in one artifact
Severity: major
Example: "leverage", "seamless", and "cutting-edge" in one caption.
Fix: owning stage rewrites the artifact.

BRD-05 Banned term present
Severity: blocker
Example: "guaranteed" in a CTA.
Fix: owning stage rewrites the line. No override.

BRD-06 Paired-example misalignment
Severity: major
Example: a line reads closer to the generic than to the brand example.
Fix: owning stage rewrites the line.

BRD-07 Vocabulary preference consistently ignored
Severity: minor
Example: "users" used throughout when the rubric prefers "practitioners".
Fix: owning stage revises.

BRD-08 Voice drift across a single artifact
Severity: major
Example: the hook is confident, the proof is timid.
Fix: owning stage revises the artifact.

BRD-09 Voice drift across the run
Severity: major
Example: stage 4 script is confident, stage 16 copy is corporate.
Fix: owning stage revises. Root cause may be a rubric import from the wrong profile.

BRD-10 Banned term present in metadata or distribution copy
Severity: blocker
Example: "the best" in a hashtag.
Fix: owning stage rewrites. No override.

## Severity summary

blocker — BRD-05, BRD-10
major — BRD-01, BRD-02, BRD-04, BRD-06, BRD-08, BRD-09
minor — BRD-03, BRD-07

## Thresholds

- Attribute drift: any drift is a fail
- Tone shift: any mismatch is a fail
- Avoided terms: 1-2 minor, 3+ major
- Banned terms: any is a blocker
- Paired-example alignment: closer to generic is a fail

## Reporting

Every check emits the codes and per-code details.

## Sign-off

A stage cannot pass its gate with any open BRD-01 through BRD-10 in its artifact. Blocker codes halt the pipeline. Major codes halt the gate. Minor codes are recorded but do not halt.

## Legal note

BRD-05 and BRD-10 in the legal-risk or unsupported-superlative categories are compliance issues. Any waiver requires a written client sign-off recorded in run.json.approvals, and even then the pipeline recommends against shipping.

## Determinism

Voice checks are deterministic. Same artifact + same rubric → same result.
