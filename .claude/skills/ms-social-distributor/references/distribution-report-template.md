# Distribution Report Template

distribution.md render template. Emitted at every distribution run.

MOTION STUDIO — DISTRIBUTION
project-id: <project-id>
built-at: <ISO8601>
master-version: <v>
qa-version: <v>
tokens-version: <v>
platforms: <count>

PLATFORMS
platform aspect resolution codec bitrate duration loudness status
linkedin 16:9 1920x1080 h264 14000 30s -14 LUFS / -1 ok
instagram 9:16 1080x1920 h264 10000 30s -14 LUFS / -1 ok
tiktok 9:16 1080x1920 h264 10000 30s -14 LUFS / -1 ok
youtube 9:16 1080x1920 h264 10000 30s -14 LUFS / -1 ok
x 16:9 1920x1080 h264 14000 30s -14 LUFS / -1 ok

HOOKS
linkedin master "Most MCP deployments fail in the first week."
instagram re-cut "The MCP mistake almost every team makes"
tiktok re-cut "Nobody talks about this MCP problem"
youtube re-cut "The MCP deployment mistake"
x re-cut "Most MCP deployments fail in the first week."

COPY
linkedin first line: <first 80 chars>
instagram first line: <first 80 chars>
tiktok first line: <first 80 chars>
youtube title: <title>
x first post: <first 80 chars>

HASHTAGS
linkedin #mcp #ai #engineering
instagram #mcp #aidev #backend #dev #shorts
tiktok #mcp #ai #dev
youtube #mcp #ai #dev
x #mcp

CAPTIONS
linkedin burned + srt sha256:...
instagram burned + srt sha256:...
tiktok burned + srt sha256:...
youtube burned + srt + vtt sha256:...
x srt sha256:...

THUMBNAILS
linkedin 1280x720 <path> sha256:...
instagram 1080x1920 <path> sha256:...
tiktok 1080x1920 <path> sha256:...
youtube 1280x720 <path> sha256:...
x 1280x720 <path> sha256:...

METADATA
every platform has: title (where applicable), caption, hashtags, CTA, attributions, disclosures
missing fields: none

PACK
path: runs/<id>/distribution/pack.json
pack hash: sha256:...
sha256sums hash: sha256:...

DETERMINISM
pass | fail

QA
passed: <true|false>
codes: <list>
notes: <string>

NEXT
<approve | revise <notes>>
