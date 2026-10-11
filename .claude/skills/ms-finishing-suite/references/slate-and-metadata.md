# Slate and Metadata

Slate generation and metadata pack.

## Slate

The slate is a short clip or a still that documents the master.

Contents:

- project-id
- project title
- runtime in frames and seconds
- fps
- codec and container
- loudness target and measured
- caption languages
- license summary reference
- delivery date
- SHA-256 of the primary master

Format:

- mp4: 5-10 frames, silent, black background with the slate text in the caption type role
- png: sidecar when the platform does not accept a slate in the video

Rules:

- The slate is generated from master.json.
- The slate is never included in the master delivered to platforms unless the brief explicitly requires it.
- The slate is included in the delivery package as a sidecar.
- The slate is hashed.

## Metadata pack

Every master carries a metadata pack. The pack is emitted as metadata.json and as metadata.md.

Fields:

- title
- description
- tags — array of strings
- hashtags — array of strings
- attribution — array of strings from asset and music licenses
- disclosures — array of strings for AI voice and any sponsored content
- cueSheetReference — path to cue-sheet.csv
- licenseSummaryReference — path to license-summary.json
- projectId
- runtimeMs
- fps
- masterAspects — array of aspects delivered

Platform-specific overrides:

- linkedin:
  - title (max 200 chars)
  - description (max 3000 chars, first 210 visible before "see more")
  - hashtags (3-5)
- instagram:
  - caption (max 2200 chars, first 125 visible)
  - hashtags (5-10 in the caption or first comment)
- tiktok:
  - caption (max 2200 chars, first 100 visible)
  - hashtags (3-5)
- youtube:
  - title (max 100 chars)
  - description (max 5000 chars, first 150 visible)
  - tags (max 500 chars total)
  - hashtags (3 in the title area; 15 max in the description)
- x:
  - post text (max 280 chars per post; thread if longer)
  - hashtags (1-2)

## Rules

- Every field is populated. No blanks.
- Every required attribution string is appended to the description.
- Every required disclosure string is appended to the description.
- No metadata string exceeds the platform's limit for its field.
- No duplicate tags.
- No hashtags that violate the platform's policy (e.g., banned hashtags).
- No misleading title or thumbnail text.

## Cue sheet reference

The metadata pack references the cue sheet from stage 11. The cue sheet is delivered alongside the masters.

## License summary

The license summary is a merged view of:

- Asset licenses from stage 7 (assets.json)
- Music licenses from stage 11 (music.json)

Format:

{
"assets": [
{ "assetId": "A001", "licenseId": "string", "territory": "worldwide", "attributionRequired": false }
],
"music": [
{ "cueId": "M001", "licenseId": "string", "library": "string", "territory": "worldwide", "monetizationAllowed": true, "contentIdCleared": true }
],
"summary": {
"totalAssets": 0,
"totalCues": 0,
"attributionRequired": 0,
"monetizationRestricted": 0,
"contentIdRestricted": 0
}
}

## Disclosure strings

AI voice disclosure (brief.Q9 = D):

"Voiceover generated with ElevenLabs AI. Disclosed in accordance with platform policy."

Sponsored content disclosure (when applicable):

"This video is sponsored by <client>."

Disclosure strings are appended to the description and, when required, rendered in the video as a lower third.

## Attribution strings

Attribution strings come from the asset and music manifests. Each string is appended to the description verbatim. Example:

"Icons by Lucide, MIT License."
"Music by Aria Fold, licensed via Epidemic Sound."

## Emitting

Triggered by /ms-finishing-suite metadata.

1. Read brief, concept, dossier keywords, asset manifest, music manifest.
2. Compose the metadata pack.
3. Emit metadata.json and metadata.md.
4. Hash both.

## Rejected

- Placeholder strings
- Empty required fields
- Metadata that misrepresents the content
- Tags that violate the platform's policy
- Attribution strings without an exact match in the license record
