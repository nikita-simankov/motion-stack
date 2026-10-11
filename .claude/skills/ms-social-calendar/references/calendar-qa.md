# Calendar QA

Checklist and codes. Every failure is a code and a gate rejection.

## Per-slot checks

CAL-01 Slot missing a platform
Fix: assign the platform

CAL-02 Slot missing a datetime
Fix: assign a datetime

CAL-03 Slot missing a content path
Fix: assign the content path from the distribution pack

CAL-04 Slot missing a metadata path
Fix: assign the metadata path from the distribution pack

CAL-05 Slot references a file that does not exist
Fix: correct the path or regenerate the missing file

CAL-06 Slot scheduled outside the platform's posting window
Fix: reassign the datetime

CAL-07 Slot scheduled on a blackout date without an override
Fix: reassign the datetime or record an override

CAL-08 Slot scheduled before the brief's start date or after its deadline
Fix: reassign

CAL-09 Slot timezone missing
Fix: add the offset

CAL-10 Slot content hash mismatch
Fix: re-hash

## Per-platform checks

CAL-11 Platform has no slots
Fix: add a slot

CAL-12 Two slots on the same platform share a calendar day without a re-post wave
Fix: reassign

CAL-13 Two slots on the same platform within 4 hours
Fix: space them out

CAL-14 Two slots across platforms within 1 hour
Fix: space them out

## Per-wave checks

CAL-15 Wave has no platforms
Fix: populate

CAL-16 Wave has more slots than platforms without a brief override
Fix: reduce

CAL-17 Wave start date after its end date
Fix: correct

## Per-run checks

- Every platform in the distribution pack has a slot
- Every slot references a file in the distribution pack
- Cross-post strategy is recorded
- Cadence is recorded
- Timezone is recorded
- At least one interchange format emitted
- Every emitted file is hashed
- When --push is set, the push succeeded and returned slot ids

## Thresholds

- Window compliance: 100%
- Collision tolerance: zero collisions per platform-day
- Cross-post spacing: minimum 45 minutes between platforms
- Timezone: explicit offset required on every slot
- Hash: exact match

## Reporting

Per slot:

- Wave, platform, datetime, window, content path, metadata path

Per wave:

- Start date, end date, platforms, strategy

Per run:

- Total slots, total waves, total platforms, start date, end date, timezone

## Sign-off

The calendar cannot pass gate 17 with any open CAL-xx. Any open code halts the pipeline.

## Legal note

No slot is scheduled on a blackout date without a client override. No slot is scheduled before a license is cleared. Calendar does not override legal.
