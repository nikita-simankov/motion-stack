# License Tracking

Every asset carries a license record. Any asset without a cleared license fails the gate.

## License record

- licenseId — SPDX identifier or client reference
- source — authored | client-supplied | licensed-library | public-domain
- attributionRequired — true | false
- attributionText — the exact string, when required
- territory — worldwide or a restricted region
- expiry — ISO8601 or null
- clearedBy — who cleared
- clearedAt — ISO8601

## SPDX identifiers

Common identifiers:

- CC0-1.0 — public domain
- CC-BY-4.0 — attribution required
- CC-BY-SA-4.0 — attribution and share-alike
- MIT — software
- Apache-2.0 — software
- OFL-1.1 — open font license
- Proprietary — client or library reference, with a pointer to the agreement

## Clearance procedure

1. Identify the source.
2. Identify the license.
3. Check whether attribution is required.
4. Check whether the territory covers the target audience.
5. Check whether the expiry is inside the publication window.
6. Record the clearedBy and clearedAt.
7. Append attribution text to the brief's metadata plan when required.

## Flagged conditions

An asset is flagged when:

- Territory excludes the target audience
- Expiry falls inside the publication window
- Attribution required but text not yet appended to metadata
- License record incomplete

A flagged asset does not block production, but it blocks gate 7 unless the client overrides in writing.

## Attribution text

When required, the exact string is stored. Examples:

- "Icons by Lucide, MIT License."
- "Photo by Jane Doe on Unsplash, Unsplash License."
- "Font Inter, SIL Open Font License 1.1."

Attribution is appended to:

- Video description in the distribution pack
- End card when the license requires in-video credit
- Metadata file in the master deliverable

## Expiry

A license with an expiry inside the video's publication window is a risk. Options:

- Replace the asset with a license that extends past the window
- Mark the asset as time-bound and plan to re-cut after expiry
- Reduce the window to fit the license

The client decides. The pipeline records the decision in the license record.

## Client-supplied

Client assets are covered by the client's own agreements. The license record references the agreement by name and date. The studio does not re-clear client assets, but does flag any obvious risk (e.g., a client-supplied photo with no source).

## Unknown origin

Any asset whose origin cannot be established is rejected. Do not use reverse image search as a clearance method.
