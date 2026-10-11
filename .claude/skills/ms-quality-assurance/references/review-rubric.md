# Review Rubric

Scoring rubric with anchors and pass thresholds.

## Criteria and weights

Hook strength (first 2s) high
Pacing and retention curve high
Brand voice fidelity high
Visual coherence with style tokens high
Audio mix and loudness high
UI mockup fidelity and realism high (when Q8 is C or D)
Remotion render integrity high
ElevenLabs voice quality and pacing high (when VO is present)
Caption accuracy and sync medium
Platform nativeness medium
Accessibility (contrast, captions, alt) medium
Metadata and slate completeness low

## Floors

Standard mode:

- High criteria require >= 4
- Medium criteria require >= 3
- Low criteria require >= 3

Strict mode (--strict):

- Every criterion requires >= 4

## Anchors

### Hook strength (first 2s)

5 — Would stop the scroll on its own. Specific, surprising, earned.
4 — Strong hook, specific, low risk of feeling generic.
3 — Clear hook, but a competitor could have written it.
2 — Vague or slow. Audience would keep scrolling.
1 — No hook present, or the hook is the thesis restated.
0 — Actively repels the target audience.

### Pacing and retention curve

5 — Every beat earns the next. No padding. No rush.
4 — Clean pacing with minor room to tighten.
3 — Pacing works but one beat drags or feels rushed.
2 — Pacing fights the content. Viewer would drop.
1 — Structure broken. Beats out of order or missing.
0 — Unwatchable.

### Brand voice fidelity

5 — Voice is native to the brand. Zero drift.
4 — Voice aligned, minor wording could be tighter.
3 — Voice recognizable but generic in places.
2 — Voice drifts from the brand in more than one line.
1 — Voice contradicts the brand.
0 — Voice is a different brand.

### Visual coherence with style tokens

5 — Every frame uses only frozen tokens. No drift.
4 — One minor drift, not visible without scopes.
3 — Two or three minor drifts.
2 — A visible drift from the palette or type.
1 — Multiple visible drifts.
0 — Look does not match the frozen tokens.

### Audio mix and loudness

5 — On target. No masking. Ducking clean.
4 — On target with a minor mix preference.
3 — Within tolerance but one element sits slightly forward or back.
2 — Out of tolerance in loudness or masking.
1 — Mix fights the VO or clips.
0 — Unlistenable.

### UI mockup fidelity and realism

5 — Every state frame-accurate. Cursor, focus, states all correct.
4 — One minor timing deviation in a state change.
3 — Fidelity acceptable but one state feels approximate.
2 — A state change is visibly off.
1 — Multiple states wrong or missing.
0 — Mockups unusable.
N/A — When Q8 is A or B, this criterion is scored 5 by default and marked N/A.

### Remotion render integrity

5 — Deterministic. No artifacts. No dropped frames.
4 — Deterministic with a minor perf concern.
3 — Deterministic but slower than budgeted.
2 — Non-deterministic in one scene.
1 — Visible artifacts or dropped frames.
0 — Render fails.

### ElevenLabs voice quality and pacing

5 — Consistent timbre across the run. Every line on budget.
4 — One minor pacing deviation.
3 — Two or three minor pacing deviations or a slight timbre shift.
2 — Noticeable timbre drift or an overrun line.
1 — Multiple overruns or audible artifacts.
0 — Voice unusable.
N/A — When Q9 is C, this criterion is scored 5 by default and marked N/A.

### Caption accuracy and sync

5 — Verbatim. In sync. Within safe area. No obstruction.
4 — One caption slightly off in position.
3 — Two or three minor sync or position issues.
2 — A caption out of sync by more than 1 frame.
1 — Missing captions or wrong text.
0 — Captions unusable.

### Platform nativeness

5 — Every platform cut is native. Aspect, length, hook, and copy adapted.
4 — Every cut native, one platform's copy could be tighter.
3 — Every cut native but two or three copies are generic.
2 — One platform cut is a resized master.
1 — Multiple platform cuts are resized.
0 — Distribution would fail on one or more platforms.

### Accessibility (contrast, captions, alt)

5 — All minimums passed. Captions accurate. No color-only signaling.
4 — All minimums passed with one minor note.
3 — One accessibility minimum marginal.
2 — One minimum failed.
1 — Multiple minimums failed.
0 — Inaccessible to a significant portion of the audience.

### Metadata and slate completeness

5 — Every field populated. Slate present. Cue sheet linked.
4 — One field could be tighter. Slate present.
3 — Two or three minor metadata gaps.
2 — A required attribution or disclosure is missing.
1 — Multiple required fields missing.
0 — Metadata unusable.

## Raw score and floor

- Raw score = sum of criterion scores (max 60)
- Floor pass = every criterion at or above its weight floor
- Strict pass = every criterion >= 4

Both the raw score and the floor pass are reported. Only the floor pass gates.

## Reporting

Emit the score table per criterion: score, weight, pass/fail, note. Emit the raw score. Emit the floor result.

## Rejected scoring patterns

- Score inflated to pass a weak master
- Score deflated to fail a strong one
- Skipping a criterion
- Scoring without reading the artifact
- Scoring on source alone, not the master
