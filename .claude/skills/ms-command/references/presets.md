# Presets

Load when --preset flag is set.

--preset <name> sets runtime, platform set, tone, and deliverable count in one flag. Skips Q3, Q4, Q5, Q8, Q10 in intake.

explainer-30s-linkedin 30s LinkedIn, X Authoritative, plain
hook-15s-reels 15s Reels, TikTok Punchy, native
thought-leadership-60s 60s LinkedIn, YouTube Shorts Measured, substantive
product-teaser-20s 20s All vertical Kinetic, minimal copy
ui-demo-45s 45s LinkedIn, X Authoritative, plain, full UI mockup
campaign-full 90s All platforms Brand-native, full campaign set

v2 look and motion defaults per preset (override with --look <bundleId> or at gate 6; see ms-styleframe-designer/references/looks.md):

explainer-30s-linkedin editorial-clean, measured motion, cue captions
hook-15s-reels kinetic-graphic, punchy motion, word-highlight captions, seamless-loop rule on (loop.enabled true)
thought-leadership-60s editorial-clean or tactile-analog, measured motion, cue captions
product-teaser-20s kinetic-graphic or dark-product-ui, punchy motion, word-highlight captions
ui-demo-45s dark-product-ui, punchy motion, smart zoom on, word-highlight captions
campaign-full brand-native, per-tone motion
