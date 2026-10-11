# Delivery Package

Package structure, manifest, hash list.

## Structure

runs/<project-id>/deliverables/
package.json
sha256sums.txt
slate.mp4 | slate.png
metadata.json
metadata.md
cue-sheet.csv
license-summary.json
masters/
9x16/
master.mp4
master-burned.mp4
master.srt
master.vtt
thumbnail.png
captions/
en/master.srt
en/master.vtt
es/master.srt
es/master.vtt
1x1/
...
16x9/
...
platforms/
linkedin/
master.mp4
master-burned.mp4
master.srt
thumbnail.png
metadata.json
instagram/
...
tiktok/
...
youtube/
...
x/
...
thumbnails/
frame-0045.png
frame-0420.png
frame-0780.png
designed.png
previews/
master-preview.mp4
grade.mp4
loudness-check.mp4
thumbnails-contact.png

## package.json

{
"projectId": "string",
"packagedAt": "ISO8601",
"runtimeMs": 30000,
"fps": 30,
"aspects": ["9:16", "1:1", "16:9"],
"platforms": ["linkedin", "instagram", "tiktok", "youtube", "x"],
"masters": [
{
"aspect": "9:16",
"path": "masters/9x16/master.mp4",
"hash": "sha256:...",
"burnedPath": "masters/9x16/master-burned.mp4",
"burnedHash": "sha256:...",
"srtPath": "masters/9x16/master.srt",
"srtHash": "sha256:...",
"vttPath": "masters/9x16/master.vtt",
"vttHash": "sha256:...",
"thumbnailPath": "masters/9x16/thumbnail.png",
"thumbnailHash": "sha256:...",
"integratedLUFS": -14.0,
"truePeakDBTP": -1.0
}
],
"slate": { "path": "slate.mp4", "hash": "sha256:..." },
"metadata": { "path": "metadata.json", "hash": "sha256:..." },
"cueSheet": { "path": "cue-sheet.csv", "hash": "sha256:..." },
"licenseSummary": { "path": "license-summary.json", "hash": "sha256:..." },
"platformPackages": [
{
"platform": "linkedin",
"path": "platforms/linkedin/",
"files": [
{ "name": "master.mp4", "hash": "sha256:..." },
{ "name": "master-burned.mp4", "hash": "sha256:..." },
{ "name": "master.srt", "hash": "sha256:..." },
{ "name": "thumbnail.png", "hash": "sha256:..." },
{ "name": "metadata.json", "hash": "sha256:..." }
]
}
],
"sha256SumsPath": "sha256sums.txt",
"packageHash": "sha256:..."
}

## sha256sums.txt

Format:

<sha256> <relative-path>
<sha256> <relative-path>
...

Rules:

- Every file in the package is listed.
- Paths are relative to deliverables/.
- No file is delivered without a hash.
- The list itself is hashed and recorded.

## Platform folders

Each platform folder contains only the files that platform accepts:

- linkedin: master.mp4 (16:9 or 1:1 or 4:5), master-burned.mp4, master.srt, thumbnail.png, metadata.json
- instagram: master.mp4 (9:16 or 1:1 or 4:5), master-burned.mp4, master.srt, thumbnail.png, metadata.json
- tiktok: master.mp4 (9:16), master-burned.mp4, master.srt, thumbnail.png, metadata.json
- youtube: master.mp4 (9:16 for Shorts, 16:9 for standard), master-burned.mp4, master.srt, master.vtt, thumbnail.png, metadata.json
- x: master.mp4 (16:9 or 1:1), master-burned.mp4, master.srt, thumbnail.png, metadata.json

Rules:

- No master is delivered to a platform in an aspect that platform does not accept.
- No metadata.json is delivered without a master.
- No folder is delivered without a metadata.json.

## Metadata per platform

The metadata.json in each platform folder is the platform-specific view of the metadata pack:

- Only the fields that platform uses
- Hashtags formatted per the platform's convention
- Description formatted per the platform's convention
- Attribution and disclosures appended

## Rules

- The package is generated from master.json.
- Every file in the package is hashed.
- The package is regenerated whenever a deliverable changes.
- No file in the package is missing from sha256sums.txt.
- No file in sha256sums.txt is missing from the package.

## Audit

Triggered by /ms-finishing-suite verify.

1. Recompute every hash in the package.
2. Compare against package.json.
3. Report matched, mismatched, missing.

Any mismatch or missing file is a blocker.

## Sign-off

The package cannot pass gate 14 with any missing file, any hash mismatch, or any placeholder string.

## Reference

The package is the artifact the distribution stage (16) reads. Any downstream consumer that needs a master reads it from the package, never from the raw runs path.
