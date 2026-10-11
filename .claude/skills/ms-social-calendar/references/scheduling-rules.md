# Scheduling Rules

Slot ordering, wave structure, collision rules.

## Slot ordering within a platform

When a platform receives more than one piece of content:

1. Primary cut first
2. Re-post wave second, at least 7 days later
3. Optional hook-reinforced variant third if produced

Rules:

- No platform receives the same piece of content twice.
- No slot duplicates another slot's content path within the same platform.
- Slot order is recorded in calendar.json.

## Collision rules

Collisions to avoid:

- Same platform, same day, two slots
- Same platform, two slots within 4 hours
- Same content path, two slots on the same platform
- Same content path, two slots on different platforms within 1 hour (cross-post fingerprinting)

Allowed:

- Same platform, different days
- Different platforms, same day, staggered by 2-4 hours
- Different platforms, same day, different content

## Wave structure

A wave contains:

- A start date
- An end date
- A list of platforms
- A slot per platform
- A cross-post strategy

Rules:

- A wave has exactly one slot per platform unless the brief allows more.
- A wave's slots respect the cross-post strategy.
- A wave's start date is the earliest slot in the wave.
- A wave's end date is the latest slot in the wave.

## Blackout rules

- No slot falls on a client-designated blackout date.
- No slot falls on a major holiday in the studio's primary market unless the brief overrides.
- No slot falls on a date after the brief's deadline.
- No slot falls on a date before the brief's start date.

## Timezone rules

- All slots carry an ISO8601 datetime with an explicit timezone offset.
- The calendar's default timezone is recorded.
- Slots are scheduled in the studio's primary market timezone unless the brief overrides.
- Multi-region briefs schedule per region with explicit offsets.

## Sequencing rules

- Sequence ids are per platform per wave: SEQ-<platform>-<wave>.
- Slots in a sequence are ordered by scheduledAt.
- No sequence has more than 5 slots.
- Sequences are recorded in calendar.json.

## Emit rules

- At least one interchange format is emitted (ics, csv, or json).
- The default emit format is ics plus json.
- The emitted files are hashed.
- The emitted files are recorded in calendar.json.

## Rejected patterns

- A wave with no platforms
- A wave with more slots than platforms
- A slot with no content path
- A slot with no metadata path
- A slot that references a file outside the distribution pack
- A slot scheduled before the brief's start date or after its deadline
- A slot that collides with another slot on the same platform-day
