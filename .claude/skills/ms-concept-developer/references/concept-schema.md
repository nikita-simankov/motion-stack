# Concept Schema

concepts.json is the machine-readable concept set. concept.md is the human render of the winner. Downstream stages read concepts.json.

## concepts.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"dossierVersion": "v1",
"count": 4,
"concepts": [
{
"id": "A",
"workingTitle": "string",
"angleId": "A1",
"structuralFamily": "claim-first | question-first | contrast | demonstration | story | list | absurd-escalation | counterintuitive",
"thesis": "string (<= 12 words)",
"hook": "string (one sentence, what is seen and heard in the first 2s)",
"beatMap": [
{
"beat": 1,
"purpose": "hook | proof | objection | landing | cta",
"description": "string",
"claimIds": ["C1"],
"frameStart": 0,
"frameEnd": 90
}
],
"visualPosture": "string",
"uiPosture": "string | null",
"audioPosture": {
"vo": "string",
"music": "string",
"sfx": "string"
},
"cta": "string",
"runtime": { "seconds": 30, "frames": 900, "fps": 30 },
"riskTier": "safe | distinct | bold | experimental",
"killCriteria": "string",
"score": {
"hookStrength": 0,
"differentiation": 0,
"audienceFit": 0,
"briefFit": 0,
"runtimeFeasibility": 0,
"productionFeasibility": 0,
"brandVoiceFit": 0,
"riskAlignment": 0,
"weightedTotal": 0.0
},
"status": "active | selected | alternate | archived | killed"
}
],
"selectedId": "string | null",
"selectedAt": "ISO8601 | null",
"selectedBy": "string | null",
"tiebreaks": [
{ "between": ["A", "B"], "criterion": "hookStrength", "winner": "A", "reason": "string" }
]
}

## Rules

- count must be >= 3 for gate pass.
- No two concepts share structuralFamily.
- Every beatMap entry carries at least one claimId from dossier.claims where used = true.
- Frame ranges must be contiguous and total the runtime frames.
- score.weightedTotal computed from rubric weights in concept-scoring.md.
- selectedId must reference a concept with status = "selected".
- Alternates keep status = "alternate". Killed concepts keep status = "killed" with a reason in killCriteria.

## concept.md template

MOTION STUDIO — SELECTED CONCEPT
project-id: <project-id>
concept-id: <id>
working-title: <title>
angle: <angleId>
structure: <structuralFamily>
runtime: <seconds>s / <frames> frames
risk: <riskTier>
score: <weightedTotal>

THESIS
<thesis>

HOOK (FIRST 2s)
<hook>

BEAT MAP
1 <beat> frames <start>-<end> claims <C1, C3> <description>
2 ...

VISUAL POSTURE
<visualPosture>

UI POSTURE
<uiPosture | none>

AUDIO POSTURE
VO: <vo>
Music: <music>
SFX: <sfx>

CTA
<cta>

KILL CRITERIA
<killCriteria>
