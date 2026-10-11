# Concept Scoring

Scored 0-5 per criterion. Weighted total out of 95.

## Weights

Hook strength (first 2s) weight 3 max 15
Differentiation vs competitors weight 3 max 15
Audience fit weight 3 max 15
Brief fit (objective + tone) weight 3 max 15
Runtime feasibility weight 2 max 10
Production feasibility weight 2 max 10
Brand voice fit weight 2 max 10
Risk alignment with posture weight 1 max 5
--------
total 95

## Anchors

### Hook strength

5 — Would stop the scroll on its own. Specific, surprising, earned.
4 — Strong hook, specific, low risk of feeling generic.
3 — Clear hook, but a competitor could have written it.
2 — Vague or slow. Audience would keep scrolling.
1 — No hook present, or the hook is the thesis restated.
0 — Actively repels the target audience.

Rejection rule: any concept scoring below 3 is killed outright.

### Differentiation vs competitors

5 — No competitor is leading with this. Would stand out in a search.
4 — Similar topic, distinct lead claim.
3 — Same lead claim, distinct execution.
2 — Same lead claim, same execution.
1 — Derivative.
0 — Direct duplication.

### Audience fit

5 — Speaks the audience's language, anticipates their objection.
4 — Aligned to role and sophistication.
3 — Aligned to role, not sophistication.
2 — Wrong register.
1 — Wrong audience.
0 — Actively alienates.

### Brief fit

5 — Objective and tone both served precisely.
4 — Objective served, tone close.
3 — One of the two slightly off.
2 — One of the two clearly off.
1 — Both off.
0 — Contradicts the brief.

### Runtime feasibility

5 — Beat map fits the runtime with room to breathe.
4 — Fits, tight but doable.
3 — Fits with cuts at the script stage.
2 — Requires dropping a beat that matters.
1 — Requires dropping the CTA or the hook.
0 — Cannot be delivered in the runtime.

### Production feasibility

5 — All assets and UI mockups are standard and available.
4 — One non-standard asset, achievable.
3 — Two non-standard assets, tight.
2 — Requires a capability not in the stack.
1 — Requires capabilities outside Remotion or ElevenLabs.
0 — Not producible.

### Brand voice fit

5 — Concept is native to the brand's voice.
4 — Concept adapts cleanly.
3 — Concept needs slight rewording.
2 — Concept fights the voice.
1 — Concept requires a voice the brand doesn't have.
0 — Contradicts the brand.

### Risk alignment with posture

5 — Risk tier exactly matches the brief's concept posture.
4 — One tier apart.
3 — Two tiers apart, defensible.
2 — Two tiers apart, hard to justify.
1 — Three tiers apart.
0 — Four tiers apart or actively wrong.

## Computation

weightedTotal = sum(score \* weight)

## Floors

Minimum to advance: 60
Recommended minimum: 75
Hook strength below 3: reject regardless of total

## Tiebreak

If two concepts are within 3 points of weightedTotal, run a head-to-head on Hook strength and Differentiation only, in that order.

- Higher hook strength wins
- If tied, higher differentiation wins
- If still tied, escalate to the client with a two-option question

Never advance a tie silently.
