# Asset Optimization

Applied to every asset before gate pass. Runs automatically for SVG and fonts; on demand for other types.

## SVG — SVGO

Config: preset-default with the following overrides.

- removeViewBox: false (never remove)
- removeDimensions: true (strip width/height)
- removeXMLNS: false (keep the namespace)
- cleanupIds: true
- collapseGroups: true
- convertColors: true with shorthex, shortname, name2hex
- convertPathData: true with floatPrecision 2
- mergePaths: true
- removeMetadata: true
- removeEditorsNSData: true
- removeComments: true
- inlineStyles: false (keep styles isolated for Remotion)
- removeUselessDefs: true
- removeUnknownsAndDefaults: true

Post-optimize checks:

- viewBox present
- No width or height attributes
- No editor namespaces
- No embedded raster
- No <style> with transitions

## Raster — Sharp

WebP:

- quality: 85
- effort: 4
- alphaQuality: 90 when alpha present
- metadata: keep ICC profile only

PNG:

- compressionLevel: 9
- palette: false for PNG-32
- metadata: keep ICC profile only

JPEG:

- quality: 88
- progressive: true
- mozjpeg: true
- metadata: keep ICC profile only

Post-optimize checks:

- 2x target size preserved
- ICC profile present
- No EXIF
- No upscaling

## 3D — gltfpack

- Default compression
- Draco mesh compression enabled
- KTX2 texture compression
- Strip unused nodes
- Strip unused animations
- Preserve hierarchy when the motion designer requests it

## Fonts

- Subset to used glyphs (unicodes gathered from script.json and assets)
- Preserve variable axes when tokens use them
- Convert to woff2 only
- Record the unicode set in the manifest

## Data

- Any chart component that loads data from a JSON file must have the JSON inlined at build
- No runtime fetches at render time
- No random data at render time unless seeded with a fixed seed

## Verify

After optimize:

- Recompute checksums
- Update the manifest
- Re-run coverage checks
- Re-run the gate

## Do not

- Do not upscale
- Do not change aspect ratio
- Do not re-color any asset outside the frozen palette (logos and client marks excepted with license override)
- Do not flatten layers that the motion designer needs
- Do not remove viewBox
