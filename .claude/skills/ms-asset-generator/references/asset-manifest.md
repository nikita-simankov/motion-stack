# Asset Manifest

The manifest is the contract between stage 7 and every downstream stage. It is read by ms-motion-designer, ms-sound-designer, ms-video-editor, ms-color-grader, ms-finishing-suite, and ms-social-distributor.

## Coverage checks

For every board in boards.json:

- Enumerate the assets it requires
- Verify each asset exists in assets.json
- Verify each asset's license is cleared
- Verify each asset maps to a loader
- If a board is code-only (no external assets), mark it code-only in the manifest

For every style frame family:

- Enumerate the assets it references via styleframe.tokenRefs and variant previews
- Verify each asset exists

For every type role:

- Verify the font is resolved (self-hosted, google-fonts loader, or system stack with a reason)

For every palette token:

- Verify any asset that uses the color references the token id, not a raw hex

## Missing

Any asset called for by a board, style frame, or type role but not present is a missing entry.

- missing must be empty for gate pass
- Each missing entry is a blocker with board id and required type

## Orphans

Any asset present but not referenced by a board, style frame, or type role is an orphan.

- Orphans are allowed with a stated reason (e.g., alternate variant archived for rollback)
- Orphans without a reason are removed

## Manifest hash

- manifestHash is computed over the sorted asset list, each asset serialized deterministically
- Any asset added, removed, or changed updates the hash
- The hash is recorded in run.json for rollback integrity

## Versioning

- assets.json is versioned v1, v2, v3 like every stage artifact
- On rollback to stage 7, the manifest is restored and the checksum re-verified

## Downstream usage

- ms-motion-designer imports assets by id
- ms-sound-designer references any audio-adjacent assets (SFX samples when they live under assets)
- ms-video-editor reads the manifest to know what is available for re-cutting
- ms-finishing-suite verifies checksums before master render
- ms-social-distributor re-uses assets for platform-native cuts

Any downstream stage that cannot find an asset in the manifest raises a blocker to stage 7, not stage 8.

## Render

See assets.md template in asset-schema.md.
