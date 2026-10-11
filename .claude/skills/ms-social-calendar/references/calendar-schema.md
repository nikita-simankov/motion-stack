# Calendar Schema

calendar.json is the machine-readable calendar. calendar.md is the human render. calendar.ics and calendar.csv are the interchange formats.

## calendar.json

{
"projectId": "string",
"builtAt": "ISO8601",
"distributionVersion": "v1",
"masterVersion": "v1",
"startDate": "ISO8601",
"endDate": "ISO8601",
"timezone": "America/New_York",
"crossPostStrategy": "staggered | same-day | drip",
"cadence": {
"waves": 1,
"rePostWaves": 0,
"perPlatform": {
"linkedin": 1,
"instagram": 1,
"tiktok": 1,
"youtube": 1,
"x": 1
}
},
"waves": [
{
"waveId": "W1",
"label": "primary",
"startDate": "ISO8601",
"endDate": "ISO8601",
"platforms": ["linkedin", "x", "instagram", "youtube", "tiktok"]
}
],
"slots": [
{
"slotId": "SL001",
"waveId": "W1",
"sequenceId": "SEQ-linkedin-1",
"platform": "linkedin",
"scheduledAt": "2025-01-21T08:30:00-05:00",
"window": "linkedin-morning",
"contentPath": "runs/<id>/distribution/linkedin/master.mp4",
"contentHash": "sha256:...",
"metadataPath": "runs/<id>/distribution/linkedin/metadata.json",
"metadataHash": "sha256:...",
"thumbnailPath": "runs/<id>/distribution/linkedin/thumbnail.png",
"thumbnailHash": "sha256:...",
"caption": "string",
"hashtags": ["string"],
"status": "scheduled | pushed | posted | failed | skipped",
"externalId": "string | null",
"notes": "string"
}
],
"interchange": {
"icsPath": "runs/<id>/calendar.ics",
"icsHash": "sha256:...",
"csvPath": "runs/<id>/calendar.csv",
"csvHash": "sha256:...",
"jsonPath": "runs/<id>/calendar.json",
"jsonHash": "sha256:..."
},
"push": {
"integration": "buffer | later | hootsuite | metricool | native | null",
"pushedAt": "ISO8601 | null",
"pushedSlots": 0,
"failedSlots": 0,
"externalIds": [
{ "slotId": "SL001", "externalId": "string" }
]
},
"qa": {
"passed": true,
"codes": [],
"notes": "string"
}
}

## Rules

- Every platform in the distribution pack has at least one slot.
- Every slot's scheduledAt falls inside its platform's posting window.
- No two slots on the same platform share a calendar day unless the brief allows.
- No slot references a file that does not exist in the distribution pack.
- contentHash, metadataHash, thumbnailHash match the files on disk.
- Push block is required when --push is set.
- qa.codes must be empty for gate pass.

## calendar.md

See references/calendar-report-template.md.
