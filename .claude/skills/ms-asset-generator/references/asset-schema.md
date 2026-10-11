# Asset Schema

assets.json is the machine-readable manifest. assets.md is the human render. Downstream stages read assets.json.

## assets.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"boardsVersion": "v1",
"styleframesVersion": "v1",
"tokensVersion": "v1",
"assets": [
{
"id": "A001",
"type": "svg | webp | png | jpg | tsx | lottie | rive | glb | gltf | woff2 | google-fonts | data",
"format": "string",
"dimensions": { "widthPx": 0, "heightPx": 0, "viewBox": "0 0 0 0 | null" },
"purpose": "hook | body | ui | cta | texture | font | data",
"boardIds": ["B01"],
"styleframeIds": ["F1-v1"],
"tokenRefs": ["palette.accentPrimary", "type.hook"],
"license": {
"licenseId": "string",
"source": "authored | client-supplied | licensed-library | public-domain",
"attributionRequired": false,
"attributionText": null,
"territory": "worldwide | string",
"expiry": null,
"clearedBy": "string",
"clearedAt": "ISO8601"
},
"checksum": "sha256:...",
"sizeBytes": 0,
"path": "runs/<project-id>/assets/A001.svg",
"loader": "inline-svg | img-staticfile | lottie | rive | three-canvas | font-face | react-component | data-component",
"optimized": true
}
],
"coverage": {
"boardsResolved": 0,
"boardsUnresolved": [],
"styleframesResolved": 0,
"styleframesUnresolved": [],
"typeRolesResolved": 0,
"typeRolesUnresolved": []
},
"missing": [],
"orphans": [
{ "id": "A900", "reason": "string" }
],
"licenseSummary": {
"cleared": 0,
"flagged": 0,
"missing": 0
},
"manifestHash": "sha256:..."
}

## Rules

- Every asset carries a license record.
- Every asset carries a SHA-256 checksum.
- Every asset maps to a named Remotion loader.
- coverage.boardsUnresolved, styleframesUnresolved, and typeRolesUnresolved must be empty for gate pass.
- missing must be empty for gate pass.
- Every orphan entry requires a stated reason.
- manifestHash is computed over the sorted asset list.
- The manifest is regenerated whenever any asset changes.

## assets.md template

MOTION STUDIO — ASSET MANIFEST
project-id: <project-id>
built-at: <ISO8601>
boards-version: <v>
tokens-version: <v>
assets: <count>

COVERAGE
boards resolved: <n>/<total>
boards unresolved: <none | list>
styleframes resolved: <n>/<total>
styleframes unresolved: <none | list>
type roles resolved: <n>/<total>

LICENSE
cleared: <n>
flagged: <n>
missing: <n>

ASSETS
A001 svg 1200x800 hook B01 authored sha256:... inline-svg
A002 webp 2160x3840 body B02,B03 licensed sha256:... img-staticfile
A003 tsx - ui B04,B05 authored sha256:... react-component
...

ORPHANS
<id> <reason>
...

NEXT
<approve | revise <notes>>
