# Scene QA

Scene-level QA checklist. Runs before gate 8.

## Build

- [ ] Scene compiles without TypeScript errors
- [ ] Scene imports only from declared dependencies
- [ ] Scene renders without runtime errors at --preview-scale
- [ ] Scene registers in Root.tsx with correct fields

## Animation

- [ ] Every animated element uses useCurrentFrame()
- [ ] Every interpolate() call clamps both sides
- [ ] Every spring() call uses explicit config
- [ ] Every frame anchor is an integer
- [ ] No CSS transitions in any style
- [ ] No CSS keyframes in any file
- [ ] No Tailwind animation classes (animate-_, transition-_, duration-\*)
- [ ] No setTimeout or setInterval at render time
- [ ] No requestAnimationFrame
- [ ] No Math.random without a seed
- [ ] No Date.now() at render time

## Assets

- [ ] Every asset used is present in assets.json
- [ ] Every asset is loaded via its declared loader
- [ ] No placeholder assets
- [ ] No assets loaded from the network at render time

## Tokens

- [ ] Every color used comes from the frozen palette
- [ ] Every type used comes from the frozen type roles
- [ ] Every motion bucket used comes from the frozen motion set
- [ ] Every transition used comes from the frozen transition set

## Composition

- [ ] Scene id matches the composition id in Root.tsx
- [ ] durationInFrames matches the board
- [ ] fps, width, height match brief
- [ ] defaultProps are JSON-serializable

## Determinism

- [ ] Re-render twice, hashes match
- [ ] No environment-variable reads at render time
- [ ] No window-size reads at render time
- [ ] Fonts loaded before render via loadFont

## Performance

- [ ] Render time within the budget for the scene length
- [ ] No obvious O(n^2) loops over frames
- [ ] Heavy computation memoized with useMemo
- [ ] Static layers pre-computed as assets when feasible

## Preview

- [ ] Preview file exists at runs/<id>/previews/<scene-id>.mp4
- [ ] Preview hash recorded in scenes.json
- [ ] Preview visually matches the board's intent

## README

- [ ] Scene folder has a README.md
- [ ] README lists board id, duration, fps, resolution
- [ ] README lists assets used
- [ ] README lists tokens used
- [ ] README lists render time

A single unchecked box means the gate does not pass.
