# Brand Voice Enforcement

Load on stages 4, 6, 8, 12, 14, 16.

ms-brand-voice loads at every stage and is never gated on its own.

- Stages 4, 6, 8, 12, 14, 16 must pass a brand-voice check before their gate can pass
- Checks cover voice attributes, tone shift for the target platform, vocabulary preferences, banned terms, and paired-example alignment
- A brand-voice failure is a stage failure. Route back to the current stage, not to ms-brand-voice
- Banned-term hits are a hard fail, not a warning
