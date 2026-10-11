# Asset Protocol

## Add

Triggered by /ms-asset-generator add <asset-id>.

1. Verify the asset is required by a board, style frame, or type role.
2. Produce or source the asset.
3. Optimize per asset-optimization.md.
4. Compute the SHA-256 checksum.
5. Write the license record.
6. Append to assets.json.
7. Re-run coverage checks.
8. Recompute manifestHash.

## Replace

Triggered by /ms-asset-generator replace <asset-id>.

1. Verify the asset exists.
2. Produce a new version.
3. Keep the prior version under assets/archive/.
4. Update the manifest entry with the new checksum and size.
5. Re-run coverage checks.
6. Recompute manifestHash.
7. If the replacement changes the palette or type usage, re-run style token compatibility.

## Verify

Triggered by /ms-asset-generator verify.

1. Walk every asset in the manifest.
2. Recompute the SHA-256 checksum.
3. Compare against the recorded checksum.
4. Emit a diff: matched, mismatched, missing on disk.

Any mismatch is a blocker. Any missing file is a blocker.

## Optimize

Triggered by /ms-asset-generator optimize.

1. Walk every asset.
2. Re-run the appropriate optimizer.
3. Recompute checksums.
4. Update the manifest.

Optimization never changes content, only encoding and metadata.

## Audit

Triggered by /ms-asset-generator audit.

1. Re-run coverage checks.
2. Re-run license checks.
3. Re-run loader checks.
4. Re-run frame-independence checks.
5. Re-run palette checks.
6. Emit an audit diff.

## License

Triggered by /ms-asset-generator license.

1. Emit a license report: each asset, its license, its territory, its expiry, whether attribution is required, and whether the text is appended to metadata.
2. Flag any restricted asset.
3. Do not modify the manifest.

## Rollback

Triggered by ms-command rollback.

1. Restore the requested assets.json version.
2. Restore the referenced asset files from the archive.
3. Re-verify checksums.
4. Re-open gate 7.
5. Mark downstream stale.

## Stop conditions

Stop and present when:

- Every board and style frame is resolved
- Every type role is resolved
- Every asset is optimized and hashed
- Every asset carries a cleared license
- Every asset maps to a Remotion loader
- No placeholders, no orphans without reason
- assets.json and assets.md written

Do not keep producing past this point. Do not present a manifest with any missing asset or any uncleared license.
