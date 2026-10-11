# Research Protocol

## Search order

1. Primary sources first — official docs, papers, filings, standards, direct statements.
2. Named analysts and reporters who cite primaries.
3. Named practitioner blogs and conference talks.
4. Community consensus only when nothing better exists, and only for color.

## Depth limits

Per research question: default 8 sources, hard cap 20. Beyond 8, return diminishing signal and inflate review time. If the question is not answerable within 8 sources, it is probably a bad question — reframe it.

## Expansion

Triggered by /ms-topic-research expand or when completeness < 80%.

1. Identify the thinnest research question.
2. Search specifically for primary sources on that question.
3. Add claims, sources, or mark unanswerable with a reason.
4. Recompute completeness.
5. Re-run the gate.

## Audit

Triggered by /ms-topic-research audit.

1. Re-visit every source URL.
2. Confirm the claim still appears at the source.
3. Confirm the source date and tier.
4. If any source has been corrected, retracted, or moved, update and re-score.
5. Emit an audit diff: claims unchanged, changed, dropped.

## Competitor sweep

Triggered by /ms-topic-research competitors or automatically when the gate requires it.

Search the primary platform set from the brief, plus YouTube and LinkedIn, for the topic and adjacent phrasings. Capture the top 5-10 by recency and relevance. For each, record angle, hook, omissions, and opportunity. Never critique tone. Never re-post their copy verbatim.

## Angle generation

Triggered by /ms-topic-research angles.

1. Take the used claims.
2. Cluster claims by theme.
3. For each cluster, write a one-line thesis that is not present in the competitive set.
4. Attach the supporting claims.
5. Score risk against the brief's concept posture.
6. Kill any angle that duplicates a competitor's lead claim.

## Stop conditions

- Completeness >= 80% and every used claim verified
- Every research question answered or explicitly unanswerable
- At least 3 angles that survive the kill check
- No unresolved contradiction

When all four are true, stop. Do not keep searching. More research past this point costs time and does not improve the script.
