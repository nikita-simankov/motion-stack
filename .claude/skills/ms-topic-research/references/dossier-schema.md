# Dossier Schema

dossier.json is the machine-readable dossier. dossier.md is the human render. Downstream skills read dossier.json.

## dossier.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"depth": 8,
"recency": "any",
"minTier": 3,
"completenessScore": 0.0,
"researchQuestions": [
{
"id": "RQ1",
"question": "string",
"status": "answered | thin | unanswerable",
"reason": "string | null",
"claimIds": ["C1", "C2"]
}
],
"sources": [
{
"id": "S1",
"url": "string",
"title": "string",
"author": "string | null",
"publisher": "string | null",
"publishedAt": "ISO8601 | null",
"accessedAt": "ISO8601",
"tier": 1,
"notes": "string"
}
],
"claims": [
{
"id": "C1",
"claim": "string (one sentence, falsifiable)",
"sourceIds": ["S1"],
"tier": 1,
"confidence": "high | medium | low",
"aging": { "hasShelfLife": true, "expiresIn": "90d | null" },
"contradictedBy": ["S2"],
"used": true
}
],
"competitors": [
{
"id": "K1",
"title": "string",
"creator": "string",
"platform": "string",
"format": "string",
"length": "string",
"angle": "string",
"hook": "string",
"omissions": "string",
"signal": "string | null",
"opportunity": "string"
}
],
"angles": [
{
"id": "A1",
"thesis": "string",
"claimIds": ["C1", "C3"],
"differentiator": "string",
"audienceFit": "string",
"runtimeFit": ["30s"],
"risk": "safe | distinct | bold | experimental",
"killCriteria": "string"
}
],
"gaps": [
{ "question": "string", "reason": "string", "accepted": false }
],
"rejectedSources": [
{ "url": "string", "reason": "string" }
]
}

## Rules

- Every claim used in a downstream script must appear in claims with used: true and confidence in {high, medium}.
- Every competitor needs at least angle, hook, and opportunity filled.
- At least 3 angles required for gate pass.
- completenessScore = answered questions / total questions, weighted by claim count.
- rejectedSources is required for audit. Never silently drop a source.

## dossier.md template

MOTION STUDIO — RESEARCH DOSSIER
project-id: <project-id>
built-at: <ISO8601>
brief-version: <v>
completeness: <score>

RESEARCH QUESTIONS
RQ1 <question> <answered | thin | unanswerable>
RQ2 ...

CLAIMS (USED)
C1 <claim> T<tier> <confidence> <S1,S3>
C2 ...

CLAIMS (UNUSED)
C9 <claim> T<tier> <confidence> <reason unused>

SOURCES
S1 <title> — <publisher> — <date> T<tier>
S2 ...

COMPETITIVE LANDSCAPE
K1 <title> — <creator> — <platform> angle: <angle>
K2 ...

ANGLES
A1 <thesis> risk: <risk> runtime: <fit>
A2 ...

GAPS
<question> — <reason> accepted: <yes|no>
