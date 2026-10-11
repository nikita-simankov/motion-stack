# QA Schema

qa.json is the machine-readable QA report. qa.md is the human render. Both are read by ms-command and by the client.

## qa.json

{
"projectId": "string",
"reviewedAt": "ISO8601",
"reviewedBy": "string",
"briefVersion": "v1",
"dossierVersion": "v1",
"conceptVersion": "v1",
"scriptVersion": "v1",
"boardsVersion": "v1",
"styleframesVersion": "v1",
"tokensVersion": "v1",
"assetsVersion": "v1",
"scenesVersion": "v1",
"voVersion": "v1",
"sfxVersion": "v1",
"musicVersion": "v1",
"timelineVersion": "v1",
"gradeVersion": "v1",
"masterVersion": "v1",
"hashChain": {
"timelineSourceHash": "sha256:...",
"gradeSourceHash": "sha256:...",
"voStemHash": "sha256:...",
"sfxStemHash": "sha256:...",
"musicStemHash": "sha256:...",
"masterHash": "sha256:...",
"chainPassed": true,
"chainErrors": []
},
"score": {
"hookStrength": 4,
"pacingAndRetention": 4,
"brandVoiceFidelity": 5,
"visualCoherence": 4,
"audioMixAndLoudness": 5,
"uiMockupFidelity": 4,
"remotionRenderIntegrity": 5,
"elevenLabsVoiceQuality": 4,
"captionAccuracyAndSync": 5,
"platformNativeness": 4,
"accessibility": 4,
"metadataAndSlate": 5,
"rawScore": 53,
"maxScore": 60,
"floorPassed": true,
"strictMode": false
},
"defects": [
{
"defectId": "D001",
"code": "GRD-03",
"description": "Palette color textSecondary #A3A3A3 fell below 3:1 contrast on background after grade",
"artifact": "masters/9x16/master.mp4",
"frame": 420,
"responsibleStage": "ms-color-grader",
"rollbackTargetGate": 13,
"severity": "blocker",
"route": "reject",
"status": "open | resolved | waived"
}
],
"legal": {
"passed": true,
"codes": [],
"notes": "string"
},
"brand": {
"passed": true,
"codes": [],
"notes": "string"
},
"accessibility": {
"passed": true,
"codes": [],
"notes": "string"
},
"regression": {
"triggered": false,
"againstStage": null,
"notes": "string"
},
"escalation": {
"triggered": false,
"reason": null,
"options": []
},
"gate": {
"passed": true,
"passedAt": "ISO8601",
"nextStage": "ms-social-distributor"
}
}

## Rules

- Every version field matches the version referenced in the run registry.
- hashChain.chainPassed must be true for gate pass.
- score.floorPassed must be true for gate pass.
- Every defect carries a code, a responsible stage, a rollback target gate, and a severity.
- Any defect with severity "blocker" or "major" halts the gate.
- legal.passed, brand.passed, accessibility.passed must all be true for gate pass.
- gate.passed flips to true only when every condition holds.

## qa.md

See references/qa-report-template.md.
