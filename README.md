# Motion Studio

Motion Studio is a production pipeline for short-form motion design videos. It takes a raw client brief and runs it through 17 gated stages (research, concepting, scripting, storyboarding, style, assets, animation, voiceover, sound, music, edit, grade, finishing, QA, distribution, scheduling) to a delivered master and a set of platform-native social cuts.

The pipeline is built on:

- **[Remotion](https://www.remotion.dev/)** for all motion design and rendering. Every scene is a React composition driven by `useCurrentFrame()`.
- **[ElevenLabs](https://elevenlabs.io/)** for voice synthesis, voice cloning, and dubbing.
- **[Claude Code](https://claude.com/claude-code)** skills that act as the specialist "crew." Each stage is a skill, and an orchestrator skill (`ms-command`) gates them in order.

> **Status:** This repository currently contains the skill definitions only (`.claude/skills/`). The Remotion project, run folders, and config are created by running `/ms-setup` on a fresh machine. See [Getting started](#getting-started).

---

## Contents

- [How it works](#how-it-works)
- [The pipeline](#the-pipeline)
- [Skills reference](#skills-reference)
- [Getting started](#getting-started)
- [Usage](#usage)
- [Repository layout](#repository-layout)
- [Run artifacts](#run-artifacts)
- [Credentials and secrets](#credentials-and-secrets)
- [Technology rules](#technology-rules)
- [Motion craft and token contract v2](#motion-craft-and-token-contract-v2)
- [Troubleshooting](#troubleshooting)

---

## How it works

A run is a sequence of **stages**. Each stage has one owning skill, takes the previous stage's artifact as input, and produces a new artifact. Every stage ends at a **gate**:

1. The artifact is presented with its pass/fail criteria and a diff against the prior revision.
2. The producer either **approves** (the next stage is dispatched immediately) or **revises** with notes (the same stage reruns).
3. Nothing advances past an unpassed gate.

Each artifact is written to disk and to the run registry, so runs can be paused, resumed, forked for A/B concepts, or rolled back to an earlier version.

Brand voice (`ms-brand-voice`) is a cross-cutting gate. It checks every artifact (script, boards, style frames, scenes, edit, grade, finishing, and distribution copy) against a frozen voice rubric and banned-term list.

## The pipeline

| # | Stage / skill | Input | Output | Gate |
|---|---|---|---|---|
| 1 | `ms-brief-intake` | Raw brief | Structured creative brief | Brief locked |
| 2 | `ms-topic-research` | Brief | Verified research dossier | Facts verified |
| 3 | `ms-concept-developer` | Dossier | 3–5 scored video concepts | Concept selected |
| 4 | `ms-script-writer` | Concept | Timed, VO-ready script | Script locked |
| 5 | `ms-storyboard-artist` | Script | Storyboard frames | Boards approved |
| 6 | `ms-styleframe-designer` | Storyboard | Style frames + style tokens | Look locked |
| 7 | `ms-asset-generator` | Style frames | Production assets + manifest | Assets complete |
| 8 | `ms-motion-designer` | Assets, script | Remotion compositions | Scenes approved |
| 9 | `ms-voiceover-producer` | Script | ElevenLabs VO audio | VO approved |
| 10 | `ms-sound-designer` | Animated scenes | SFX stem | SFX approved |
| 11 | `ms-music-supervisor` | Animated scenes | Music stem + cue sheet | Music approved |
| 12 | `ms-video-editor` | Compositions, VO, SFX, music | Master timeline | Picture lock |
| 13 | `ms-color-grader` | Edited timeline | Graded video | Grade approved |
| 14 | `ms-finishing-suite` | Graded video | Delivery masters, captions, thumbnails | Master delivered |
| 15 | `ms-quality-assurance` | Master deliverable | QA report | QA pass |
| 16 | `ms-social-distributor` | Master deliverable | Platform-native cuts + copy | Cuts approved |
| 17 | `ms-social-calendar` | Platform cuts | Posting calendar | Calendar live |

Failed QA routes defects back to the responsible stage with a defect code. Nothing is marked delivered until it matches the master spec (codec, resolution, loudness, captions, slate, and metadata).

## Skills reference

Every skill lives in `.claude/skills/<name>/` with a `SKILL.md` entry point and a `references/` folder of detailed protocols, schemas, and rubrics. Skills load only when their stage is active.

| Skill | Purpose |
|---|---|
| `ms-command` | Orchestrator. Runs stages in order, enforces gates, persists run state, and holds the master deliverable contract. |
| `ms-setup` | One-time environment setup: tooling, credentials (MCP-first, API key fallback), studio profile interview, and project scaffold. |
| `ms-brand-voice` | Voice rubric and banned-term enforcement across all stages. |
| `ms-brief-intake` through `ms-video-editor`, `ms-color-grader`, `ms-finishing-suite`, `ms-quality-assurance`, `ms-social-distributor`, `ms-social-calendar` | Stage skills, as listed in the pipeline table. |

`ms-command` has the most reference material (client profiles, presets, platform specs, QA rubric, run-state schema, failure handling, and Remotion and ElevenLabs stack notes). Start there when you want to understand a run end to end.

## Getting started

### Prerequisites

- **Node.js 20+** and **npm 10+** (or pnpm)
- **Python 3.10+**
- **git** and **jq**
- **Claude Code** with this repository open, so the skills in `.claude/skills/` are available
- An **ElevenLabs** account (via its MCP server if available, or an API key)
- Optional: **AWS** credentials, if you render with Remotion Lambda

### 1. Clone the repository

```bash
git clone https://github.com/nikita-simankov/motion-stack.git
cd motion-stack
```

### 2. Run the setup

In Claude Code, from the repository root:

```
/ms-setup
```

Setup walks through:

1. Checking or installing Node, npm, Python, git, and jq.
2. Installing Remotion (`remotion`, `@remotion/cli`, `@remotion/lambda`, and related packages) and the ElevenLabs Python SDK.
3. Resolving credentials for each external service. It uses an MCP server where one is connected and falls back to an API key written to `.env`.
4. A 10-question studio profile interview, which writes `runs/_studio.json`.
5. Scaffolding the project: `src/`, `remotion.config.ts`, `public/`, `out/`, `runs/`, and a `.gitignore`.
6. Verifying the install.

Setup is safe to re-run. Useful variants:

```
/ms-setup verify     # check the environment only
/ms-setup creds      # resolve credentials only
/ms-setup interview  # rerun the studio profile interview
/ms-setup upgrade    # upgrade pinned dependencies
```

### 3. Verify

```
/ms-setup verify
```

Every check should report `ok`. Failures list the missing tool, file, or credential.

## Usage

### Run a full production

```
/ms-command <client brief>
```

If you give no brief, `ms-command` runs the intake questionnaire first (see `.claude/skills/ms-command/references/intake.md`).

### Control a run

| Command | What it does |
|---|---|
| `/ms-command resume <project-id>` | Continue from the last passed gate |
| `/ms-command status <project-id>` | Show the render dashboard |
| `/ms-command stage <skill-name>` | Run one stage in isolation |
| `/ms-command branch <stage>` | Fork the run at a gate for A/B concepts |
| `/ms-command approve [n]` or `approve 4-7` | Pass the current gate, or a range of gates |
| `/ms-command revise <notes>` | Reject the current gate with notes |
| `/ms-command rollback <stage> <v>` | Revert a stage to a prior version |
| `/ms-command halt` | Freeze the run and flush the registry to disk |
| `/ms-command intake` | Run the intake questionnaire only |

### Flags

| Flag | Effect |
|---|---|
| `--auto` | Advance until the first rejection or flagged gate |
| `--preset <name>` | Load runtime, platform set, and tone from `references/presets.md` |
| `--client <profile>` | Load client voice, palette, and license rules |
| `--quiet` | Hide the gate table when it hasn't changed |
| `--verbose` | Show prompts, tool calls, and routing decisions |
| `--batch <file>` | Queue several briefs and run them sequentially |
| `--render-local` / `--render-lambda` | Force a local or Lambda render |
| `--stub` | Replace downstream skills with placeholder artifacts. Useful for testing the orchestrator in isolation. |

## Repository layout

```
motion-stack/
├── README.md
├── README_RU.md
├── CHANGELOG.md
├── .gitignore
└── .claude/
    └── skills/
        ├── ms-command/          # orchestrator
        │   ├── SKILL.md
        │   └── references/      # presets, intake, QA rubric, platform specs, ...
        ├── ms-setup/
        │   ├── SKILL.md
        │   ├── questions.md     # the 10-question interview
        │   ├── setup.sh         # install, credentials, scaffold
        │   ├── verify.sh        # environment checks and v2 tooling self-tests
        │   ├── migrate-tokens.sh, validate-tokens.sh, tokens-v2-defaults.json
        │   ├── audit-motion.sh, audit_motion.py
        │   └── fixtures/        # v1 token sample, lint fixtures
        ├── ms-brand-voice/
        ├── ms-brief-intake/
        ├── ms-topic-research/
        ├── ms-concept-developer/
        ├── ms-script-writer/
        ├── ms-storyboard-artist/
        ├── ms-styleframe-designer/
        ├── ms-asset-generator/
        ├── ms-motion-designer/     # + templates/motion (runtime), scripts/proof_sheet.py
        ├── ms-voiceover-producer/  # + scripts/words_from_alignment.py
        ├── ms-sound-designer/
        ├── ms-music-supervisor/    # + scripts/beat_grid.py
        ├── ms-video-editor/        # + templates/transitions, scripts/loop_check.py
        ├── ms-color-grader/
        ├── ms-finishing-suite/
        ├── ms-quality-assurance/
        ├── ms-social-distributor/
        └── ms-social-calendar/
```

After `/ms-setup` runs, the project also contains `package.json`, `remotion.config.ts`, `src/`, `public/`, `out/`, `runs/`, and `.venv/`. These are generated, so they aren't stored in this repository.

## Run artifacts

Each production writes into `runs/`:

| Path | Contents |
|---|---|
| `runs/_studio.json` | Studio profile from the setup interview |
| `runs/_clients/` | Client profiles (voice, palette, license rules) |
| `runs/_sfx/` | Sound effect library, sorted by category |
| `runs/_luts/` | Color LUTs |
| `runs/_mcp.json` | Resolved MCP connections (**gitignored**) |
| `runs/<id>/<stage>/v<n>.md` | Versioned stage artifacts |
| `runs/<id>/audio/raw/`, `audio/archive/` | Generated audio (large; gitignored) |
| `runs/<id>/previews/`, `deliverables/`, `distribution/` | Renders and outputs (gitignored) |

## Credentials and secrets

- Credentials are resolved **MCP-first**. If a service's MCP server is connected, Motion Studio uses it and never asks for a raw key.
- Otherwise, the API key is written to `.env` with `chmod 600`. **Never commit `.env`.** It's listed in `.gitignore`.
- `runs/_mcp.json` holds resolved connection details and is also gitignored.
- To require MCP servers and disable the API key fallback entirely, run setup with `--mcp-only`. Setup then fails if a required service has no MCP server.

## Technology rules

These rules are fixed for every stage. The orchestrator enforces them at the gates.

- **Video:** Remotion only. Compositions are React components registered with `<Composition>` and an explicit `width`, `height`, `fps`, and `durationInFrames`. Animation is driven by `useCurrentFrame()`. CSS transitions, CSS animations, and Tailwind animation classes are not allowed. Render with `npx remotion render` or `@remotion/lambda`.
- **Voice:** ElevenLabs only. Models: `eleven_multilingual_v2` (highest stability, 29 languages), `eleven_flash_v2_5` (low latency, 32 languages), `eleven_turbo_v2_5` (balanced, 32 languages). Cloning uses Instant Voice Cloning. Dubbing uses Dubbing v2.

Details live in `.claude/skills/ms-command/references/remotion-stack.md` and `elevenlabs-stack.md`.

## Motion craft and token contract v2

v2 raises the craft of the output, not just its compliance. v1 enforced that motion was frame-driven and token-bound; it did not say what good motion looks like. v2 adds that, as tokens a linter and the QA rubric can check.

| Area | What v2 adds | Where |
|---|---|---|
| Motion | A named curve library (expo, quint, quart and friends), five curve roles chosen by tone, spring presets with a measured settle time and overshoot budget, and choreography rules: stagger, overlap, exit ratio, read hold | `ms-styleframe-designer/references/motion-curves.md` |
| Kinetic type | Six presets (mask line, word rise, word lock-up, weight swell, outline fill, number roll), variable-font axes, a two-family limit | `kinetic-type.md` |
| Captions | Word-level `word-highlight` and `word-pop` styles driven by ElevenLabs character timestamps converted to integer frames | `ms-finishing-suite/references/caption-pipeline.md` |
| Camera and depth | A virtual camera, parallax layers, depth blur, a cursor-following smart zoom for product demos, token-driven motion blur | `ms-motion-designer/references/camera-rig.md` |
| Looks and layout | Six look bundles mapped to intake Q7, a grid and focal-point system, mesh gradients, glass, halftone, paper, light leaks | `looks.md` |
| Platform fit | Per-platform UI safe-zone insets for vertical video | `ms-command/references/platform-specs.md` |
| Rhythm | A beat grid with cut snapping, audio-reactive visuals, a seamless-loop rule | `ms-music-supervisor/references/beat-grid.md`, `ms-video-editor/references/seamless-loop.md` |
| QA | Three new high-weight rubric criteria (motion craft, hierarchy and composition, distinctiveness; the score is now out of 75) and new defect codes (ANIM-06 to ANIM-16, TYP, CMP, CAP, STY-05, CUT-15 to CUT-17) | `ms-quality-assurance/references/review-rubric.md` |

### Tooling

| Tool | Purpose |
|---|---|
| `ms-setup/migrate-tokens.sh` | Migrate a v1 `style-tokens.json` to v2 |
| `ms-setup/validate-tokens.sh` | Check a v2 token file: curves, springs and overshoot, choreography ranges, tone rules, fonts, captions, layout |
| `ms-setup/audit-motion.sh` | Motion lint over scene source (ANIM-01 to ANIM-16) |
| `ms-motion-designer/scripts/proof_sheet.py` | Contact sheet and motion-energy plot; flags dead holds |
| `ms-video-editor/scripts/loop_check.py` | Seam check for seamless loops |
| `ms-voiceover-producer/scripts/words_from_alignment.py` | Character alignment to word frame timings |
| `ms-music-supervisor/scripts/beat_grid.py` | Beat grid and cut snapping (needs the optional `librosa`) |
| `ms-motion-designer/templates/motion/`, `ms-video-editor/templates/transitions/` | The motion runtime and transitions that `/ms-setup scaffold` copies into `src/` |

`/ms-setup verify` self-tests every tool above.

### Upgrading an existing project

1. `/ms-setup upgrade`, then `/ms-setup scaffold`. This moves Remotion to 4.0.534 and React to 19, and writes `src/motion/` and `src/transitions/`. **React 19 is required:** `@remotion/transitions` 4.0.534 fails to bundle on React 18.3.1.
2. `/ms-command migrate <project-id> [--tone <tone>]`. This writes a v2 token file next to the frozen v1 file and re-opens gate 6 with the diff. v1 values are never changed. Nothing is frozen until you approve.
3. Scenes already built on v1 tokens stay valid. v1 easing names (`ease-out`, `ease-in`, `ease-in-out`) resolve through aliases.

Full procedure: `ms-styleframe-designer/references/token-migration-v1-to-v2.md`. Breaking changes are in `CHANGELOG.md`.

### What has and has not been verified

Verified in a scratch project: every runtime template typechecks against Remotion 4.0.534 and renders in Chromium, with identical frames across repeated renders; the whip, shape-wipe and iris transitions render; the migration, validator, lint, proof sheet, loop checker, word-timing converter and beat grid pass their self-tests (the validator against 19 negative cases). Not verified: a full 17-stage run (it needs a live ElevenLabs connection and Claude sessions per stage), the `with-timestamps` call against the live API, and the platform safe-zone figures, which come from third-party measurements. The look bundles, pacing ranges and choreography defaults are starting calibrations; `trend-benchmarks.md` has a log for replacing them with measured values.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `/ms-command` says a skill is missing | Confirm Claude Code was opened in this repository root, so `.claude/skills/` loads. |
| `verify` fails on `src/Root.tsx` or `remotion.config.ts` | Run `/ms-setup scaffold`. |
| ElevenLabs not resolved | Connect its MCP server, or run `/ms-setup creds --api-key-only`. |
| A stage keeps failing brand-voice checks | Read the banned-term hits in `ms-brand-voice/references/banned-terms.md` and revise with notes. |
| Lost run state | `/ms-command status <project-id>`. Runs are persisted to `runs/<id>/`. |
| Bundling fails with `__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE ... was not found in 'react'` | The project is on React 18. Run `/ms-setup upgrade` (React 19 is required by `@remotion/transitions` 4.0.534). |
| `verify` warns that a token file is tokenVersion 1 | It is read-compatible. Run `/ms-command migrate <project-id>` to author the v2 sections. |
| `audit-motion.sh` reports ANIM-06 on a progress bar | Continuous motion is allowed: mark it `// ms:linear`. |
| Beat-grid snapping is unavailable | `librosa` is optional and failed to install. Keep `rhythm.beatGrid.required: false`, or install it in `.venv`. |

---

## License

No license has been specified yet for this repository.
