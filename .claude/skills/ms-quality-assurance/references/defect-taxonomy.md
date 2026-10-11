# Defect Taxonomy

Full defect code list and routing table.

## Codes and routes

CUT-xx Cut, timing, transition ms-video-editor
ANIM-xx Animation, easing, Remotion errors ms-motion-designer
AUD-xx Audio balance, SFX, loudness ms-sound-designer
GRD-xx Grade, palette drift ms-color-grader
FIN-xx Codec, loudness, slate, metadata ms-finishing-suite
CPT-xx Copy, hook, caption (distribution) ms-social-distributor
BRD-xx Voice, vocabulary, banned terms current stage
VO-xx Voice synthesis quality, pacing, model ms-voiceover-producer
RND-xx Remotion render failure, Lambda error ms-motion-designer or ms-video-editor
MU-xx Music licensing, cue sheet, mix ms-music-supervisor
SD-xx SFX placement, licensing, masking ms-sound-designer
LEG-xx Legal (licenses, attributions, consent) owning stage
ACC-xx Accessibility (contrast, captions, alt) owning stage
TYP-xx Type hierarchy, kinetic type, readability ms-motion-designer
CMP-xx Composition, focal point, grid, platform insets ms-motion-designer
CAP-xx Caption timing, style, safe zone ms-finishing-suite
SCR-xx Script (claim trace, hook, CTA, timing) ms-script-writer
STB-xx Board (coverage, transition, framing) ms-storyboard-artist
STY-xx Style token (drift, spec-not-reference) ms-styleframe-designer
AST-xx Asset (placeholder, license, loader) ms-asset-generator
RES-xx Research (unsourced claim, aging) ms-topic-research
CNC-xx Concept (differentiation, structure) ms-concept-developer

## Severity levels

blocker Halts the pipeline. Nothing advances until resolved.
major Halts the gate. Batched into a single revision round.
minor Recorded. Does not halt.

## Example codes

### CUT-xx (video editor)

CUT-01 Missing scene in the timeline
CUT-03 Runtime mismatch
CUT-04 Gap in the timeline
CUT-08 Transition mismatch
CUT-14 Audio anchor misaligned by more than 1 frame
CUT-15 Cut more than snapFrames off the beat grid when rhythm.beatGrid.required is true
CUT-16 Loop seam above threshold (frame 0 vs final frame)
CUT-17 Audio or caption straddles the loop seam

### ANIM-xx (motion designer)

ANIM-01 CSS transition detected in source
ANIM-02 Tailwind animation class detected
ANIM-03 useCurrentFrame not used for animation
ANIM-04 Easing outside the frozen bucket
ANIM-05 Transition outside the frozen set

ANIM-06 interpolate() with no easing (linear by accident)
ANIM-07 Group of three or more animated with no stagger
ANIM-08 Text hold below max(minHoldFrames, words x readHoldFramesPerWord)
ANIM-09 One curve covers more than 80% of the eased motion
ANIM-10 spring() with an inline config instead of a named preset
ANIM-11 interpolate() not clamped on both sides
ANIM-12 Exit longer than the entrance it answers
ANIM-13 Static literal blur() outside MotionBlur or CameraRig
ANIM-14 Dead hold longer than rhythm.maxStaticFrames without an isolated framing (motion proof sheet)
ANIM-15 Motion blur on counting numbers or per-glyph reveals
ANIM-16 Hex colour in scene source that is not in the frozen palette

### TYP-xx (type)

TYP-01 Two competing text blocks within 1.5x of each other in one beat
TYP-02 Text below the role minimum size at the target aspect
TYP-03 Variable-font axis value outside the declared range
TYP-04 Kinetic preset mixed within one text block

### CMP-xx (composition)

CMP-01 No clear focal element in a beat
CMP-02 Element off the layout grid or baseline without a board note
CMP-03 Readable content inside the platform overlay zone
CMP-04 More than four parallax layers, or camera zoom above camera.maxZoom without a board note

### CAP-xx (captions)

CAP-01 Word-level caption more than 1 frame off its VO word
CAP-02 Caption outside the platform insets
CAP-03 Caption style differs from captions.style in the tokens
CAP-04 Caption page exceeds captions.maxWordsPerPage

### AUD-xx (sound designer)

AUD-01 SFX masks VO band
AUD-02 SFX loudness above category ceiling
AUD-03 Ambient bed not ducked under VO

### GRD-xx (color grader)

GRD-01 Operation order mismatch
GRD-03 Palette color below contrast minimum after grade
GRD-04 Black point measured off by more than 1
GRD-08 Texture intensity outside tolerance
GRD-12 Determinism check failed

### FIN-xx (finishing)

FIN-01 Codec mismatch
FIN-05 Loudness out of spec
FIN-12 Metadata incomplete
FIN-15 Hash mismatch

### VO-xx (voice)

VO-01 Overrun beyond 10%
VO-03 Clipping
VO-06 Model drift / timbre mismatch
VO-08 Loudness out of spec

### MU-xx (music)

MU-01 Cue has no license record
MU-04 Not Content ID cleared
MU-09 Hit cue lands more than 1 frame off anchor

### SD-xx (sound design)

SD-02 Placement has no license or synthesis spec
SD-07 Placement masks VO band without ducking
SD-09 Synthesized SFX missing spec

### LEG-xx (legal)

LEG-01 Asset missing license
LEG-02 Music cue missing license
LEG-03 Attribution required but not present in metadata
LEG-04 AI disclosure missing
LEG-05 Sponsored disclosure missing
LEG-06 Voice clone without written consent
LEG-07 Public figure likeness used without consent
LEG-08 Third-party mark used without license

### ACC-xx (accessibility)

ACC-01 Text contrast below WCAG minimum after grade
ACC-02 Caption missing in a required format
ACC-03 Caption out of sync by more than 1 frame
ACC-04 Caption obscures critical UI
ACC-05 Color-only signaling of state
ACC-06 Alt text missing for a published thumbnail
ACC-07 Flashing above the seizure threshold

### SCR-xx (script)

SCR-01 Untraced fact
SCR-02 Hook fails to land inside the first 2 seconds
SCR-03 CTA missing or unclear
SCR-04 VO line overruns its budget

### STB-xx (boards)

STB-01 Uncovered frame
STB-02 Orphan board
STB-03 Transition mismatch between adjacent boards
STB-04 Board requires a renderer outside the brief's motion stack

### STY-xx (style)

STY-01 Token is a reference, not a spec
STY-02 Palette contrast fails
STY-03 Type role missing from the token set
STY-04 Motion bucket outside the frozen set
STY-05 v2 sections defaulted, not authored (minor, v1 token file read as v2)

### AST-xx (assets)

AST-01 Placeholder asset present
AST-02 Asset missing license
AST-03 Asset not loadable via a named Remotion loader
AST-04 Orphan asset without a reason

### RES-xx (research)

RES-01 Claim used in the script has no source
RES-02 Claim confidence is low but claim is used
RES-03 Claim ages out inside the publication window

### CNC-xx (concept)

CNC-01 Two concepts share a structural family
CNC-02 Selected concept scores below the floor
CNC-03 Concept duplicates a competitor's lead claim

## Routing rules

- Route to the stage that owns the artifact.
- If two stages could fix it, route to the earlier stage that avoids breaking a downstream contract.
- If the fix requires a token change, route to stage 6 with a rollback.
- If the fix requires a picture change, route to stage 12 with a rollback.
- If the fix is legal, route to the stage that produced the artifact.

## Severity assignment

Default severities:

- Legal defects: blocker
- Accessibility defects: blocker for captions and contrast, major for alt text
- Determinism failures: blocker
- Placeholder assets: blocker
- Loudness out of spec: major
- Palette contrast: blocker
- Single-frame misalignment: minor unless it is audible or visible
- Cosmetic timing: minor

Severity is assigned by the QA director at review time, using the defaults. Any deviation from the defaults is recorded with a reason.

## Overrides

Blockers and majors cannot be waived by QA. Only the client can waive, and the waiver is recorded in run.json.approvals with a written reason and a signature.

Legal defects cannot be waived by the client. They halt the pipeline until resolved.
