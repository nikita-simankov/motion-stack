# Brief Schema

brief.json is the single source of truth for the run. brief.md is the human-readable render.

## brief.json

{
"projectId": "string (slug, unique)",
"lockedAt": "ISO8601",
"lockedBy": "string",
"clientProfile": "string | null",
"preset": "string | null",
"objective": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"audience": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"runtime": { "seconds": 30, "frames": 900, "fps": 30, "defaulted": false },
"platforms": { "primary": "string", "secondaries": ["string"], "defaulted": false },
"tone": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"conceptPosture": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"visualDirection": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"uiMockupPosture": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"voiceoverPosture": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"deliverables": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"references": { "code": "A|B|C|D|E", "urls": ["string"], "defaulted": false },
"music": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"audioMix": { "code": "A|B|C|D|E", "targets": { "integrated": "-14 LUFS", "truePeak": "-1 dBTP", "vo": "-16 LUFS", "musicDuck": "-18 LUFS", "sfx": "-20 LUFS" }, "defaulted": false },
"deadline": { "code": "A|B|C|D|E", "date": "ISO8601 | null", "defaulted": false },
"approvalChain": { "code": "A|B|C|D|E", "approvers": ["string"], "defaulted": false },
"budgetTier": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"motionStack": { "code": "A|B|C|D|E", "renderer": "local | lambda", "defaulted": false },
"voiceSynthesis": { "code": "A|B|C|D|E", "modelId": "string", "voiceId": "string | null", "defaulted": false },
"captions": { "code": "A|B|C|D|E", "formats": ["string"], "defaulted": false },
"thumbnail": { "code": "A|B|C|D|E", "note": "string", "defaulted": false },
"openItems": ["string"],
"contradictions": ["string"],
"intakeLog": [
{ "q": 1, "asked": "ISO8601", "answered": "ISO8601", "source": "client | profile | preset | default" }
]
}

## Rules

- Every field carries "defaulted": true|false. Any true adds an entry to openItems.
- "source" records where the answer came from. Inherited answers from profile or preset are not open items.
- Contradictions are recorded but must be empty at lock time.
- brief.md is generated from brief.json by a deterministic template. Do not hand-edit brief.md.
- Downstream skills read brief.json, not brief.md.
