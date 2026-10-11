# Style Token Contract

Load from stage 6 onward (style lock).

Fixed at Look locked and read-only thereafter.

Palette Hex set, primary/secondary/accent, gradient stops
Type Family, weights, scale, tracking, casing rules
Motion Named curves and roles, spring presets, choreography (stagger, overlap, hold, settle), motion blur, duration buckets in frames, transition set
Texture Grain, halation, chromatic aberration, vignette, halftone, paper, light leak
Grade Target gamma, gamut, LUT, contrast curve
Audio Target LUFS, true-peak ceiling, duck depth
UI Mockup Device frame, corner radius, shadow spec, interaction state set, cursor curve, smart zoom, typing cadence
Captions Style (cue, word-highlight, word-pop), paging, scrim, safe-zone reference
Camera Rig, max zoom, parallax depths, depth blur
Layout Grid, margins, focal point, platform insets per aspect
Rhythm Beat-grid snap, audio-reactive, max static frames

Any drift from style tokens is GRD-xx or ANIM-xx and routes accordingly.

Current contract is tokenVersion 2. v1 files stay readable (missing sections resolve to defaults). Upgrade with /ms-command migrate. Details: ms-styleframe-designer/references/token-migration-v1-to-v2.md.
