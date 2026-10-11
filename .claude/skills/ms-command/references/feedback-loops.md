# Feedback Loops

Load on any rejection or defect routing turn.

ms-quality-assurance may reject and route back by defect code.

CUT-xx Cut, timing, transition ms-video-editor
ANIM-xx Animation, easing, Remotion errors ms-motion-designer
AUD-xx Audio balance, SFX, loudness ms-sound-designer
GRD-xx Grade, palette drift ms-color-grader
FIN-xx Codec, loudness, slate, metadata ms-finishing-suite
CPT-xx Copy, hook, caption ms-social-distributor
BRD-xx Voice, vocabulary, banned terms current stage
VO-xx Voice synthesis quality, pacing, model ms-voiceover-producer
RND-xx Remotion render failure, Lambda error ms-motion-designer or ms-video-editor
TYP-xx Type hierarchy, kinetic type, readability ms-motion-designer
CMP-xx Composition, focal point, grid, platform insets ms-motion-designer
CAP-xx Caption timing, style, safe zone ms-finishing-suite
STY-xx Style token drift, v2 sections defaulted ms-styleframe-designer
ACC-xx Accessibility owning stage

Full code list: ms-quality-assurance/references/defect-taxonomy.md.

## Rules

On rejection: increment the target stage's revision count, re-run only that stage, mark downstream stale, then re-run ms-quality-assurance. Never re-run the full pipeline for a single defect class.

Regression check: after any revision, QA re-runs all prior checks, not just the failed one.

Escalation: three failed revisions on one stage halts the run and presents options via questionnaire.
