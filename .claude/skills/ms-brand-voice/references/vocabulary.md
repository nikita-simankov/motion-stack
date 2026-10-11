# Vocabulary

Preferred and avoided terms.

## Preferred terms

Preferred terms are recommended. They are not enforced.

Per rubric:

- "practitioners" instead of "users"
- "shipped" instead of "released"
- "locked" instead of "finalized"
- "stems" instead of "tracks"
- "spec" instead of "specification" when length matters
- "cut" instead of "edit" when the artifact is short-form
- "claim" instead of "statement" when the artifact is a proof
- "source" instead of "reference" when the artifact is a claim

Rules:

- Preferred terms are scored as matches when used.
- Preferred terms are not defects when missed.
- A rubric can mark a preferred term as required; when required, missing it is a minor defect.

## Avoided terms

Avoided terms are flagged as minor defects.

Per rubric:

- "leverage" — corporate filler
- "utilize" — verbose
- "seamless" — overused
- "cutting-edge" — overused
- "game-changer" — overused
- "in today's world" — filler
- "let's dive in" — filler
- "at the end of the day" — filler
- "moving forward" — filler
- "circle back" — corporate filler
- "low-hanging fruit" — corporate filler
- "paradigm shift" — overused
- "best-in-class" — overused
- "state-of-the-art" — overused
- "robust" — overused unless the domain requires it
- "scalable" — overused unless the domain requires it
- "innovative" — overused
- "next-generation" — overused
- "world-class" — overused
- "future-proof" — overused

Rules:

- One avoided term is a minor defect.
- Three or more avoided terms in one artifact escalate to a major defect.
- Avoided terms do not halt the pipeline unless the rubric marks them strict.

## Detection

- Case-insensitive matching
- Stemmed matching (so "leveraging" matches "leverage", "utilization" matches "utilize")
- Word-boundary matching (so "robustly" matches "robust", but "robustness" matches only if the rubric includes it)
- Multi-word phrases matched literally

## Whitelisting

The rubric can whitelist a term for a specific domain:

- "robust" allowed if the brief is infrastructure and the term is used in a technical sense
- "scalable" allowed if the brief is system design
- "leverage" allowed if the brief is finance and the term is used in its financial sense

Whitelisting is recorded per term per brief.

## Recording

Every vocabulary check records per term: preferred matched, avoided matched, whitelisted, required-and-missing.

## Rejected patterns

- Rewriting a sentence solely to avoid an avoided term when the resulting sentence is worse
- Using an avoided term in a hook or CTA
- Using an avoided term in the metadata pack
- Using an avoided term in the distribution copy
- Applying one platform's vocabulary preferences to another platform's artifact
