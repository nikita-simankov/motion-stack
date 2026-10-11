# Paired Examples

Paired example catalogue per attribute.

## The pattern

Every attribute has at least one paired example. The example shows the generic version and the brand version. New artifacts are compared against the pair.

## Examples

### Confident, not arrogant

Generic: "We help businesses grow."
Brand: "We help operators turn messy pipelines into repeatable systems."

Generic: "Our solution is the best in the market."
Brand: "Cuts render time from 12 seconds to 7 on the same hardware."

### Direct, not blunt

Generic: "Stop wasting time. Do this."
Brand: "Here's the pattern we keep seeing, and the fix."

Generic: "You need to change your pipeline now."
Brand: "The old pipeline still works. It just costs you a week per run."

### Specific, not pedantic

Generic: "Improves performance by up to 40%."
Brand: "Cuts render time from 12 seconds to 7 on the same hardware."

Generic: "We reduced latency substantially."
Brand: "Latency dropped from 340 ms to 210 ms at p95."

### Warm, not chummy

Generic: "Hey folks, super pumped to share this one with y'all."
Brand: "Here's what we shipped this week."

Generic: "We're so excited to announce..."
Brand: "Here's the release, and why it matters."

### Technical, not jargon-heavy

Generic: "We leverage best-in-class orthogonal synergies."
Brand: "We built this on Remotion so the pipeline is deterministic."

Generic: "Our scalable, robust architecture..."
Brand: "The pipeline runs on Lambda with three vCPUs per render chunk."

### Measured, not timid

Generic: "It could potentially maybe help in some cases."
Brand: "This cuts render time in half. It costs 20% more on Lambda."

Generic: "We believe this might be beneficial."
Brand: "This saves 4 hours per week per editor. Here's the math."

### Grounded, not dull

Generic: "We offer solutions that help teams achieve their goals."
Brand: "We help operators turn messy pipelines into repeatable systems."

Generic: "Our platform enables efficiency."
Brand: "Renders finish in 7 seconds instead of 12."

### Editorially sharp, not snarky

Generic: "Anyone still using the old way is kidding themselves."
Brand: "The old way still works. It just costs you a week per run."

Generic: "Most teams get this wrong."
Brand: "Three out of four teams hit this failure mode in week one. Here's the pattern."

### Curious, not wishy-washy

Generic: "There are many ways to think about this."
Brand: "Here's the pattern. Here's where it breaks."

Generic: "It depends on your use case."
Brand: "If your pipeline is under 10 minutes, do X. Over 10, do Y."

## Usage

During a check:

1. For each attribute, read the artifact's relevant line(s).
2. Compare the artifact's register to the brand example.
3. If the artifact reads closer to the generic than to the brand, mark fail.

Rules:

- The check is judgment-based but anchored. The anchor is the paired example.
- A check without a paired example is rejected.
- Adding new paired examples requires a rubric revision.

## Recording

Every check records per attribute: the artifact line, the paired example used, the register match.

## Rejected patterns

- Rewriting an artifact to match the example verbatim (the example is an anchor, not a template)
- Adding an example that does not have a generic counterpart
- Using an example without attribution to an attribute
- Changing examples mid-run
