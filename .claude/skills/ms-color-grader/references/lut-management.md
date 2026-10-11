# LUT Management

LUT storage, colorspace, hashing, loading.

## Storage

- Studio LUTs: runs/\_luts/
- Client LUTs: runs/\_clients/<profile>/luts/
- Project LUTs: runs/<project-id>/luts/

Every LUT has:

- filePath
- format (.cube)
- size (33x33x33 or 65x65x65)
- input colorspace (recorded in the .cube header or in a sidecar)
- description

## Naming

- <source>_<mood>_<version>.cube
- Example: studio_teal-orange_v03.cube
- Client LUTs use the client's naming convention

## Application

- Applied after the contrast curve
- Before the black and white clamps
- At strength 1.0 unless the token specifies otherwise (rarely less)
- In the token colorspace (sRGB by default)

## Colorspace

The LUT's input colorspace must match the source colorspace before the transform:

- If the pipeline is sRGB, the LUT expects sRGB input
- If the LUT expects log input and the pipeline is sRGB, a pre-LUT conversion is required
- The conversion is documented in the LUT's sidecar

## Hashing

Every LUT is hashed at load:

- SHA-256 of the .cube file
- Recorded in grade.json.lutHash
- Verified before every render

Any mismatch halts the render.

## Loading in Remotion

LUTs are loaded at render time via a WebGL shader or a pre-compiled 3D LUT texture:

- Parse the .cube file at build time
- Upload as a 3D texture on the GPU
- Sample per pixel in the shader

Rule: the .cube file is parsed at build time; the loaded texture is bundled with the render. No network fetch, no runtime file read at render time beyond the bundled asset.

## Rejected LUTs

- A LUT that crushes a palette color below its contrast minimum
- A LUT that cannot be parsed
- A LUT whose input colorspace does not match the pipeline
- A LUT applied at a strength not specified in the tokens
- A LUT sourced from an unknown origin

## Changes after freeze

A LUT change is a rollback to gate 6. The LUT is a frozen token.

## Fallback

If the token's lutId is null, no LUT is applied. The contrast curve and clamps still apply.

## Non-LUT grading

The grade does not require a LUT. Contrast curve + clamps + rolloff + output transform is a complete grade. The LUT is optional.

## Record

Every apply records:

- lutId
- lutHash
- applied strength
- input colorspace
- output colorspace after the LUT (before clamps)

## Verification

After applying the LUT, verify:

- No palette color falls below its contrast minimum
- No channel clips beyond the black or white point
- No hue shift beyond the token tolerance (default 2 degrees)
- No saturation shift beyond the token tolerance (default 5%)
