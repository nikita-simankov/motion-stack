# ElevenLabs Stack Contract

Load on stage 9, intake Q18, and any localization turn.

All voice synthesis is built on ElevenLabs.io API.

## Model selection (per intake Q18)

- eleven_multilingual_v2 — stability, language diversity, accent accuracy. 29 languages. Recommended for most use cases.
- eleven_flash_v2_5 — ultra-low latency, 50% lower cost per character. 32 languages. For rapid iteration.
- eleven_turbo_v2_5 — balanced quality and latency. 32 languages. For developer pipelines.

## API integration

- Python: pip install elevenlabs; from elevenlabs.client import ElevenLabs
- Text-to-speech: client.text_to_speech.convert(text, voice_id, model_id, output_format)
- Streaming: client.text_to_speech.stream() for real-time generation
- Voice search: client.voices.search() to list available voices
- Voice settings: client.voices.get_settings(voice_id) for default settings
- Instant Voice Cloning (IVC): client.voices.ivc.create(name, description, files=[samples])
- Dubbing v2: audio-to-audio model, 90+ languages, sync-aware translation, automatic voice cloning

## Output formats

- MP3 44100 Hz 128 kbps (default)
- Opus 48kHz (32-192 kbps) — added March 2025
- PCM for further processing

## Voice generation rules

- Script must be pre-timed before generation. Each line rendered separately for timing control.
- Voice ID and model ID logged in run registry under voice-log
- Character count tracked for cost accounting
- For VO-xx defects (pacing, quality, clipping), re-generate only the affected lines
- Dubbing v2 preserves emotion, tone, and timing from source performance
