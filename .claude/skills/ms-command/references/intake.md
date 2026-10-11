# Intake Questionnaire

Triggered by /ms-command intake, or automatically when /ms-command is invoked without a brief.

## Rules

- Ask one question per turn. Never stack questions.
- Every question presents lettered choices A-D plus "E) Other" and a default.
- Mark the recommended choice with a star: A\* .
- Accept a bare letter. Accept a letter with notes. Accept "default" to take the star.
- After each answer, echo the locked answer in one line, then ask the next question.
- Minimum viable intake is Q1-Q10. Q11-Q20 are optional and can be skipped with "skip".
- When intake completes, print the Intake Summary and ask: "lock brief? [yes / revise <n>]".

## Q1 — Objective

What is this video meant to achieve? Choose the primary outcome.
A\* Awareness — introduce a topic, product, or brand to a new audience. Success metric: reach, impressions, first-time viewers.
B Consideration — teach, explain, or demonstrate value. Success metric: watch-through rate, saves, shares.
C Conversion — drive a specific action. Success metric: CTR, conversion rate.
D Authority — establish expertise or point of view. Success metric: engagement quality, comments, follower growth.
E Other

## Q2 — Audience

Who is the primary viewer? Demographics, role, industry, sophistication, prior knowledge.
A\* Practitioners and operators — they do the work daily. They want depth, not definitions.
B Decision makers and buyers — they approve budgets. They want ROI, risk, differentiation.
C General professional audience — broad, mixed roles. They want clarity and relevance.
D Consumers, non-professional — entertainment, utility, emotional resonance. No jargon.
E Other

## Q3 — Runtime

Target runtime for the master cut. Drives frame count at 30fps: 15s=450, 30s=900, 60s=1800, 90s=2700.
A 15s — 450 frames. Hook-only. One idea, zero fat.
B\* 30s — 900 frames. Hook + one point + CTA. Workhorse format.
C 60s — 1800 frames. Hook + two to three points + CTA. Needs narrative discipline.
D 90s — 2700 frames. Full narrative arc. Highest production demand.
E Other

## Q4 — Platform set

Where does this ship? Primary platform; secondary added at distribution. Each platform cut is native, not resized.
A LinkedIn only — 1:1 / 4:5 / 16:9. 1080p. 90s feed, 10m native.
B LinkedIn + X — 16:9 primary. X: 140s max.
C\* Vertical-first: Reels + TikTok + YouTube Shorts — 9:16, 1080x1920.
D All platforms, native cuts each — full distribution matrix.
E Other

## Q5 — Tone

Sets script register, pacing, motion energy.
A Authoritative and plain — no hype, no filler. Facts delivered with confidence.
B\* Punchy and native — platform-native rhythm. Short sentences. Hook-forward.
C Measured and substantive — slower pace, deeper argument, trust-building.
D Kinetic and minimal copy — motion carries meaning. Text is accent.
E Other

## Q6 — Concept posture

Risk appetite for the creative team.
A Safe — proven format, clean execution.
B\* Distinct — one clear idea, executed with craft.
C Bold — unconventional structure or visual language.
D Experimental — risk-forward, portfolio-grade.
E Other

## Q7 — Visual direction

Sets style tokens: palette, type, motion language, texture, grade.
A Clean editorial — type-led, restrained palette, generous negative space.
B\* Brand-native — palette, type, motion locked to brand tokens.
C Cinematic — depth, light, texture, grade-forward.
D Graphic and kinetic — bold shapes, fast motion, high contrast.
Q7 starts gate 6 from a look bundle: A editorial-clean, B brand-native, C cinematic-grain, D kinetic-graphic (also dark-product-ui with Q8 C/D and tactile-analog as variants). See ms-styleframe-designer/references/looks.md.
E Other

## Q8 — UI mockup posture

Does this video require professional UI mockups? Fidelity, device frame, interaction state.
A No UI mockups — abstract graphics, type, motion only.
B\* Light UI — simple app screens, cards, interface elements. Screen-recording feel acceptable.
C High-fidelity UI — professional mockups in device frames. Realistic states, hover, transitions. Built as Remotion React components with absolute positioning and frame-driven animation.
D Full product demo — interactive walkthrough with cursor movement, click states, loading states, success/error states. Built as Remotion composition with <Sequence> per interaction step.
E Other

## Q9 — Voiceover posture

All VO generated via ElevenLabs.io API.
A\* Professional VO, studio-quality — eleven_multilingual_v2, stability optimized, pre-made voice. Script pre-timed, rendered per line.
B Founder or client voice — ElevenLabs Instant Voice Cloning (IVC), 1-3 minutes of reference audio.
C Text-on-screen only, no VO — captions and kinetic type carry narrative.
D AI voice, disclosed — eleven_turbo_v2_5 for speed. Disclosure in description and lower-third.
E Other

## Q10 — Deliverable count

Each platform cut is native to aspect ratio and duration, not a resized master.
A 1 master only — single aspect ratio, single runtime.
B\* 1 master + platform-native cuts — one cut per platform in the selected set.
C 1 master + cuts + 3 short teasers — plus three 6-10s teasers.
D Full campaign set — master, cuts, teasers, 3-5 stills, burned captions, SRT/VTT, thumbnail frames, metadata pack.
E Other

## Q11 — References (optional)

A None — trust the studio.
B\* I will paste 1-3 links now. Extract motion language, pacing, visual refs.
C Use past Motion Studio work in this category.
D Competitor work — match or beat. Study and differentiate.
E Other

## Q12 — Music posture (optional)

A\* Licensed track, ducked under VO — pre-cleared library or client-provided. -14 LUFS integrated, ducked to -18 LUFS under dialogue. Registered in music license registry.
B Original score — composed to picture.
C No music, SFX only — sound design carries the audio bed.
D Client-provided track — client supplies file and license.
E Other

## Q13 — Audio mix targets (optional)

A\* Broadcast-standard — -14 LUFS integrated, -1 dBTP true-peak. VO -16 LUFS, music ducked -18 LUFS under VO, SFX -20 LUFS.
B Loud and aggressive — -10 LUFS integrated. Punchy, higher fatigue.
C Cinematic dynamic — -20 LUFS integrated, wider dynamic range.
D Match client spec — client provides loudness targets.
E Other

## Q14 — Deadline (optional)

A Same day — fast track. Minimal revisions. Concept-to-master in 6 hours.
B\* This week — standard track. Two revision rounds per stage.
C Next week — full track. Open revisions, senior craft pass, QA regression.
D Flexible — no deadline pressure. Maximum craft.
E Other

## Q15 — Approval chain (optional)

A\* Single approver — me. Fastest path.
B Two approvers — creative + brand. Parallel review.
C Committee — three or more. Expect two additional revision cycles.
D Client-side legal review required — compliance gate before master delivery.
E Other

## Q16 — Budget tier (optional)

A Lean — one revision round per stage. Internal or test content.
B\* Standard — two revision rounds per stage. Full QA regression. Client work.
C Premium — open revisions, senior craft pass, additional QA cycles, dedicated color and sound polish.
D Unspecified
E Other

## Q17 — Motion stack specifics (optional)

A\* Remotion standard — React components in Remotion. Animations via useCurrentFrame(). No CSS transitions or Tailwind animations. Local npx remotion render or @remotion/lambda.
B Remotion Lambda priority — distributed rendering required. @remotion/lambda with memory optimization (3009MB = 3 vCPUs).
C Remotion + Three.js — 3D content via <ThreeCanvas>. Higher render cost, higher visual impact. Needs the Q17=C sub-spec (lighting, materials, camera, render budget; ms-asset-generator/references/asset-types.md).
D Remotion + Lottie/Rive — vector animation assets as <Lottie> or <RemotionRiveCanvas>.
E Other

## Q18 — Voice synthesis specifics (optional)

A\* ElevenLabs Multilingual v2 — eleven_multilingual_v2. Stability and accent accuracy. 29 languages. Recommended for most use cases.
B ElevenLabs Flash v2.5 — eleven_flash_v2_5. Ultra-low latency, 50% lower cost. 32 languages. Rapid iteration.
C ElevenLabs Turbo v2.5 — eleven_turbo_v2_5. Balanced quality and latency. 32 languages.
D ElevenLabs Dubbing v2 — multi-language versions. Audio-to-audio conditioning preserves emotion, tone, timing across 90+ languages.
E Other

## Q19 — Caption and localization (optional)

A\* Burned-in + SRT — burned captions for silent autoplay, SRT sidecar. English only. Burned style follows tone: cue (authoritative, measured) or word-highlight / word-pop (punchy, kinetic, playful); word-level styles need word timings from the voiceover stage.
B Burned-in + SRT + VTT — adds VTT for YouTube Shorts and web players.
C Multi-language — SRT in 2-3 languages via ElevenLabs dubbing or manual translation. Burned captions in primary language.
D Full localization — dub to 3+ languages via Dubbing v2, localized captions and metadata per language.
E Other

## Q20 — Thumbnail and cover frame (optional)

A\* Auto-extracted — pull 3 candidate frames at key visual moments.
B Designed thumbnail — custom composition in Remotion, rendered as still via renderStillOnWeb() or npx remotion still.
C Both — auto-extracted candidates plus one designed option.
D Client provides — client supplies thumbnail asset.
E Other

============================================================
INTAKE SUMMARY
============================================================

Printed once intake completes, before brief lock.

MOTION STUDIO — INTAKE SUMMARY
project-id: <slug derived from topic>
objective: <Q1>
audience: <Q2>
runtime: <Q3> (<frames> frames at 30fps)
platforms: <Q4>
tone: <Q5>
concept posture: <Q6>
visual direction: <Q7>
UI mockup posture: <Q8>
voiceover posture: <Q9>
deliverables: <Q10>
references: <Q11>
music: <Q12>
audio mix: <Q13>
deadline: <Q14>
approval chain: <Q15>
budget tier: <Q16>
motion stack: <Q17>
voice synthesis: <Q18>
captions: <Q19>
thumbnail: <Q20>

lock brief? [yes / revise <n>]

On "yes": write runs/<project-id>/brief.md, close gate 1 (Brief locked), dispatch ms-topic-research.
On "revise <n>": re-ask question n only, update the summary, re-print.
