# Voice Schema

voice.json is the machine-readable rubric. voice.md is the human render. Every stage's brand-voice check reads voice.json.

## voice.json

{
"voiceId": "string",
"frozenAt": "ISO8601",
"frozenBy": "string",
"source": "project | client | studio",
"attributes": [
{
"id": "ATTR-01",
"positive": "Confident",
"negative": "arrogant",
"description": "State claims with certainty; do not inflate them.",
"exampleId": "EX-01"
}
],
"toneShifts": {
"linkedin": {
"register": "professional-measured-specific",
"energy": "low-medium",
"emoji": false,
"notes": "No slang. No hashtag in the first line."
},
"instagram": {
"register": "conversational-energetic",
"energy": "medium-high",
"emoji": "allowed",
"notes": "Emoji allowed when the brand voice permits."
},
"tiktok": {
"register": "native-casual-first-person",
"energy": "high",
"emoji": "allowed",
"notes": "Conversational. No corporate register."
},
"youtube": {
"register": "explanatory-question-forward",
"energy": "medium",
"emoji": "sparing",
"notes": "Slightly more formal than TikTok."
},
"x": {
"register": "compressed-declarative",
"energy": "medium",
"emoji": "sparing",
"notes": "Thread-native. No filler."
}
},
"contextShifts": {
"hook": { "energy": "highest" },
"proof": { "energy": "lowest", "specificity": "highest" },
"objection": { "register": "calm-direct" },
"cta": { "register": "clear-single-action" }
},
"vocabulary": {
"preferred": [
{ "use": "practitioners", "instead": "users" },
{ "use": "shipped", "instead": "released" },
{ "use": "locked", "instead": "finalized" }
],
"avoided": [
{ "term": "leverage", "reason": "corporate filler" },
{ "term": "utilize", "reason": "verbose" },
{ "term": "seamless", "reason": "overused" },
{ "term": "cutting-edge", "reason": "overused" },
{ "term": "game-changer", "reason": "overused" },
{ "term": "in today's world", "reason": "filler" },
{ "term": "let's dive in", "reason": "filler" }
]
},
"banned": [
{ "term": "guaranteed", "reason": "legal risk" },
{ "term": "risk-free", "reason": "legal risk" },
{ "term": "100%", "reason": "implies a guarantee" },
{ "term": "the only", "reason": "unsupported superlative" },
{ "term": "the best", "reason": "unsupported superlative" },
{ "term": "the first", "reason": "unsupported superlative unless sourced" },
{ "term": "cures", "reason": "health claim" },
{ "term": "prevents", "reason": "health claim" },
{ "term": "eliminates", "reason": "overclaim" },
{ "term": "revolutionary", "reason": "overclaim" },
{ "term": "disrupt", "reason": "overclaim" },
{ "term": "synergy", "reason": "corporate filler" }
],
"pairedExamples": [
{
"exampleId": "EX-01",
"attributeId": "ATTR-01",
"generic": "We help businesses grow.",
"brand": "We help operators turn messy pipelines into repeatable systems."
},
{
"exampleId": "EX-02",
"attributeId": "ATTR-02",
"generic": "Improves performance by up to 40%.",
"brand": "Cuts render time from 12 seconds to 7 on the same hardware."
}
],
"strict": true
}

## Rules

- attributes has 3-5 entries, each with a positive and a negative clause.
- Every attribute has at least one paired example.
- Every platform in the brief's platform set has a tone shift.
- Every context has a tone or register rule.
- vocabulary.preferred is a list of { use, instead } pairs.
- vocabulary.avoided is a list of { term, reason }.
- banned is a list of { term, reason }.
- strict is true by default.
- frozenAt and frozenBy are required on import.

## voice.md

Render with:

- Attributes list
- Tone shift table per platform
- Context shift table
- Preferred vocabulary table
- Avoided vocabulary table
- Banned term table
- Paired examples per attribute
