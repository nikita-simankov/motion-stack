# Asset Types

Full catalogue. Each entry carries format, rules, loader, and generation notes.

## svg

Format: SVG 1.1
Rules:

- viewBox required
- No width or height attributes
- No embedded raster
- No <style> with transitions or animations
- No editor metadata (Illustrator, Figma, Sketch namespaces)
- Optimized via SVGO preset-safe
- Colors match the frozen palette exactly

Loader: inline via React component, or <Img src={staticFile(...)} />
Produce when: logo, brand mark, icon, illustration layer, diagram, map, glyph
Do not produce when: photographic content, complex gradients beyond palette, heavy texture

## webp

Format: WebP lossy (q 82-90) or lossless for flat areas with alpha
Rules:

- 2x target render size
- ICC profile tagged
- No EXIF
- Alpha only when needed

Loader: <Img src={staticFile(...)} />
Produce when: photographic plates, textured backdrops, complex illustrations where SVG is impractical
Do not produce when: vector is feasible

## png

Format: PNG-24 or PNG-32
Rules:

- Only when WebP alpha fails or when a lossless flat asset is required
- 2x target render size
- ICC profile tagged
- No EXIF

Loader: <Img src={staticFile(...)} />
Produce when: crisp UI screenshots for fallback, or when WebP is disallowed by the client

## jpg

Format: JPEG progressive q 85-92
Rules:

- Only for photographic content with no alpha and no type
- 2x target render size
- ICC profile tagged
- No EXIF

Loader: <Img src={staticFile(...)} />
Produce when: photographic plate where WebP would introduce visible artifacts

## tsx

Format: TypeScript React component
Rules:

- Follows style-tokens.uiMockup
- No CSS transitions
- No Tailwind animation classes
- Frame-driven state via useCurrentFrame
- Named exports only
- Dimensions from tokens
- All spacing is a multiple of the spacing base

Loader: imported as a React component
Produce when: device frame, screen chrome, card, modal, toast, cursor, focus ring, any UI surface

## lottie

Format: Bodymovin JSON
Rules:

- Only when the motion is authored in After Effects and cannot be built in Remotion
- No embedded raster
- Colors from the frozen palette
- No external references

Loader: import { Lottie } from "@remotion/lottie"
Produce when: complex vector motion the Remotion team cannot author in code within budget
Do not produce when: the motion can be built in Remotion (prefer Remotion-native)

## rive

Format: .riv
Rules:

- Only when the motion is authored in Rive and cannot be built in Remotion
- State machines named
- Colors from the frozen palette

Loader: import { RemotionRiveCanvas } from "@remotion/rive"
Produce when: interactive or state-machine-driven vector animation

## glb / gltf

Format: glTF 2.0 binary
Rules:

- Draco mesh compression
- KTX2 textures
- No external texture references
- No unused nodes or animations

Loader: <ThreeCanvas> from @remotion/three
Produce when: brief Q17 includes Three.js
Never produce otherwise

Q17=C sub-spec (3D scenes), authored at stage 6 as part of the look and locked in the asset manifest:

- Lighting: a key and a fill (and optional rim), each with colour from the palette, intensity and position
- Materials: named materials with base colour from the palette, roughness and metalness; no texture outside the manifest
- Camera: position, field of view, and the camera moves, driven by the `camera` role curve and `useCurrentFrame`
- Render budget: max triangles, max texture size (KTX2), and a frame render-time ceiling checked by `/ms-motion-designer perf`
- Determinism: no random seeds at render; animation clips advance by frame
- A 3D scene is justified when the subject needs real rotation or lighting. Flat depth (layered parallax, depth blur) is the default (`camera-rig.md`)

## woff2

Format: WOFF2
Rules:

- Subset to used glyphs
- Variable axes preserved when used
- Only families declared in style-tokens.type
- Fallback stack recorded in tokens

Loader: font-face at composition root, or @remotion/google-fonts for Google families
Produce when: licensed font cannot be loaded via @remotion/google-fonts

## google-fonts

Format: loader reference
Rules:

- Only families declared in style-tokens.type
- Loader import path recorded
- Weights match tokens exactly

Loader: import { loadFont } from "@remotion/google-fonts/<Family>"
Produce when: family is on Google Fonts

## data

Format: React component in Remotion
Rules:

- Charts, tables, numbers rendered from code, not images
- Frame-driven values via useCurrentFrame
- No screenshots of charts
- No SVG images of tables

Loader: rendered as a Remotion component
Produce when: chart, table, statistic, live number
