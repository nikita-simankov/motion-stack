# Script Review

Self-review checklist before gate presentation. Every box must be checked.

## Structure

- [ ] Runtime matches brief.runtime exactly, in frames
- [ ] Hook is inside frames 0-60 (or 0-90 for 90s)
- [ ] Hook lands visual, text, and audio
- [ ] Beats are contiguous with no gaps or overlaps
- [ ] Every beat is within min/max frame range
- [ ] CTA is present, explicit, and <= 120 frames
- [ ] No beat exists only to fill time

## VO

- [ ] Every line is pre-timed with frameStart, frameEnd, wordCount, targetWPM
- [ ] No line overruns its budget by more than 10%
- [ ] No line falls under 60% of its budget
- [ ] Numbers, units, and acronyms are written as spoken
- [ ] No line ends on a preposition, article, or conjunction
- [ ] Silence is explicit, not implied
- [ ] Total estimated VO seconds does not exceed the body's frame budget

## On-screen text

- [ ] No card exceeds 8 words
- [ ] No card duplicates a VO line verbatim
- [ ] Every card has a frame range
- [ ] Text that only emphasizes is cut

## Claim tracing

- [ ] Every VO line traces to a claim or is logged as connective
- [ ] Every on-screen text card traces to a claim or is logged as connective
- [ ] Every claim id exists in dossier.claims with used = true and confidence in {high, medium}
- [ ] No untraced fact appears anywhere in the script

## Brand voice

- [ ] Voice attributes match the rubric
- [ ] Tone shift matches the target platform
- [ ] Vocabulary preferences respected
- [ ] No banned terms present
- [ ] Paired-example alignment checked
- [ ] brandVoiceCheck.passed = true

## Handoff

- [ ] script.json written
- [ ] script.md rendered
- [ ] killLog populated
- [ ] connectiveLines populated
- [ ] Timing table emitted
- [ ] Gate table emitted

A single unchecked box means the gate does not pass.
