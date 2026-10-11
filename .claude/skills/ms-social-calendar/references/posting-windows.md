# Posting Windows

Per-platform posting windows and blackout dates.

## LinkedIn

Windows (studio timezone):

- Tuesday-Thursday: 08:00-10:00, 12:00-13:00
- Wednesday-Thursday preferred

Blackout:

- Weekends unless the brief's audience is active
- Major US and EU holidays

## Instagram Reels

Windows:

- Monday-Friday: 11:00-13:00, 19:00-21:00
- Weekends: 11:00-13:00

Blackout:

- None, except client blackouts

## TikTok

Windows:

- Monday-Sunday: 18:00-22:00
- Weekend peaks: 19:00-23:00

Blackout:

- None, except client blackouts

## YouTube Shorts

Windows:

- Monday-Friday: 12:00-15:00, 18:00-21:00
- Weekends: 12:00-16:00

Blackout:

- None, except client blackouts

## X

Windows:

- Monday-Friday: 09:00-11:00, 17:00-19:00
- Weekends: 10:00-12:00

Blackout:

- None, except client blackouts

## Common blackout dates

- New Year's Day (Jan 1)
- US Independence Day (Jul 4)
- Thanksgiving (US, fourth Thursday of November)
- Christmas (Dec 24-26)
- New Year's Eve (Dec 31)
- Client-specified dates from brief

## Timezone rules

- All windows are stated in the studio's primary market timezone.
- Slots are recorded with an explicit timezone offset.
- A multi-region brief schedules per region with explicit offsets.
- The studio's primary market timezone is recorded in the brief; default is UTC.

## Window assignment

For each slot:

1. Determine the platform.
2. Determine the target date (from the wave).
3. Choose the window that best fits the wave's objective.
4. Assign a specific datetime inside the window.
5. Record the window name in calendar.json.

Default window selection per objective:

- Awareness — the platform's first morning window
- Consideration — the platform's midday window
- Conversion — the platform's afternoon or evening window
- Authority — the platform's morning window

## Rejected patterns

- A slot outside every window for its platform
- A slot on a blackout date without a client override
- A slot scheduled in the studio timezone but recorded in UTC without an offset
- A slot scheduled at the same datetime as another platform's slot within 1 hour
- A slot scheduled in a window the platform is known to underperform in

## Overrides

The client can override windows and blackouts. Every override is recorded in calendar.json under notes with a reason and an approver.
