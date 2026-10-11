# Finishing Protocol

## Encode

Triggered by /ms-finishing-suite encode <master-id> or /ms-finishing-suite <project-id>.

1. Verify timeline.json.locked and grade.json.qa.passed.
2. Read the platform spec table.
3. For each aspect in the platform set:
   a. Configure the Remotion render for the aspect.
   b. Render the clean master.
   c. Render the burned-caption variant.
   d. Measure loudness on the clean master.
   e. If out of spec, run the loudness pass and re-mux.
   f. Hash both masters.
4. Update master.json.

## Captions

Triggered by /ms-finishing-suite captions.

1. Read script.json VO lines.
2. Split cues per the cps rule.
3. Emit SRT per aspect and per language.
4. Emit VTT per aspect and per language.
5. Enable the burned-caption layer for the burned master encode.
6. Hash every caption file.

## Slate

Triggered by /ms-finishing-suite slate.

1. Read master.json for the fields.
2. Render the slate composition.
3. Export as mp4 and png.
4. Hash.

## Thumbnails

Triggered by /ms-finishing-suite thumbnails.

1. Read boards.json and concept.json for key frames.
2. Render stills at each key frame per aspect.
3. Render the designed thumbnail when brief.Q20 is B or C.
4. Save all candidates.
5. Choose the thumbnail and record it.
6. Hash every thumbnail.

## Metadata

Triggered by /ms-finishing-suite metadata.

1. Read brief, concept, dossier keywords, asset manifest, music manifest.
2. Compose the metadata pack.
3. Emit metadata.json and metadata.md.
4. Build the platform-specific views.
5. Hash.

## Package

Triggered by /ms-finishing-suite package.

1. Build the deliverables/ tree.
2. Copy masters, burned masters, captions, thumbnails, slate, metadata, cue sheet, license summary.
3. Build platform folders.
4. Emit sha256sums.txt.
5. Emit package.json.
6. Hash the package.

## Verify

Triggered by /ms-finishing-suite verify.

1. Walk every file in the package.
2. Recompute SHA-256.
3. Compare against package.json.
4. Emit a diff: matched, mismatched, missing.

## Audit

Triggered by /ms-finishing-suite audit.

1. Verify every master's codec, resolution, aspect, bitrate, and loudness.
2. Verify captions.
3. Verify slate.
4. Verify thumbnails.
5. Verify metadata.
6. Verify the package.
7. Emit an audit diff.

## Report

Triggered by /ms-finishing-suite report.

1. Emit the master table.
2. Emit the caption table.
3. Emit the thumbnail table.
4. Emit the metadata summary.
5. Emit the package summary.
6. Do not modify master.json.

## Rollback

Triggered by ms-command rollback.

1. Re-open gate 14.
2. Restore the requested master.json version.
3. Restore the referenced deliverable files.
4. Re-verify hashes.
5. Require explicit re-approval.

## Stop conditions

Stop and present when:

- Every aspect in the platform set has a master
- Every master matches the platform spec on codec, resolution, aspect, bitrate, and loudness
- Burned captions and sidecars exist
- Slate, thumbnails, metadata, cue sheet, and license summary are present
- The package is assembled and hashed
- No FIN-xx codes open
- master.json and master.md written

Do not keep encoding past this point. Do not present a package with any open FIN-xx.
