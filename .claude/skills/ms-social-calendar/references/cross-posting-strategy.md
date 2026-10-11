# Cross-Posting Strategy

Staggered, same-day, and drip strategies.

## Staggered (default)

Definition: platforms post across 2-3 days, staggered within a day by 2-4 hours.

Example for 5 platforms, starting Tuesday:

- Tuesday 08:30 LinkedIn
- Tuesday 12:00 X
- Wednesday 12:00 Instagram Reels
- Wednesday 14:00 YouTube Shorts
- Wednesday 19:00 TikTok

Rationale:

- Reduces duplicate-content fingerprinting across platforms
- Lets each platform's algorithm warm up independently
- Avoids audience fatigue on the same day

Use when:

- The brief's platform set is 3 or more
- The content is not time-sensitive
- The default

## Same-day

Definition: all platforms post within a 4-hour window on the same day.

Example:

- Tuesday 08:30 LinkedIn
- Tuesday 09:15 X
- Tuesday 10:00 Instagram Reels
- Tuesday 11:00 YouTube Shorts
- Tuesday 11:30 TikTok

Rationale:

- Concentrated impact
- Time-sensitive content

Use when:

- The content is tied to a same-day event or announcement
- The brief explicitly requests it

Risks:

- Duplicate-content fingerprinting
- Audience fatigue if the same person follows the brand on multiple platforms
- Algorithm penalty on some platforms

Mitigation:

- Vary the hook per platform
- Vary the copy per platform
- Vary the thumbnail per platform
- Space slots by at least 45 minutes

## Drip

Definition: one platform per day across 5-7 days.

Example:

- Monday LinkedIn
- Tuesday X
- Wednesday Instagram Reels
- Thursday YouTube Shorts
- Friday TikTok

Rationale:

- Isolates each platform's performance
- Extends the campaign window
- Allows mid-campaign adjustments

Use when:

- The brief's objective is measurement per platform
- The brief's cadence is content-sprint
- The client wants per-platform analytics without cross-contamination

Risks:

- Slow total reach
- The audience on later platforms may have already seen the content via a different platform

## Strategy selection

- Default: staggered
- Time-sensitive: same-day
- Measurement-focused: drip
- The client's brief overrides the default.

## Recording

The chosen strategy is recorded in calendar.json under crossPostStrategy with a reason when it differs from the default.

## Per-wave strategy

A run can use different strategies per wave:

- Primary wave: staggered
- Reinforcement wave: same-day or drip

Rules:

- Each wave records its strategy.
- A wave's strategy is inherited from the run's default unless overridden.

## Rejected patterns

- Using "staggered" for slots that are within 1 hour of each other
- Using "same-day" without varying the per-platform copy
- Using "drip" for time-sensitive content
- Mixing strategies within a wave
