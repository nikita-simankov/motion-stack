# Calendar Report Template

calendar.md render template. Emitted at every calendar run.

MOTION STUDIO — CALENDAR
project-id: <project-id>
built-at: <ISO8601>
distribution: <v>
master: <v>
start-date: <ISO8601>
end-date: <ISO8601>
timezone: <tz>
cross-post: <staggered | same-day | drip>
waves: <count>
slots: <count>
platforms: <count>

WAVES
W1 primary <start> to <end> 5 platforms staggered
W2 reinforcement <start> to <end> 5 platforms same-day
...

SLOTS
slotId wave platform scheduledAt window content status
SL001 W1 linkedin 2025-01-21T08:30-05:00 linkedin-morning distribution/linkedin/master.mp4 scheduled
SL002 W1 x 2025-01-21T12:00-05:00 x-midday distribution/x/master.mp4 scheduled
SL003 W1 instagram 2025-01-22T12:00-05:00 instagram-midday distribution/instagram/master.mp4 scheduled
SL004 W1 youtube 2025-01-22T14:00-05:00 youtube-midday distribution/youtube/master.mp4 scheduled
SL005 W1 tiktok 2025-01-22T19:00-05:00 tiktok-evening distribution/tiktok/master.mp4 scheduled
...

SEQUENCES
SEQ-linkedin-1 SL001
SEQ-x-1 SL002
SEQ-instagram-1 SL003
SEQ-youtube-1 SL004
SEQ-tiktok-1 SL005
...

INTERCHANGE
ics runs/<id>/calendar.ics sha256:...
csv runs/<id>/calendar.csv sha256:...
json runs/<id>/calendar.json sha256:...

PUSH
integration: <buffer | later | hootsuite | metricool | native | none>
pushed at: <ISO8601 | not pushed>
pushed slots: <n>
failed slots: <n>

QA
passed: <true|false>
codes: <list>
notes: <string>

PIPELINE
complete: <true|false>

NEXT
<approve | revise <notes>>
