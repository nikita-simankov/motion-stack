# QA Report Template

qa.md render template. Emitted at every QA review.

MOTION STUDIO — QA REPORT
project-id: <project-id>
reviewed-at: <ISO8601>
reviewed-by: <name>
brief-version: <v>
dossier-version: <v>
concept-version: <v>
script-version: <v>
boards-version: <v>
tokens-version: <v>
assets-version: <v>
scenes-version: <v>
vo-version: <v>
sfx-version: <v>
music-version: <v>
timeline-version: <v>
grade-version: <v>
master-version: <v>

HASH CHAIN
timeline source: sha256:... pass
grade source: sha256:... pass
vo stem: sha256:... pass
sfx stem: sha256:... pass
music stem: sha256:... pass
master: sha256:... pass
package: sha256:... pass
chain: pass | fail

SCORE
criterion score weight pass note
hookStrength 4 high yes
pacingAndRetention 4 high yes
brandVoiceFidelity 5 high yes
visualCoherence 4 high yes
audioMixAndLoudness 5 high yes
uiMockupFidelity 4 high yes
remotionRenderIntegrity 5 high yes
elevenLabsVoiceQuality 4 high yes
captionAccuracyAndSync 5 medium yes
platformNativeness 4 medium yes
accessibility 4 medium yes
metadataAndSlate 5 low yes

---

raw: 53 / 60
floor passed: true
strict mode: false

DEFECTS
id code severity artifact frame route status
D001 GRD-03 blocker masters/9x16/master.mp4 420 ms-color-grader open
D002 FIN-12 major deliverables/metadata.json - ms-finishing-suite open
D003 ACC-06 major deliverables/thumbnails/... - ms-finishing-suite open

LEGAL
passed: true | false
codes: <list>
notes: <string>

BRAND
passed: true | false
codes: <list>
notes: <string>

ACCESSIBILITY
passed: true | false
codes: <list>
notes: <string>

REGRESSION
triggered: <true|false>
against stage: <stage | none>
prior score: <n>
current score: <n>
resolved: <list>
introduced: <list>
notes: <string>

ESCALATION
triggered: <true|false>
reason: <string | null>
options: <list | none>

GATE
passed: <true|false>
passed at: <ISO8601 | null>
next stage: <ms-social-distributor | halt>

ROUTING (when failed)
rollback target: <earliest gate>
stale: <list of downstream artifacts>
re-run order: <stage list>

NEXT
<approve | reject | escalate>
