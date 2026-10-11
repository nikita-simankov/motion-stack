# Thumbnail Variants

Thumbnail adaptation per platform.

## Per platform

### LinkedIn (1:1)

- Resolution: 1200x1200
- Text max: 6 words
- Subject: a hero visual or a designed card
- Contrast: 4.5:1
- Legibility: readable at 25% scale in the feed

### LinkedIn (4:5)

- Resolution: 1080x1350
- Same rules as 1:1

### LinkedIn (16:9)

- Resolution: 1280x720
- Same rules as 1:1

### Instagram Reels

- Resolution: 1080x1920 (cover frame)
- Cover shows in the Reels grid at small size
- Text max: 6 words
- Safe area: keep text in the central 60% for grid cropping

### TikTok

- Resolution: 1080x1920 (cover frame)
- Cover shows in the profile grid at small size
- Text max: 4 words
- Safe area: keep text in the central 50%

### YouTube Shorts

- Resolution: 1280x720 (search and related video display)
- Text max: 6 words
- Contrast: 4.5:1

### X

- Resolution: 1280x720 or 1200x1200
- Text max: 6 words
- Contrast: 4.5:1

## Auto-extracted candidates

- 3-5 frames per platform cut
- From the platform cut, not the master
- Key frames: hook peak, proof peak, CTA
- Exported at the platform's thumbnail resolution
- Saved as PNG

## Designed thumbnails

- Remotion composition at the platform's resolution
- Uses frozen tokens and the asset manifest only
- Text legible at 25% scale
- Title or key claim per the concept
- No more than 6 words of text
- No text over a busy area without a scrim or overlay

## Chosen thumbnail

- One chosen thumbnail per platform
- Recorded in distribution.json
- Copied into the platform folder
- Hashed in sha256sums.txt

## Rules

- Every platform has a thumbnail at the platform's resolution.
- Every thumbnail is hashed.
- No thumbnail uses fonts or colors not in the tokens.
- No thumbnail exceeds the platform's file size limit (YouTube: 2 MB).
- No thumbnail is below the platform's minimum resolution.

## Rejected

- Thumbnails from ungraded masters
- Thumbnails with watermarks
- Thumbnails with a caption obscuring the subject
- Thumbnails using fonts or colors not in the tokens
- Thumbnails with more than 6 words of text unless the concept permits
- Thumbnails with text under 4.5:1 contrast
- Thumbnails that misrepresent the video

## Determinism

- Auto-extraction is deterministic.
- Designed thumbnail rendering is deterministic.

## Reporting

Emit a contact sheet per platform at runs/<id>/previews/thumbnails-<platform>-contact.png.
