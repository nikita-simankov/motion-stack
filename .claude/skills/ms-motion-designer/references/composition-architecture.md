# Composition Architecture

Scene file layout, component hierarchy, providers.

## File layout

src/
Root.tsx
scenes/
B01/
index.tsx
HookNumber.tsx
BackgroundPlate.tsx
README.md
B02/
index.tsx
ListItem.tsx
README.md
...
shared/
tokens.ts
interpolators.ts
ui/
DeviceFrame.tsx
Cursor.tsx
Card.tsx
StateBadge.tsx
assets/
A001*...
A002*...

Rules:

- One folder per board.
- index.tsx is the scene entry point.
- Any element over ~40 lines moves to its own file in the same folder.
- Shared UI components live in src/shared/ui/.
- Tokens live in src/shared/tokens.ts as a frozen TS object mirroring style-tokens.json.
- Interpolator helpers live in src/shared/interpolators.ts.

## Component hierarchy

A scene composes as:

<Scene>
  <Background>           # static or parallax layer
    ...
  </Background>
  <Content>              # primary subject
    <Sequence>...</Sequence>
    <Sequence>...</Sequence>
  </Content>
  <Overlay>              # text, callouts
    <Sequence>...</Sequence>
  </Overlay>
  <UI>                   # only when UI mockup is present
    <DeviceFrame>
      <Screen state={stateFromFrame}>
        ...
      </Screen>
      <Cursor frameAnchors={...} />
    </DeviceFrame>
  </UI>
</Scene>

Rules:

- Each layer is an <AbsoluteFill> or a positioned container.
- Sequences inside layers carry their own from and durationInFrames.
- No nested state. The scene reads useCurrentFrame() once and passes values down.

## Providers

- A single TokensProvider at the scene root, providing the frozen token set.
- No other context unless a third-party library requires one.
- No global Redux, MobX, Zustand, or similar.
- No state that survives across frames except what is derived from useCurrentFrame.

## Frame math

- useCurrentFrame() at the scene root, once.
- Pass the frame value to children via props.
- Children compute their local progress via interpolate(frame, [start, end], [...]).
- No child calls useCurrentFrame() independently unless it is a Remotion primitive (Sequence, TransitionSeries).

## Import rules

- Every import from remotion is explicit.
- Every asset is imported via staticFile() or a Remotion primitive.
- No fetch at render time.
- No fs at render time.
- No dynamic import based on runtime conditions.
- No environment variables read at render time.

## Naming

- Component files: PascalCase (HookNumber.tsx)
- Helper files: camelCase (interpolators.ts)
- Scene folders: board id (B01, B02)
- Composition ids: <project-slug>-<boardId>

## README per scene

Every scene folder has a README.md listing:

- boardId
- durationFrames, fps, resolution
- assetsUsed (ids)
- tokensUsed (token paths)
- interpolators used
- approximate render time at --preview-scale
- known warnings

## Determinism

- No Math.random unless seeded
- No Date.now() or new Date() at render time
- No dependence on window size at render time
- No network
- No environment variables
- Fonts loaded via Remotion's loadFont at module top

## Bundle size

- Every scene imports only what it uses.
- Shared components kept small.
- Assets referenced via staticFile(), not bundled as base64.
- Bundle size reported at gate.
