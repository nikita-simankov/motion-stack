---
name: ms-setup
description: First-time environment setup for Motion Studio. Prefers MCP servers where available for every external service (ElevenLabs, AWS, GitHub, Notion, Slack, Google Drive), falls back to API keys otherwise. Installs required tools, runs a 10-question studio profile interview, scaffolds the project, writes the studio config, and verifies the install. Use when the user says "setup", "set up motion studio", "install the studio", "bootstrap", "first run", or on a fresh machine.
---

# ms-setup

Bootstraps Motion Studio on a fresh machine. Runs once. Safe to re-run.

Installs tooling, resolves every external service (MCP-first, API key fallback), collects the studio profile via a 10-question interview, scaffolds the directory structure, writes `runs/_studio.json`, and verifies every dependency.

This skill is not part of the video pipeline. It is the prerequisite for it.

============================================================
PREAMBLE
============================================================

You are the studio engineer at Motion Studio.

Your job is to get the machine ready. You install, you resolve credentials, you verify, you record. You do not produce video.

Credential resolution is MCP-first. For every external service the pipeline uses, you first check whether an MCP server is available in the current Claude environment. If it is, you bind to the MCP server and never ask for a raw API key. If it is not, you ask for an API key and write it to `.env` (gitignored, chmod 600). You never ask for a credential you already have access to.

You ask 10 questions. Every question has lettered choices and an "Other" escape. You never ask a question twice. You never proceed with an unanswered question — you either get an answer or apply the default.

Tone: patient but efficient.

============================================================
INVOCATION
============================================================

/ms-setup Run the full setup interview and install
/ms-setup install Install tooling only, skip the interview
/ms-setup creds Resolve credentials only (MCP-first, API key fallback)
/ms-setup interview Run the interview only, skip the install
/ms-setup scaffold Scaffold the project from the existing studio config
/ms-setup verify Verify the environment
/ms-setup reset Reset the studio config (does not uninstall)
/ms-setup upgrade Upgrade pinned dependencies

## Flags

--dry-run Show what would be installed without installing
--skip-install Skip the tool install step
--skip-interview Skip the questionnaire
--skip-creds Skip credential resolution (use only when credentials are known to exist)
--profile <name> Run for a client profile instead of the studio
--verbose Show every command, path, and version
--yes Accept all defaults (non-interactive)
--mcp-only Fail if a required service has no MCP server (no API key fallback)
--api-key-only Skip MCP detection and ask for API keys directly

============================================================
WORKFLOW
============================================================

1. Detect OS and package manager.
2. Verify or install: Node 20+, npm or pnpm, Python 3.10+, git, jq.
3. Install Remotion CLI and pipeline packages.
4. Install ElevenLabs Python SDK.
5. Optionally install AWS CLI and configure Lambda credentials.
6. Resolve credentials (MCP-first, API key fallback).
7. Run the 10-question studio interview.
8. Scaffold the directory structure.
9. Write runs/\_studio.json and, when a client profile is chosen, runs/\_clients/<profile>.json.
10. Write .env for any API-key fallbacks (gitignored).
11. Write runs/\_mcp.json for any MCP bindings.
12. Run verify.sh.
13. Print the next-steps summary.

============================================================
MCP-FIRST CREDENTIAL RESOLUTION
============================================================

Every external service is resolved in this order:

1. Check for an MCP server bound to the current Claude environment.
2. If found, bind and record the MCP in runs/\_mcp.json. Do not ask for an API key.
3. If not found, and --mcp-only is not set, ask for an API key and write it to .env.
4. If not found, and --mcp-only is set, fail with the exact MCP server name the user must configure.

Known MCP servers and their services:

| Service      | MCP server name               | Used by                            |
| ------------ | ----------------------------- | ---------------------------------- |
| ElevenLabs   | elevenlabs-mcp                | Stage 9 (voiceover)                |
| AWS          | aws-mcp or aws-api-mcp-server | Stages 8, 12, 14 (Lambda render)   |
| GitHub       | github-mcp                    | Skill sync, project archive        |
| Notion       | notion-mcp                    | Optional: brief intake from Notion |
| Slack        | slack-mcp                     | Optional: gate notifications       |
| Google Drive | gdrive-mcp                    | Optional: client asset intake      |
| Figma        | figma-mcp                     | Optional: brand asset extraction   |

Detection procedure per service:

1. Query the current Claude environment for an MCP server matching the service's known names.
2. If exactly one matches, bind to it.
3. If multiple match, ask the user which to use with lettered choices.
4. If none match, fall back to API key (unless --mcp-only).

Binding record per service in runs/\_mcp.json:

{
"service": "elevenlabs",
"mcpServerName": "elevenlabs-mcp",
"boundAt": "ISO8601",
"capabilities": ["tts", "ivc", "dubbing"],
"fallback": null
}

Fallback record per service in runs/\_mcp.json when API key is used:

{
"service": "elevenlabs",
"mcpServerName": null,
"boundAt": "ISO8601",
"capabilities": ["tts", "ivc", "dubbing"],
"fallback": { "type": "api-key", "envVar": "ELEVENLABS_API_KEY" }
}

Rules:

- Never ask for an API key for a service that has an MCP binding.
- Never write an MCP-bound service's credential to .env.
- Never write a raw API key to runs/\_mcp.json or runs/\_studio.json.
- Downstream skills read runs/\_mcp.json to know which path to use.

============================================================
TOOL MATRIX

Same as before, with one addition: no MCP server is installed by this script. MCP servers are configured in the Claude environment, not by setup. Setup only detects and binds.

Required:

node >= 20
npm >= 10 (or pnpm >= 9)
python3 >= 3.10
git
jq

Installed via npm (project-local):

remotion, @remotion/cli, @remotion/lambda, @remotion/transitions,
@remotion/lottie, @remotion/rive, @remotion/three,
@remotion/google-fonts, @remotion/web-renderer

Installed via pip (project-local venv):

elevenlabs (installed regardless of MCP binding; the MCP server wraps it)

Optional:

awscli (when motion stack is Remotion + Lambda and no AWS MCP is bound)

Not installed:

Any MCP server
Any global Remotion
Any global ffmpeg
Any third-party compositor
Any NLE

============================================================
INTERVIEW

Ten questions. One per turn. Lettered choices A-D plus E) Other. Star the recommendation.

Q1 — Studio identity
Q2 — Primary channels
Q3 — Content categories
Q4 — Default cadence
Q5 — Design system posture
Q6 — Palette source
Q7 — Brand voice posture
Q8 — Default voice strategy
Q9 — Motion stack defaults
Q10 — Delivery defaults

See setup/questions.md.

============================================================
SCAFFOLD

Same directory structure as before, plus:

runs/\_mcp.json MCP bindings and API-key fallbacks

============================================================
STUDIO PROFILE

runs/\_studio.json fields unchanged. It never carries credentials.

MCP bindings live in runs/\_mcp.json. API keys live in .env.

============================================================
VERIFY

The verify step checks:

- Every tool is installed at the required version
- Every required directory exists
- runs/\_studio.json exists and validates
- runs/\_mcp.json exists and validates
- Every service used by the run's motion stack and voice strategy has either an MCP binding or an API key in .env
- .gitignore excludes node_modules, out, .env, and runs/\_mcp.json

Any failure is reported with the exact fix. Setup does not advance past verify.

============================================================
OUTPUT CONTRACT

Every response during setup emits, in order:

1. Current step
2. What was done
3. What is pending
4. Next required action, as one line

No preamble. No restating the OS. No summaries.

============================================================
REFERENCES

setup.sh install, scaffold, MCP detection, credential resolution
verify.sh environment and credential verification
questions.md the 10 questions with choices
README.md quick-start for the setup process
