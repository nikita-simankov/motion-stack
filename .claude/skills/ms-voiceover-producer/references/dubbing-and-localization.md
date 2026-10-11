# Dubbing and Localization

Dubbing v2 flow, language codes, alignment. Used when brief.Q19 is C or D, or on explicit dub invocation.

## Dubbing v2

- Audio-to-audio model
- Preserves emotion, tone, and timing from the source
- Sync-aware translation
- Automatic voice cloning for the target language
- 90+ languages

## Inputs

- Source audio: runs/<id>/audio/vo-stem.wav
- Target language: ISO 639-1 code (e.g. es, fr, de, ja, pt-BR, zh-Hans)
- Voice: preserved automatically from the source

## Procedure

1. Verify the VO stem is final (gate 9 passed).
2. Verify the target language is in the brief's Q19 scope.
3. Call the Dubbing v2 endpoint with the source and target language.
4. Receive the dubbed audio.
5. Measure duration. Compare to the source duration.
6. Re-run frame alignment against the original script.
7. Re-run loudness normalization to the audio tokens.
8. Save to runs/<id>/audio/dubbed/<lang>/stem.wav.
9. Hash and record.
10. Run QA on the dubbed stem (same VO-xx codes, plus alignment delta).

## Alignment tolerance

- Per line, the dubbed audio must land within 3 frames of the source line's frame anchor.
- Drift beyond 3 frames fails and requires regeneration or a language-specific re-cut.
- If Dubbing v2 cannot align (e.g. target language has very different syllable density), the language is marked as re-cut required. The re-cut uses the same script beat structure with a rewritten VO in that language, generated via text-to-speech at the target language model.

## Language codes

Common:

- es — Spanish (Spain)
- es-MX — Spanish (Mexico)
- fr — French
- de — German
- it — Italian
- pt — Portuguese
- pt-BR — Portuguese (Brazil)
- ja — Japanese
- ko — Korean
- zh-Hans — Chinese (Simplified)
- zh-Hant — Chinese (Traditional)
- ar — Arabic
- hi — Hindi
- ru — Russian

Use the exact code ElevenLabs expects. Unknown codes are rejected.

## Localized captions

When brief.Q19 is C or D, generate localized captions:

- Source: the dubbed stem
- Method: forced alignment (via stage 14 or a caption pipeline)
- Format: SRT and VTT per language
- Storage: runs/<id>/captions/<lang>/

Dubbed captions are not translations of the source captions. They are alignments to the dubbed audio.

## Cost and limits

- Dubbing is priced per minute of source audio.
- Character limits are not the constraint; duration is.
- Long videos may be split into chunks and re-joined; alignment is preserved.

## Rejected patterns

- Dubbing from a non-final VO stem
- Dubbing from a compressed MP3 when a WAV exists
- Mixing dubbed audio from multiple calls without re-alignment
- Delivering dubbed audio without a QA record

## Consent

Dubbing clones the original voice into the target language. It does not require additional consent beyond the source voice consent. Any language-specific voice swap (e.g. a native speaker replacing the original voice) requires new consent and is a separate pipeline.
