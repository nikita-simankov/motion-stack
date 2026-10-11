# Intake Questions

Full question text with choices, starred recommendations, and defaults. Mirrors ms-command/references/intake.md. If the two ever diverge, this file wins.

## Rules

- Ask one question per turn.
- A-D plus E) Other. Star the recommendation.
- Accept bare letter, letter with notes, or "default".
- Confirm each answer in one line, then ask the next.
- Minimum viable: Q1-Q10.
- Optional: Q11-Q20, skippable with "skip".

## Q1 — Objective

What is this video meant to achieve? Primary outcome only.
A\* Awareness — introduce a topic, product, or brand. Metric: reach, impressions, first-time viewers.
B Consideration — teach, explain, demonstrate value. Metric: watch-through, saves, shares.
C Conversion — drive an action. Metric: CTR, conversion rate.
D Authority — establish expertise or POV. Metric: engagement quality, follower growth.
E Other

Default: A

## Q2 — Audience

Who is the primary viewer? Role, industry, sophistication, prior knowledge.
A\* Practitioners and operators — daily users. Want depth, not definitions.
B Decision makers and buyers — approve budgets. Want ROI, risk, differentiation.
C General professional audience — mixed roles. Want clarity and relevance.
D Consumers, non-professional — want entertainment or utility. No jargon.
E Other

Default: A

## Q3 — Runtime

Master cut runtime. Frames at 30fps: 15s=450, 30s=900, 60s=1800, 90s=2700.
A 15s — 450 frames. Hook-only. One idea.
B\* 30s — 900 frames. Hook + point + CTA. Workhorse.
C 60s — 1800 frames. Hook + 2-3 points + CTA.
D 90s — 2700 frames. Full narrative arc.
E Other

Default: B

## Q4 — Platform set

Primary platform. Secondary platforms require native cuts at distribution.
A LinkedIn only — 1:1 / 4:5 / 16:9. 1080p. 90s feed, 10m native.
B LinkedIn + X — 16:9 primary. X: 140s max.
C\* Vertical-first: Reels + TikTok + YouTube Shorts — 9:16, 1080x1920.
D All platforms, native cuts each.
E Other

Default: C

## Q5 — Tone

Register, pacing, motion energy.
A Authoritative and plain — facts, no hype.
B\* Punchy and native — short sentences, hook-forward.
C Measured and substantive — slower pace, deeper argument.
D Kinetic and minimal copy — motion carries meaning.
E Other

Default: B

## Q6 — Concept posture

Risk appetite.
A Safe — proven format.
B\* Distinct — one clear idea, executed with craft.
C Bold — unconventional structure or visual language.
D Experimental — portfolio-grade, high risk.
E Other

Default: B

## Q7 — Visual direction

Sets style tokens.
A Clean editorial — type-led, restrained.
B\* Brand-native — locked to brand tokens.
C Cinematic — depth, light, texture.
D Graphic and kinetic — bold shapes, fast motion.
E Other

Default: B

## Q8 — UI mockup posture

Fidelity, device frame, interaction state.
A No UI mockups.
B\* Light UI — simple screens, cards, screen-recording feel.
C High-fidelity UI — device frames, realistic states, hover, transitions. Remotion React components.
D Full product demo — cursor, click states, loading, success/error. <Sequence> per step.
E Other

Default: B

## Q9 — Voiceover posture

All VO via ElevenLabs.io.
A\* Professional VO — eleven_multilingual_v2, stability-optimized, pre-made voice, pre-timed script.
B Founder or client voice — IVC with 1-3 minutes of reference audio.
C Text-on-screen only — no VO.
D AI voice, disclosed — eleven_turbo_v2_5, disclosure in description and lower-third.
E Other

Default: A

## Q10 — Deliverable count

Each platform cut is native, not resized.
A 1 master only.
B\* 1 master + platform-native cuts.
C 1 master + cuts + 3 short teasers.
D Full campaign set — master, cuts, teasers, stills, burned captions, SRT/VTT, thumbnails, metadata.
E Other

Default: B

## Q11 — References (optional)

A None — trust the studio.
B\* I will paste 1-3 links now.
C Use past Motion Studio work in this category.
D Competitor work — match or beat.
E Other

Default: A

## Q12 — Music posture (optional)

A\* Licensed track, ducked under VO — -14 LUFS integrated, -18 LUFS under dialogue. Registered in music license registry.
B Original score.
C No music, SFX only.
D Client-provided track.
E Other

Default: A

## Q13 — Audio mix targets (optional)

A\* Broadcast-standard — -14 LUFS, -1 dBTP. VO -16, music ducked -18 under VO, SFX -20.
B Loud and aggressive — -10 LUFS.
C Cinematic dynamic — -20 LUFS, wider range.
D Match client spec.
E Other

Default: A

## Q14 — Deadline (optional)

A Same day.
B\* This week — two revision rounds per stage.
C Next week — open revisions, senior craft pass.
D Flexible.
E Other

Default: B

## Q15 — Approval chain (optional)

A\* Single approver.
B Two approvers — creative + brand.
C Committee — expect two extra revision cycles.
D Client-side legal review required.
E Other

Default: A

## Q16 — Budget tier (optional)

A Lean — one revision per stage.
B\* Standard — two revisions per stage, full QA regression.
C Premium — open revisions, senior craft pass, additional QA, dedicated color and sound polish.
D Unspecified.
E Other

Default: B

## Q17 — Motion stack specifics (optional)

A\* Remotion standard — React components, useCurrentFrame(), no CSS transitions. Local or Lambda render.
B Remotion Lambda priority — distributed rendering. 3009MB = 3 vCPUs.
C Remotion + Three.js — 3D via <ThreeCanvas>.
D Remotion + Lottie/Rive — vector assets via <Lottie> or <RemotionRiveCanvas>.
E Other

Default: A

## Q18 — Voice synthesis specifics (optional)

A\* ElevenLabs Multilingual v2 — eleven_multilingual_v2. Stability, 29 languages.
B ElevenLabs Flash v2.5 — eleven_flash_v2_5. Low latency, 50% lower cost, 32 languages.
C ElevenLabs Turbo v2.5 — eleven_turbo_v2_5. Balanced, 32 languages.
D ElevenLabs Dubbing v2 — audio-to-audio, 90+ languages, preserves emotion and timing.
E Other

Default: A

## Q19 — Caption and localization (optional)

A\* Burned-in + SRT — English only.
B Burned-in + SRT + VTT — adds VTT for Shorts and web.
C Multi-language — SRT in 2-3 languages.
D Full localization — dub to 3+ languages via Dubbing v2.
E Other

Default: A

## Q20 — Thumbnail and cover frame (optional)

A\* Auto-extracted — 3 candidate frames.
B Designed thumbnail — Remotion still via renderStillOnWeb() or npx remotion still.
C Both.
D Client provides.
E Other

Default: A
