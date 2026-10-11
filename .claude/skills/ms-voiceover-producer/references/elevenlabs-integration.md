# ElevenLabs Integration

API setup, endpoint calls, auth, retries, rate limits.

## Authentication

- API key stored in the environment as ELEVENLABS_API_KEY
- The key is never written to disk, never logged, never echoed
- On 401 or 403, halt and request a valid key

## SDK

Python:
pip install elevenlabs
from elevenlabs.client import ElevenLabs
client = ElevenLabs(api_key=os.environ["ELEVENLABS_API_KEY"])

Node:
npm install @elevenlabs/elevenlabs-js
import { ElevenLabsClient } from "@elevenlabs/elevenlabs-js"

Use the official SDK. Do not hand-roll HTTP calls unless the SDK is unavailable.

## Endpoints used

Text to speech:
client.text_to_speech.convert(
text=line_text,
voice_id=voice_id,
model_id=model_id,
voice_settings={
"stability": stability,
"similarity_boost": similarity_boost,
"style": style,
"use_speaker_boost": use_speaker_boost
},
output_format=output_format
)

Streaming (only for very long lines; not used in line-by-line mode):
client.text_to_speech.stream(...)

Voice list:
client.voices.search()

Voice settings:
client.voices.get_settings(voice_id)

Instant Voice Cloning:
client.voices.ivc.create(
name=voice_name,
description=description,
files=[sample1, sample2, sample3]
)

Dubbing v2:
client.dubbing.dub(
source_url_or_file=source_audio,
target_lang=lang_code,
...
)

## Output formats

- mp3_44100_128 — default, small files, high compatibility
- mp3_44100_192 — higher bitrate MP3
- pcm_44100 — uncompressed 16-bit PCM, for further processing
- pcm_48000 — uncompressed 16-bit PCM at 48kHz
- opus_48000_128 — added March 2025, efficient for long VO

For this pipeline: generate MP3 for preview, generate PCM 48kHz for processing, master the stem as WAV 48kHz 24-bit.

## Model IDs

- eleven_multilingual_v2
- eleven_flash_v2_5
- eleven_turbo_v2_5

Model ID is passed exactly as the string. Case-sensitive.

## Rate limits

- The API enforces per-minute and per-day character limits by tier.
- On 429, back off exponentially: 1s, 2s, 4s, 8s, up to 60s.
- On repeated 429s, halt and report the limit hit.
- Batch generation is not allowed. Generate one line at a time.

## Retries

- 5xx responses: retry up to 3 times with exponential backoff.
- 4xx responses other than 429: do not retry. Halt and report.
- Timeout: retry once. If it times out again, halt.

## Character accounting

- Every call records the number of characters sent.
- Character count is tracked per line, per stage, per run.
- The cost estimate is computed from the current pricing tier (recorded in the client profile when known).

## Determinism

ElevenLabs output is not bit-identical across calls with the same parameters. Some variance is expected. To minimize drift:

- Freeze the model_id, voice_id, and voice_settings for the run
- Do not change stability or similarity mid-run
- Regenerate a line with the same parameters and accept the best fit by duration and QA

If a line fails QA after 3 regenerations with the same parameters, escalate to stage 4 rather than continuing.

## Environment

- Python 3.10+
- elevenlabs SDK 1.x
- ffmpeg managed by Remotion; do not install globally
- No proxy, no VPN, direct HTTPS to the ElevenLabs API

## Logging

- Every call logs: lineId, modelId, voiceId, characters, duration, status
- Do not log the API key
- Do not log the full text of the line beyond the first 40 characters (avoid PII leaks)

## Failure modes

- "Invalid API key" — halt, request a valid key
- "Model not available" — halt, check the model_id
- "Voice not found" — halt, verify the voice_id
- "Quota exceeded" — halt, report and request a plan change
- "Character limit exceeded for model" — split the line at a natural boundary (sentence), regenerate each, concatenate
- "Dubbing job failed" — retry once, then halt
- "Consent not recorded" — halt for clone voices; consent is required before generation
