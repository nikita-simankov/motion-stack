# Distribution Protocol

## Cut

Triggered by /ms-social-distributor cut <platform>.

1. Read the platform rules.
2. Determine aspect, duration, codec, bitrate, loudness.
3. If aspect differs from the master, re-render at the platform aspect.
4. If duration differs, re-cut from the beat map.
5. Render the cut.
6. Measure loudness and true peak.
7. Hash and record.

## Hook

Triggered by /ms-social-distributor hook <platform>.

1. Read the master hook.
2. Read the platform's hook culture.
3. If the master hook fits, use it. Otherwise, re-cut from the master's footage.
4. Produce the platform-native hook copy (first line).
5. Record in distribution.json.

## Copy

Triggered by /ms-social-distributor copy <platform>.

1. Read the script's CTA and the concept's claim.
2. Write the first line, caption body, and CTA for the platform.
3. Select hashtags per the platform's rules.
4. Append attribution and disclosure strings.
5. Record in distribution.json.

## Captions

Triggered by /ms-social-distributor captions <platform>.

1. Read the script.json VO lines.
2. Re-anchor to the platform cut's runtime.
3. Split cues over 20 cps.
4. Emit SRT and VTT.
5. Enable burned captions in the cut's render.
6. Hash every caption file.

## Thumbnail

Triggered by /ms-social-distributor thumbnail <platform>.

1. Auto-extract 3-5 candidates from the platform cut.
2. Optionally render a designed thumbnail.
3. Choose the thumbnail.
4. Hash.

## Metadata

Triggered by /ms-social-distributor metadata <platform>.

1. Compose the platform-specific metadata.
2. Verify every field.
3. Append attribution and disclosure strings.
4. Hash.

## Pack

Triggered by /ms-social-distributor pack or /ms-social-distributor <project-id>.

1. Build the distribution/ tree.
2. Copy cuts, burned cuts, captions, thumbnails, metadata per platform.
3. Emit sha256sums.txt.
4. Emit pack.json.
5. Hash the pack.

## Verify

Triggered by /ms-social-distributor verify.

1. Walk every file in the pack.
2. Recompute SHA-256.
3. Compare against pack.json.
4. Emit a diff.

## Audit

Triggered by /ms-social-distributor audit.

1. Verify every platform's aspect, duration, codec, bitrate, and loudness.
2. Verify every platform's hook, copy, captions, thumbnail, metadata.
3. Verify no cross-platform copy duplication.
4. Verify no banned hashtags.
5. Emit an audit diff.

## Report

Triggered by /ms-social-distributor report.

1. Emit the platform table.
2. Emit the pack summary.
3. Emit the QA result.
4. Do not modify distribution.json.

## Rollback

Triggered by ms-command rollback.

1. Re-open gate 16.
2. Restore the requested distribution.json version.
3. Restore the referenced files.
4. Re-verify hashes.
5. Require explicit re-approval.

## Stop conditions

Stop and present when:

- Every platform in the platform set has a native cut
- Every cut matches the platform rules
- Every platform has distinct copy, hashtags, and CTA
- Every caption is generated and within reading speed
- Every thumbnail is generated
- Every metadata field is populated
- Every attribution and disclosure string is present
- The pack is assembled and hashed
- No CPT-xx codes open
- distribution.json and distribution.md written

Do not keep producing past this point. Do not present a pack with any open CPT-xx.
