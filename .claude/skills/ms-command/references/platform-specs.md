# Platform Spec Table

Load on stages 14 and 16.

Pinned at Brief locked. Finishing and distribution must match exactly.

LinkedIn 1:1 / 4:5 / 16:9 1080p 90s feed, 10m native -14 LUFS Burned + SRT
Instagram Reels 9:16 1080x1920 90s -14 LUFS Burned + SRT
TikTok 9:16 1080x1920 60s optimal, 10m max -14 LUFS Burned + SRT
YouTube Shorts 9:16 1080x1920 60s -14 LUFS Burned + SRT + VTT
X 16:9 / 1:1 1080p 140s -14 LUFS SRT

True-peak ceiling: -1 dBTP across all platforms.
Integrated loudness: -14 LUFS.
VO level: -16 LUFS.
Music ducked under VO: -18 LUFS.
SFX level: -20 LUFS.

## Vertical 9:16

Reels, TikTok and Shorts draw their own UI over the frame (profile row, caption, action buttons, progress bar). Anything a viewer must read stays inside the safe box. Decorative layers may bleed.

Insets at 1080x1920, in pixels:

Instagram Reels top 250 bottom 310 right 100 left 60
TikTok top 250 bottom 350 right 120 left 60
YouTube Shorts top 260 bottom 380 right 120 left 60
Universal (default) top 260 bottom 380 right 120 left 60

The universal box is 900 wide by 1280 tall, from x 60 to 960 and y 260 to 1540. It is the default for `layout.aspectOverrides[9:16].platformInsetsPx` and is written into the tokens at gate 6. Use a per-platform row only when the brief targets one platform.

Provenance: third-party measurements of the in-app overlays, reviewed 2026-10-11. Sources disagree (Reels top 210 to 250 and bottom 280 to 310; TikTok bottom 320 to 350; Shorts figures come from ad previews and may overstate organic Shorts), so each row takes the more conservative figure; TikTok and Shorts top insets, and the left inset everywhere, were not reported and use the universal default. No platform-official figures were found. Platform UI changes often: check a live preview before a major launch and update this table in the same change as `trend-benchmarks.md`.

Rules:

- Captions, CTAs, lower thirds, and hook text sit inside the box.
- A caption's bottom edge is at least `bottom` px above the canvas edge.
- 1:1, 4:5, and 16:9 carry zero platform insets; the percentage safe area (`layout.safeAreaPct`) still applies.
- QA samples frames from the master and the cuts against the box (ACC-xx for unreadable content, CAP-xx for captions).
