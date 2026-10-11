# Seamless Loop

Short vertical teasers (15 to 20 seconds) often autoplay on repeat. A loop that jumps at the seam reads as a cut; one that resolves reads as a gift to the viewer. The rule is on when `style-tokens.loop.enabled` is true (default for `hook-15s-reels`).

```
loop: { "enabled": true, "matchFrames": 6 }
```

## Rules

- The last `matchFrames` frames ease back to the opening state of frame 0 (position, scale, opacity, colour). The return uses the `exit` or `state` curve role, not a hard cut.
- The opening frame is a complete image, not a fade from black. A loop that begins on black is not a loop.
- The CTA lands before the return starts; the return is the last motion, and it is short.
- VO never runs across the seam. The last line ends at least `matchFrames` frames before the end, and the first line starts after frame 0 by the same margin.
- Music: the tail resolves into the head. A fade-out to silence breaks the loop; a held chord or a cut on the beat does not. Fades at the seam are at most 6 frames (`audio.fadeInFrames`).
- Captions clear before the seam and start fresh after it. A caption that straddles the seam is a defect.
- Finishing exports the master with no slate and no end card. The loop is the content.

## Check

```
python3 ms-video-editor/scripts/loop_check.py <master.mp4> [--max-diff 6.0] [--window 6]
```

Mean absolute difference between frame 0 and the final frame at 96x96 grayscale, 0 to 255. Passing is at most 6. The tool prints the best-matching frame in the final window, which tells the editor how many frames to trim. The check ranks seams; the editor still watches the loop five times in a row.

Self-test: `loop_check.py --selftest` renders a clip that returns to its start and one that does not, and asserts the first passes and the second fails.

## Defect codes

CUT-16 Loop seam above threshold (frame 0 vs final frame)
CUT-17 Audio or caption straddles the loop seam
