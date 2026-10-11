# Review Artifact

How to review each artifact type.

## Master video

- Play through at least once at full speed
- Check the hook: does it land in the first 2 seconds?
- Check pacing: does any beat drag or feel rushed?
- Check audio: does the VO sit above the music and SFX?
- Check captions: in sync, in safe area, not obscuring UI
- Check the CTA: is it clear?
- Check the final frame: is the last beat intentional?
- Watch once at 25% scale to simulate a phone screen

## Captions

- Read the SRT end to end
- Compare against script.json line by line
- Verify cps per cue
- Verify every cue is within safe area
- Verify the burned captions match the SRT text
- Verify no caption overlaps a UI element

## Metadata

- Read metadata.json
- Verify title length per platform
- Verify description length per platform
- Verify hashtags per platform
- Verify every attribution string is present
- Verify every disclosure string is present
- Verify the CTA is reflected in the description

## Cue sheet

- Verify every cue has a license
- Verify every license is valid for the target platforms
- Verify every Content ID clearance is present for YouTube
- Verify every monetization clearance when the video is monetized

## License summary

- Verify every asset has a license
- Verify every music cue has a license
- Verify every attribution requirement is reflected in the metadata

## Grade

- Review the preview render with scopes
- Verify every palette color used retains its contrast minimum
- Verify black and white points within 1 of token
- Verify no visible banding or clipping

## Voice

- Listen to the VO stem end to end
- Verify timbre consistency across lines
- Verify pacing per line against the script
- Verify no clipped or rushed lines
- Verify no audible artifacts

## Sound design

- Listen to the SFX stem end to end
- Verify no SFX masks the VO
- Verify every placement lands on its frame
- Verify ambient beds are ducked

## Music

- Listen to the music stem end to end
- Verify hits land on board cuts
- Verify ducking is smooth
- Verify no track fights the VO

## Timeline

- Verify every board is represented
- Verify every transition matches the boards
- Verify the runtime matches the brief exactly

## Scenes

- Verify every scene renders without error
- Verify every scene registers correctly
- Verify determinism

## Assets

- Verify no placeholders
- Verify every asset has a license
- Verify every asset loads via a named Remotion loader

## Boards

- Verify every frame is covered
- Verify no orphans
- Verify transitions pair

## Concept

- Verify the selected concept scores above the floor
- Verify no two concepts share a structural family
- Verify differentiation

## Script

- Verify every claim traces to the dossier
- Verify the hook lands in the first 2 seconds
- Verify the CTA
- Verify VO timing per line

## Research

- Verify every used claim has a source
- Verify no low-confidence claim is used
- Verify aging claims are flagged

## Brief

- Verify every field is locked
- Verify no open items
- Verify no contradictions

## Hash chain

- Verify timeline source hash
- Verify grade source hash
- Verify every stem hash
- Verify master hash
- Verify package hash
- Any mismatch halts

## Review order

1. Hash chain first. If it fails, halt. No review past it.
2. Upstream gates: brief, dossier, concept, script, boards, style, assets.
3. Scenes, VO, SFX, music, timeline, grade.
4. Master.
5. Legal, brand, accessibility.
6. Rubric score.

## Reporting

Every review produces findings with codes, frames, artifacts, and routes. Findings without a frame or artifact reference are rejected as non-specific.

## Non-review

QA does not:

- Edit source
- Re-render
- Re-encode
- Rewrite copy
- Re-license
- Re-mix
- Any fix whatsoever

Any fix is owned by the responsible stage.
