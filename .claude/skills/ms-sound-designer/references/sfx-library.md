# SFX Library

The studio SFX library is the primary source. Structure and search.

## Directory structure

runs/\_sfx/
impacts/
impact-sub-01.wav
impact-sub-02.wav
impact-kick-01.wav
...
index.json
transitions/
transition-whoosh-01.wav
transition-swipe-01.wav
transition-riser-01.wav
...
index.json
ui/
ui-click-01.wav
ui-toggle-01.wav
ui-confirm-01.wav
ui-error-01.wav
...
index.json
ambient/
ambient-room-01.wav
ambient-hum-01.wav
ambient-crowd-01.wav
...
index.json
accents/
accent-tick-01.wav
accent-blip-01.wav
accent-type-01.wav
...
index.json
risers/
riser-bright-01.wav
riser-dark-01.wav
riser-breath-01.wav
...
index.json
stingers/
stinger-brand-01.wav
stinger-brand-02.wav
...
index.json
synthesized/
(generated per project)

## Asset metadata (index.json per category)

{
"assets": [
{
"id": "impact-sub-01",
"filePath": "runs/\_sfx/impacts/impact-sub-01.wav",
"durationMs": 900,
"sampleRate": 48000,
"bitDepth": 24,
"channels": 2,
"tags": ["sub", "low", "boom", "landing"],
"peakDbfs": -3,
"rmsDbfs": -18,
"license": {
"licenseId": "CC0-1.0",
"source": "library",
"attributionRequired": false,
"clearedBy": "studio",
"clearedAt": "ISO8601"
},
"notes": "Clean sub drop, 60Hz fundamental, no tail reverb"
}
]
}

## Search rules

- Search by category first, then by tags.
- Rank candidates by: tag overlap, duration fit, spectral fit against the target board, license cleanliness.
- Never use an asset whose tags conflict with the category (e.g., a reverb-heavy impact for a tight landing).

## Rejected assets

- Any asset without a license record
- Any asset with visible clipping (peak > -1 dBFS)
- Any asset with a reverb tail longer than the placement allows
- Any asset whose character conflicts with the brief's tone (e.g., cinematic impacts in a punchy explainer)
- Any asset with a hidden origin

## Trimming and processing

- Trim only at zero-crossings or in silence
- Never cut a transient
- Fades: default 8 frames in, 12 frames out
- No EQ unless required to duck against VO
- No compression that changes the transient's attack
- No reverb added at this stage; that belongs to the placement, not the source

## Custom library assets

- Client-supplied assets are added under runs/\_sfx/<category>/client/ with a license record referencing the client agreement.
- Synthesized assets are added under runs/\_sfx/synthesized/ with a synthesis spec.

## Size

- Keep the library under 2 GB.
- Prune unused assets periodically.
- Preserve the index.

## Backup

- Library is version controlled (git-lfs or equivalent).
- Index is regenerated after any change.
