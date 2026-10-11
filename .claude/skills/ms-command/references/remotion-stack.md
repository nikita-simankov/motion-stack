# Remotion Stack Contract

Load on stages 8, 12, 14.

All motion design is built as React components in Remotion.

## Composition registration

Every video is a <Composition> in src/Root.tsx with explicit:

- id (letters, numbers, and - only)
- width in pixels
- height in pixels
- fps (30 standard)
- durationInFrames (15s=450, 30s=900, 60s=1800, 90s=2700 at 30fps)
- component or lazyComponent
- defaultProps (JSON-serializable only)
- schema (optional Zod schema for visual editing)

## Animation rules

- ALL animations MUST be driven by useCurrentFrame()
- CSS transitions, CSS animations, and Tailwind animation classes are FORBIDDEN
- Write animations in seconds and multiply by fps for frame counts
- Use <Sequence> for timing: from, durationInFrames, trimBefore, playbackRate, loop
- Use <Series> for sequential non-overlapping elements
- Use <AbsoluteFill> for full-canvas layers
- Use <Interactive> components for timeline-editable elements

## UI mockup rules (when intake Q8 is C or D)

- Build UI mockups as React components inside Remotion compositions
- Use absolute positioning and flexbox for layout
- Device frames are React components with fixed dimensions
- Interaction states (hover, active, loading, success, error) are frame-driven
- Cursor movement is a React component animated via interpolate()
- Clicks trigger state changes via frame thresholds
- All timing uses frame counts, never seconds

## Render pipeline

- Local render: npx remotion render <composition-id>
- Cloud render: npx remotion lambda render <serve-url> <composition-id>
- Still render: npx remotion still <composition-id> <output>
- Browser render: renderMediaOnWeb() from @remotion/web-renderer
- Lambda memory: 3009MB = 3 vCPUs (optimal cost/speed balance)
- Lambda concurrency: default 1000 concurrent lambdas per region
- Frame chunks must be equal size except the last, or audio artifacts occur with AAC codec

## Audio concatenation

- Remotion 4.0.130+ supports audio concatenation without full re-encode pass
- Cuts render time significantly on longer videos
