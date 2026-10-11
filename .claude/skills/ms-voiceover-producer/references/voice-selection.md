# Voice Selection

Three paths: pre-made voice, Instant Voice Cloning, and AI-disclosed turbo.

## Pre-made voice (brief.Q9 = A)

- Use an ElevenLabs pre-made voice
- voice_id recorded in vo.json
- Client profile overrides the studio default when supplied
- Studio default narration voice_id is declared in runs/\_studio.json

Rules:

- Pre-made voices do not require consent
- Voice settings default to stability 0.5, similarity_boost 0.75, style 0.0
- Lower stability gives more expressive range; higher stability gives more consistency. Default to 0.5 for narration; 0.65+ for technical or authoritative delivery.

## Instant Voice Cloning (brief.Q9 = B)

Requirements:

- 1-3 minutes of reference audio, clear, no background noise, single speaker
- Speaker consent, in writing
- Consent document stored at runs/\_clients/<profile>/consent-<voiceName>.pdf
- Consent recorded in licenseOrConsent with consentPath

Procedure:

1. Confirm the reference audio meets quality bar (no clipping, no noise, single speaker).
2. Call the IVC endpoint with the samples.
3. Receive the voice_id.
4. Store the voice_id in the client profile.
5. Optionally verify with a short test line.
6. Freeze for the run.

Rules:

- The clone is specific to the client and is not reused across clients.
- The clone is deleted on client request or when the engagement ends.
- Any voice that impersonates a third party without consent is rejected.
- Public figures are rejected unless the figure is the client and consent is on file.

## AI-disclosed (brief.Q9 = D)

- Use eleven_turbo_v2_5 for speed
- Disclosure text recorded in vo.json.licenseOrConsent.disclosureText
- Disclosure appended to the video description in the distribution pack
- Disclosure rendered as a lower third unless the brief explicitly suppresses it
- Suppression requires explicit client sign-off and is logged

## No voiceover (brief.Q9 = C)

- Skip generation entirely
- Emit vo.json with empty lines and a reason
- Pass gate 9 with a no-vo marker

## Voice settings guide

- stability — 0.0 (expressive) to 1.0 (monotone-consistent). Default 0.5. For narration with consistent timbre, 0.65.
- similarity_boost — 0.0 (loose) to 1.0 (tight to the reference). Default 0.75. For clones, 0.85.
- style — 0.0 (neutral) to 1.0 (exaggerated). Default 0.0 for narration. Rarely higher than 0.3.
- use_speaker_boost — true by default; enhances clarity in VO.

## Rejected voice choices

- Public figures without consent
- Voices from libraries without a commercial license
- Clones trained on fewer than 60 seconds of audio
- Clones with background noise, music, or multiple speakers
- Any voice that would confuse the audience about the speaker's identity
