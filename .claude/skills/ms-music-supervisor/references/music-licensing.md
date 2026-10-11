# Music Licensing

License record, clearance, Content ID, monetization.

## License record

Every cue carries:

- licenseId — SPDX identifier, library reference, or client agreement reference
- library — Epidemic, Artlist, Musicbed, Soundstripe, YouTube Audio Library, original, client
- trackTitle
- trackArtist
- trackComposer (if known)
- trackPublisher (if known)
- trackDurationMs
- isrc (if available)
- territory — worldwide or restricted
- platformScope — every platform in brief.Q4
- monetizationAllowed — true | false
- contentIdCleared — true | false
- expiry — ISO8601 or null
- clearedBy
- clearedAt

## Clearance procedure

1. Identify the library.
2. Verify the library is on the approved list.
3. Verify the tier covers the target platforms.
4. Verify worldwide territory covers the audience.
5. Verify the expiry is after the publication window.
6. Verify monetization is allowed if the video is monetized.
7. Verify Content ID clearance if YouTube is in the platform set.
8. Record the clearedBy and clearedAt.
9. Attach the license text or reference.

## Content ID

Content ID is YouTube's audio fingerprinting system. A track not cleared for Content ID can trigger a copyright claim on the channel.

Rules:

- Every cue on a YouTube-distributed video must be Content ID cleared.
- "Cleared" means the library has whitelisted the track for the channel or the channel has added the track to an allowlist.
- Tracks from libraries without Content ID support are rejected for YouTube.
- The channel's Content ID allowlist is maintained at the run level, not the project level.

## Monetization

If the video will be monetized (ad revenue, sponsorship, or branded content):

- The license must allow monetization.
- The library must permit use in monetized content.
- Some libraries require a higher tier for monetization; verify the tier.
- Record the tier in the license record.

## Territory

- Worldwide is the default and safest.
- Restricted territories require the audience to be within the allowed region.
- Any restriction not aligned with the audience fails the gate.

## Expiry

- A license with an expiry inside the video's publication window is flagged.
- Options: replace the cue, extend the license, or reduce the video's distribution window.
- The client decides. The pipeline records the decision in the license record.

## Attribution

- Some libraries require attribution in the description.
- Attribution text is appended to the video description in the distribution pack.
- The exact text is recorded in the license record.

## Client-supplied

- Client-supplied tracks are cleared by the client.
- The studio records the client agreement reference and the clearance flags.
- The studio does not verify the track beyond the flags the client provides.

## Cue sheet

The cue sheet is the legal artifact. It lists every cue with the license reference. It is emitted as CSV for machine consumption and as markdown for human review.

## Rejected licenses

- Unknown source
- No publisher
- No territory specified
- No expiry specified
- No platform scope specified
- Monetization unclear
- Content ID unclear
- Any license that requires the studio to reverse-search the owner

## Audit

- Every cue is re-verified on gate pass.
- Any license expiring within 30 days of the gate is flagged for re-clearance.
- Any license change is recorded with a timestamp.
