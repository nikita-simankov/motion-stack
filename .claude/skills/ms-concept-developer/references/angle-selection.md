# Angle Selection

How to choose which dossier angles become concepts.

## Input

dossier.angles — each with thesis, claimIds, differentiator, audienceFit, runtimeFit, risk, killCriteria.

## Filter

A dossier angle becomes a concept only if all are true:

- Every claimId it cites is used = true and confidence in {high, medium}
- Its runtimeFit includes the brief's runtime
- Its risk tier is not below the brief's concept posture (a "safe" brief can still take a "bold" angle, but a "bold" brief cannot take a "safe" angle without a note)
- It does not duplicate a competitor's lead claim from dossier.competitors

## Rank

Rank surviving angles by:

1. Differentiator strength — how far from the competitive set
2. Audience fit — how precisely it matches brief.audience
3. Claim density — number of used claims it can support

## Assign to frameworks

For each surviving angle, pick the structural family that best fits:

- Authority objective + practitioner audience → claim-first, counterintuitive, story
- Consideration objective + mixed audience → demonstration, question-first, list
- Conversion objective + decision-maker audience → contrast, demonstration
- Awareness objective + consumer audience → absurd-escalation, story, list

Do not assign two angles to the same framework in one run.

## Kill

An angle is killed (not softened) when:

- Its lead claim duplicates a competitor
- It depends on a low-confidence claim
- It needs more runtime than the brief allows
- Its kill criteria are already met by the brief's constraints

Killed angles are recorded in concepts.json under status = "killed" with a reason. They are never presented to the client.

## Regenerate

If fewer than 3 angles survive the filter, do not present a thin set. Return to the dossier with a gap note and request expand on the thinnest research question. Concept generation halts until at least 3 angles are available.
