# Cue Sheet

The cue sheet is the legal artifact that lets the video ship. It lists every cue with the required metadata.

## CSV columns

cueId, cueType, frameStart, frameEnd, durationFrames, durationMs, trackTitle, trackArtist, trackComposer, trackPublisher, library, licenseId, isrc, usage, territory, platformScope, monetizationAllowed, contentIdCleared, expiry, clearedBy, clearedAt

## Example CSV

cueId,cueType,frameStart,frameEnd,durationFrames,durationMs,trackTitle,trackArtist,trackComposer,trackPublisher,library,licenseId,isrc,usage,territory,platformScope,monetizationAllowed,contentIdCleared,expiry,clearedBy,clearedAt
M001,main,0,900,900,30000,"Signal Drift","Aria Fold","A. Fold","Epidemic Sound",Epidemic,EP-12345,SE1234567890,background,worldwide,"linkedin|instagram|tiktok|youtube|x",true,true,,studio,2025-01-15T10:00:00Z
M002,hit,660,676,16,533,"Impact A","Studio","Studio","Studio",original,ORIG-001,,feature,worldwide,"linkedin|instagram|tiktok|youtube|x",true,true,,studio,2025-01-15T10:00:00Z

## Field definitions

cueId
Unique per project. Format: M001, M002, ...

cueType
main | intro | transition | drop | hit | out | stinger | silence

frameStart, frameEnd
Integers. Inclusive start, exclusive end.

durationFrames
frameEnd - frameStart

durationMs
(durationFrames / fps) \* 1000

trackTitle, trackArtist, trackComposer, trackPublisher
From the library metadata. "Studio" for original cues. "Client" for client-supplied.

library
Epidemic | Artlist | Musicbed | Soundstripe | YouTube Audio Library | original | client

licenseId
SPDX identifier or library reference. ORIG-XXX for original cues. CLIENT-XXX for client-supplied.

isrc
International Standard Recording Code, if available. Empty otherwise.

usage
background | feature | stinger

territory
worldwide or a restricted region string

platformScope
Pipe-separated list of platforms from brief.Q4

monetizationAllowed
true | false

contentIdCleared
true | false

expiry
ISO8601 or empty

clearedBy, clearedAt
Who cleared the license and when

## Emitting the cue sheet

Triggered by /ms-music-supervisor cuesheet or automatically on gate pass.

1. Walk every cue in music.json.
2. Emit the CSV to runs/<id>/cue-sheet.csv.
3. Emit a human-readable table in music.md.
4. Hash the CSV and record in music.json.

## Rules

- Every column is required.
- Empty values are allowed only where noted.
- No cue is emitted without a licenseId and clearedBy.
- The cue sheet is regenerated whenever a cue changes.
- The cue sheet is delivered with the master.

## Distribution

- Delivered to the client with the master.
- Delivered to the platform's rights team when requested.
- Retained in the run archive for the duration of the license plus 3 years.

## Compliance

- The cue sheet is a legal document. Do not edit by hand.
- Any change to a cue regenerates the cue sheet.
- Any discrepancy between music.json and cue-sheet.csv is a gate failure.
