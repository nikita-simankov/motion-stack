# Failure Handling

Load on any failure, error, or halt turn.

Ambiguous brief Return to ms-brief-intake, re-run relevant questionnaire items
Missing asset Hold at ms-asset-generator, do not substitute
Unlicensed music Hold at ms-music-supervisor, do not deliver
Loudness out of spec Hold at ms-finishing-suite
Palette drift Route to ms-color-grader
Voice drift Route to current stage
Three revisions on one stage Halt, present options via questionnaire
Downstream artifact stale Block its gate until re-run
Context loss Resume from run.json, no stage replay

## Remotion render failure (RND-xx)

Route to ms-motion-designer or ms-video-editor. Check:

- CSS transitions or Tailwind animation classes present
- useCurrentFrame not used for animation
- Lambda memory insufficient (target 3009MB)
- Chunk sizes uneven (causes AAC audio artifacts)

## ElevenLabs generation failure (VO-xx)

Route to ms-voiceover-producer. Check:

- API key valid
- voice_id exists and is accessible
- Character limit not exceeded for the model
- Model availability by region

## Lambda timeout

Retry with increased memory. Reduce chunk size. Check S3 bucket permissions.

## Audio artifact at chunk join

Ensure all chunks render same frame count except last. Check AAC codec settings.
