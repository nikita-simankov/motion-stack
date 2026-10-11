# Voice Attributes

Attribute catalogue with failure modes. Every rubric picks 3-5 and adapts them to the brand.

## The pattern

Every attribute is a pair: a positive and a negative. The negative is the failure mode the attribute would slide into if pushed too far.

## Catalogue

### Confident, not arrogant

Positive: states claims with certainty, cites specifics.
Negative: overclaims, inflates, uses superlatives without support.
Failure example: "We are the best MCP pipeline in the industry."
Pass example: "Cuts render time from 12 seconds to 7 on the same hardware."

### Direct, not blunt

Positive: leads with the point, respects the audience's time.
Negative: commandeers attention, gives orders, dismisses context.
Failure example: "Stop wasting time. Do this."
Pass example: "Here's the pattern we keep seeing, and the fix."

### Specific, not pedantic

Positive: uses concrete numbers, names, and examples.
Negative: overloads with detail that does not serve the point.
Failure example: "We reduced latency by 847 milliseconds on the 12th percentile of requests in the EU region."
Pass example: "Cuts render time from 12 seconds to 7."

### Warm, not chummy

Positive: human, respectful, plain-spoken.
Negative: overly familiar, slangy, treating the audience as a friend at a bar.
Failure example: "Hey folks, super pumped to share this one with y'all."
Pass example: "Here's what we shipped this week."

### Technical, not jargon-heavy

Positive: uses precise terms where they help.
Negative: uses industry jargon to signal expertise.
Failure example: "We leverage best-in-class orthogonal synergies."
Pass example: "We built this on Remotion so the pipeline is deterministic."

### Measured, not timid

Positive: takes a position, acknowledges tradeoffs.
Negative: hedges everything, refuses to commit.
Failure example: "It could potentially maybe help in some cases."
Pass example: "This cuts render time in half. It costs 20% more on Lambda."

### Grounded, not dull

Positive: plain language, present tense, active voice.
Negative: flat, generic, no point of view.
Failure example: "We offer solutions that help teams achieve their goals."
Pass example: "We help operators turn messy pipelines into repeatable systems."

### Editorially sharp, not snarky

Positive: has a point of view, lands it cleanly.
Negative: mocks, sneers, punches down.
Failure example: "Anyone still using the old way is kidding themselves."
Pass example: "The old way still works. It just costs you a week per run."

### Curious, not wishy-washy

Positive: asks questions, explores.
Negative: refuses to land, defers.
Failure example: "There are many ways to think about this."
Pass example: "Here's the pattern. Here's where it breaks."

## Selection rules

- Pick 3-5 attributes.
- Every attribute must pair with the brand's actual voice. If the brand is not warm, do not include warm.
- Every attribute must have a paired example (see paired-examples.md).
- Attributes are frozen with the rubric. They are not changed per platform or per artifact.

## Failure modes

An artifact fails if it drifts toward the negative side of any attribute.

Detection:

- Confident vs arrogant: superlatives without a source, overclaims, "the best", "the only".
- Direct vs blunt: imperatives without context, dismissals of the audience.
- Specific vs pedantic: overload of numbers without a point, jargon without purpose.
- Warm vs chummy: slang, "folks", "y'all", "super pumped".
- Technical vs jargon-heavy: "leverage", "synergy", "orthogonal", "best-in-class".
- Measured vs timid: hedging stacked across a sentence.
- Grounded vs dull: filler sentences with no claim.
- Editorially sharp vs snarky: mockery, sarcasm that punches down.
- Curious vs wishy-washy: refusal to land.

## Recording

Every check records per attribute: pass, fail, or unclear. "Unclear" is treated as fail under --strict.
