# Voiceover Timing

Every VO line is pre-timed for ElevenLabs line-by-line generation. The voice stage reads script.json and generates each line against its frame budget. It does not re-time.

## Words per minute

Default target: 155 wpm. Range: 120-180.

Per tone:

Authoritative and plain 140-150
Punchy and native 160-170
Measured and substantive 130-140
Kinetic and minimal copy 170-180 (rarely VO-heavy)

Select the target from brief.tone and record it in script.json.wpm.

## Per-line fields

Every VO line carries:

- text — verbatim, as spoken
- frameStart, frameEnd — integers
- durationFrames = frameEnd - frameStart
- wordCount — integer
- targetWPM — from script.wpm
- estimatedSeconds = wordCount / (targetWPM / 60)

## Rules

- estimatedSeconds _ fps must be <= durationFrames _ 1.10. Over 10% overrun, the line is rewritten.
- estimatedSeconds _ fps must be >= durationFrames _ 0.60. Under 60% fill, extend the line or retime the beat.
- Silence between lines is explicit. Record as a beat with no VO text.
- Never split a sentence across beats unless the split is a deliberate dramatic pause.
- Never end a line on a preposition, article, or conjunction.
- Never begin a line with "And" or "But" unless the tone is punchy and native.
- Numbers are written as spoken: "ninety percent", "four point two billion", "twenty twenty-four".
- Acronyms are written as spoken on first use: "M-C-P", not "MCP", unless the on-screen text renders the acronym and the VO says the words.
- Units are written as spoken: "milliseconds", not "ms".
- Currency is written as spoken: "forty dollars a month", not "$40/mo".

## Expansion

When a line falls under 60% fill, expand using one of:

- Add a concrete example
- Add a number
- Add a comparison
- Add a consequence

Do not expand by:

- Restating the line
- Adding filler ("basically", "essentially", "in other words")
- Adding a hedge ("arguably", "somewhat", "fairly")

## Contraction

When a line overruns by 10-30%, contract using one of:

- Cut adverbs
- Cut hedges
- Replace passive with active
- Replace a clause with a phrase

Do not contract by:

- Dropping a claim
- Merging two sentences into a run-on
- Removing the subject

When a line overruns by more than 30%, the beat is the problem, not the line. Retime the beat.

## Silence

Silence is a first-class element. Use it to:

- Land the hook before the body begins (5-10 frames)
- Punctuate a proof before the CTA (10-20 frames)
- Let the CTA breathe after the last word (10-15 frames)

Silence is recorded as a beat with an empty vo.text and a nonzero frame range. Never leave an untimed gap.

## Timing table

Emitted on every script revision:

Line Frames Duration Words WPM Est. sec Budget sec Fill
L1 0-45 45 11 155 4.3 1.5 OVER
L2 60-210 150 38 155 14.7 5.0 OVER
...

Any line with Fill > 110% is rewritten. Any line with Fill < 60% is extended or the beat is retimed.
