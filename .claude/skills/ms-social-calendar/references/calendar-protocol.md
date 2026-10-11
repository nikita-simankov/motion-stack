# Calendar Protocol

## Slot

Triggered by /ms-social-calendar slot <slot-id> or automatically during calendar build.

1. Verify the platform is in the distribution pack.
2. Verify a piece of content is available for the platform.
3. Assign a datetime inside the platform's posting window.
4. Assign the content path, metadata path, and thumbnail path.
5. Record the slot.

## Shift

Triggered by /ms-social-calendar shift <slot-id> --to <iso8601>.

1. Verify the new datetime is inside the platform's posting window.
2. Verify no collision.
3. Update the slot.
4. Update the interchange files.
5. Re-run calendar QA for the affected slot only.

## Reorder

Triggered by /ms-social-calendar reorder <platform>.

1. Read the platform's slots.
2. Reorder by priority or by the requested sequence.
3. Update the sequence ids.
4. Update the interchange files.

Reorder does not change datetimes unless the reorder changes a slot's day.

## Cadence

Triggered by /ms-social-calendar cadence <platform>.

1. Read the platform's current cadence.
2. Apply the new cadence.
3. Recompute slots.
4. Update the interchange files.

## Emit

Triggered by /ms-social-calendar emit <format>.

1. Generate the requested format (ics, csv, json).
2. Save to runs/<id>/calendar.<ext>.
3. Hash the file.
4. Update calendar.json.interchange.

## Push

Triggered by /ms-social-calendar push <integration> or --push.

1. Read calendar.json.
2. Authenticate with the integration.
3. Push each slot.
4. Record the externalId per slot.
5. On any failure, roll back the partial push.
6. Update calendar.json.push.

## Audit

Triggered by /ms-social-calendar audit.

1. Verify every platform has a slot.
2. Verify every slot's datetime.
3. Verify every slot's content path exists.
4. Verify no collisions.
5. Verify the interchange files match the manifest.
6. Emit an audit diff.

## Report

Triggered by /ms-social-calendar report.

1. Emit the wave table.
2. Emit the slot table.
3. Emit the push summary.
4. Do not modify calendar.json.

## Rollback

Triggered by ms-command rollback.

1. Re-open gate 17.
2. Restore the requested calendar.json version.
3. If pushed, delete the pushed slots via the integration API.
4. Mark downstream stale.
5. Require explicit re-approval.

## Stop conditions

Stop and present when:

- Every platform has a slot
- Every slot is inside its posting window
- No collisions
- No blackout conflicts
- Every slot references an existing file
- Cross-post strategy recorded
- Cadence recorded
- Interchange files emitted and hashed
- No CAL-xx codes open
- calendar.json, calendar.md, and at least one interchange file written

Do not keep scheduling past this point. Do not present a calendar with any open CAL-xx.

## Pipeline complete

On gate 17 pass:

1. Append to run.json.approvals.
2. Mark the run as complete.
3. Emit the final run report.
4. The pipeline is done.
