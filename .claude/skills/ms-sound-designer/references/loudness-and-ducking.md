# Loudness and Ducking

Loudness targets, ducking implementation, and VO-band protection.

## Loudness targets

From style-tokens.audio:

- sfxLUFS — default -20 LUFS integrated
- truePeakDBTP — default -1 dBTP
- musicDuckLUFS — default -18 LUFS (used by stage 11)
- voLUFS — default -16 LUFS (reference for ducking)

Category short-term targets:

impact -14 to -10 LUFS short-term
transition -22 to -16 LUFS short-term
ui -26 to -20 LUFS short-term
ambient -30 to -24 LUFS short-term
accent -30 to -26 LUFS short-term
riser -22 to -16 LUFS short-term
stinger -18 to -14 LUFS short-term

The integrated SFX stem target is the token target (default -20 LUFS). Category targets are peak short-term values, not integrated.

## Tolerance

- Integrated: within 0.5 LU of the token target
- True peak: <= the token truePeakDBTP
- Any placement above its category ceiling: flagged

## Ducking against VO

Ducking is applied when an SFX overlaps a VO line and would mask the VO band.

Rules:

- VO band: 300 Hz - 3.4 kHz
- Masking threshold: SFX energy > -22 dBFS in the band during VO
- Duck amount: 6 dB default, up to 12 dB for ambient beds
- Ducking is applied per placement, not per bus
- Ducking is sidechain-triggered by the VO stem, not hand-authored

Implementation:

- Compute the VO stem's envelope in the 300 Hz - 3.4 kHz band
- For each SFX placement, compute its envelope in the same band
- If the SFX envelope exceeds the threshold while the VO envelope is active, apply ducking for the overlap
- Record the duck amount per placement in sfx.json

## Ambient bed ducking

Ambient beds duck by 12 dB under VO. This is a stronger duck than impacts and transitions.

Rule of thumb:

- VO line present + ambient bed present → duck bed by 12 dB
- VO line present + transition present → duck transition by 6 dB
- VO line present + accent present → duck accent by 3 dB or move it outside the VO

## Stinger ducking

Stingers are not ducked. They are placed where VO is silent or sparse. If a stinger must overlap a VO line, the CTA VO line is short enough to be re-timed by stage 4 to avoid the overlap.

## Loudness measurement

- Short-term loudness: 3-second window, sliding
- Integrated loudness: full-program, EBU R128 / ITU-R BS.1770
- True peak: oversampled 4x, per ITU-R BS.1770
- Measurements via ffmpeg loudnorm or an equivalent EBU R128 meter

## Anti-patterns

- Ducking with a hard gate (creates pumping)
- Ducking without recording the amount
- Ducking above 12 dB (creates audible pumping)
- Sidechain compression over the entire SFX bus (mask-level detail)
- Loudness normalization above the token target (the mix should be honest)

## Deliverables

- SFX stem: runs/<id>/audio/sfx-stem.wav (48kHz, 24-bit)
- Preview: runs/<id>/audio/sfx-stem.mp3 (192 kbps)
- Duck map: recorded in sfx.json per placement
- Loudness report: recorded in sfx.json.qa
