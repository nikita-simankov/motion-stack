# Calendar Integrations

ics, csv, json, API pushes, native schedulers.

## Emit formats

### ics

- Standard iCalendar format
- One VEVENT per slot
- DTSTART and DTEND in UTC or with a TZID
- SUMMARY: the platform and content title
- DESCRIPTION: the caption, hashtags, content path, metadata path
- URL: the content path (as a file URL when local)

Rules:

- Every slot has a VEVENT.
- Every VEVENT has a unique UID (project-id + slot-id).
- The calendar is importable into Google Calendar, Apple Calendar, and Outlook.

### csv

Columns:
slotId, waveId, sequenceId, platform, scheduledAt, window, contentPath, metadataPath, thumbnailPath, caption, hashtags, status, notes

Rules:

- UTF-8, comma-delimited
- One row per slot
- Header row required
- Importable into generic scheduling tools

### json

- The calendar.json itself
- Used by API-driven schedulers and by the studio's internal dashboard

## API pushes

### Buffer

- Endpoint: Buffer API v1
- Auth: access token in the environment
- Push per slot as a scheduled update
- Returns externalId per slot

### Later

- Endpoint: Later API
- Auth: API key in the environment
- Push per slot as a scheduled post

### Hootsuite

- Endpoint: Hootsuite API
- Auth: OAuth token in the environment
- Push per slot as a scheduled message

### Metricool

- Endpoint: Metricool API
- Auth: API key in the environment
- Push per slot as a scheduled post

### Native schedulers

- LinkedIn native — LinkedIn Marketing API
- Instagram native — Meta Graph API
- TikTok native — TikTok Content Posting API
- YouTube native — YouTube Data API
- X native — X API v2

Rules:

- Native scheduling requires native app approval.
- Native scheduling often has different content rules per platform.
- Native scheduling is preferred when available and approved.

## Push procedure

1. Read calendar.json.
2. Filter slots that are not yet pushed.
3. Authenticate with the integration.
4. Push each slot.
5. Record the externalId per slot.
6. On failure, halt and roll back the partial push.

## Rollback

If a push fails midway:

1. Identify pushed slots.
2. Delete them via the integration's API.
3. Mark them as rolled back.
4. Halt.

Rules:

- Partial pushes are not acceptable.
- Idempotent pushes: re-pushing updates existing slots when slot ids match.
- External ids are stored per slot for future reconciliation.

## Credentials

- All credentials are in the environment.
- No credential is written to disk.
- No credential is logged.
- No credential is echoed.

## Reconciliation

Periodically (or on demand):

1. Query the integration for scheduled slots.
2. Match against calendar.json by externalId.
3. Detect drift: scheduled but not in calendar, in calendar but not scheduled.
4. Emit a reconciliation report.

## Rejected patterns

- Pushing without credentials
- Pushing without a manifest
- Pushing a slot whose content file does not exist
- Pushing a slot whose metadata file does not exist
- Any push that logs the credential
- Any push that leaves the integration in a partial state
