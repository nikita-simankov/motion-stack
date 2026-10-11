# Motion Studio — Setup Questions

The setup interview. Ten questions, one per turn. Every question has lettered choices A–D plus E) Other. The starred choice is the default. Answers are accepted as a bare letter, a letter with notes, or `default`.

Credentials are resolved separately, MCP-first, with API-key fallback.

---

## Q1 — Studio identity

What is the studio's name?

| Choice | Value                                |
| ------ | ------------------------------------ |
| A\*    | Motion Studio                        |
| B      | Personal studio                      |
| C      | I'll type it                         |
| D      | Use a placeholder, I'll rename later |
| E      | Other                                |

**Default:** A

---

## Q2 — Primary channels

Where does the studio publish? Multi-select.

| Choice | Value           |
| ------ | --------------- |
| A\*    | LinkedIn        |
| B\*    | Instagram Reels |
| C\*    | TikTok          |
| D\*    | YouTube Shorts  |
| E      | X               |
| F      | Other           |

**Default:** A, B, C, D
**Answer format:** `A,C,D` or `default`

---

## Q3 — Content categories

What does the studio primarily produce? Multi-select.

| Choice | Value              |
| ------ | ------------------ |
| A\*    | Explainers         |
| B\*    | Product demos      |
| C\*    | Thought leadership |
| D      | Tutorials          |
| E      | Testimonials       |
| F      | Mixed              |

**Default:** A, B, C
**Answer format:** `A,B,C` or `default`

---

## Q4 — Default posting cadence

Per platform.

| Choice | Value          |
| ------ | -------------- |
| A\*    | 1 per week     |
| B      | 2–3 per week   |
| C      | Daily          |
| D      | Campaign-based |
| E      | Other          |

**Default:** A

---

## Q5 — Design system posture

How should the studio handle the design system?

| Choice | Value                        |
| ------ | ---------------------------- |
| A\*    | Create from scratch now      |
| B      | Use studio default           |
| C      | Import from a client profile |
| D      | Define per-project           |
| E      | Other                        |

**Default:** A

---

## Q6 — Brand palette source

Where does the palette come from?

| Choice | Value                     |
| ------ | ------------------------- |
| A\*    | Provide hexes now         |
| B      | Extract from brand assets |
| C      | Use studio default        |
| D      | Define per-project        |
| E      | Other                     |

**Default:** A

---

## Q7 — Brand voice posture

How should the studio handle brand voice?

| Choice | Value                        |
| ------ | ---------------------------- |
| A\*    | Create from scratch now      |
| B      | Use studio default           |
| C      | Import from a client profile |
| D      | Define per-project           |
| E      | Other                        |

**Default:** A

---

## Q8 — Default voice strategy

How is voiceover produced by default?

| Choice | Value                                           |
| ------ | ----------------------------------------------- |
| A\*    | Professional VO (ElevenLabs Multilingual v2)    |
| B      | Founder or client voice (Instant Voice Cloning) |
| C      | Text-on-screen only                             |
| D      | AI voice disclosed (ElevenLabs Turbo v2.5)      |
| E      | Other                                           |

**Default:** A

---

## Q9 — Motion stack defaults

Which Remotion stack is the default?

| Choice | Value                                  |
| ------ | -------------------------------------- |
| A\*    | Remotion standard (local render)       |
| B      | Remotion + Lambda (distributed render) |
| C      | Remotion + Three.js (3D content)       |
| D      | Remotion + Lottie/Rive (vector motion) |
| E      | Other                                  |

**Default:** A

---

## Q10 — Delivery defaults

What does the studio deliver by default?

| Choice | Value                             |
| ------ | --------------------------------- |
| A\*    | 1 master + platform-native cuts   |
| B      | 1 master only                     |
| C      | 1 master + cuts + 3 short teasers |
| D      | Full campaign set                 |
| E      | Other                             |

**Default:** A

---

## Derived prompts

Asked after Q10, only when their trigger condition is met.

| Prompt              | Type                       | Trigger                     | Default                |
| ------------------- | -------------------------- | --------------------------- | ---------------------- |
| Timezone            | free text                  | always                      | system timezone        |
| Primary market      | free text                  | always                      | United States          |
| Palette hexes       | free text, comma-separated | Q6 = A                      | none                   |
| ElevenLabs voice_id | free text                  | Q8 = A                      | blank → studio default |
| AWS region          | free text                  | Q9 = B and no AWS MCP bound | us-east-1              |
| Lambda role ARN     | free text                  | Q9 = B and no AWS MCP bound | blank → set later      |

---

## Credential resolution

Resolved separately from the interview. MCP-first, API-key fallback. Never asks for a credential when an MCP server is already bound.

### Required services

| Service    | MCP server names checked        | Fallback env var                                           | Required when |
| ---------- | ------------------------------- | ---------------------------------------------------------- | ------------- |
| ElevenLabs | `elevenlabs-mcp`                | `ELEVENLABS_API_KEY`                                       | always        |
| AWS        | `aws-mcp`, `aws-api-mcp-server` | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` | Q9 = B        |

### Optional services

Prompted only on `--creds-only --service <name>`.

| Service      | MCP server names checked         | Fallback env var     |
| ------------ | -------------------------------- | -------------------- |
| GitHub       | `github-mcp`, `github`           | `GITHUB_TOKEN`       |
| Notion       | `notion-mcp`                     | `NOTION_TOKEN`       |
| Slack        | `slack-mcp`                      | `SLACK_BOT_TOKEN`    |
| Google Drive | `gdrive-mcp`, `google-drive-mcp` | `GDRIVE_CREDENTIALS` |
| Figma        | `figma-mcp`, `figma`             | `FIGMA_TOKEN`        |

### Resolution order per service

1. Check the Claude environment for a matching MCP server.
2. If exactly one matches, bind it, record in `runs/_mcp.json`, skip the API-key prompt.
3. If multiple match, present them with lettered choices.
4. If none match and `--mcp-only` is not set, prompt for the API key and write it to `.env`.
5. If none match and `--mcp-only` is set, fail with the exact MCP server name the user must configure.

---

## Answer format

| Form              | Example                             |
| ----------------- | ----------------------------------- |
| Bare letter       | `A`                                 |
| Letter with notes | `A - use studio name "Acme Motion"` |
| Default           | `default`                           |
| Multi-select      | `A,C,D`                             |
| Other             | `E` followed by the custom value    |

---

## Output artifacts

| Artifact         | Path                        | Contents                                                |
| ---------------- | --------------------------- | ------------------------------------------------------- |
| Studio profile   | `runs/_studio.json`         | answers to Q1–Q10, timezone, market, version, createdAt |
| Client profile   | `runs/_clients/<name>.json` | same shape, inherits from studio, overrides per client  |
| MCP bindings     | `runs/_mcp.json`            | one entry per service with binding or fallback          |
| Secrets          | `.env`                      | API-key fallbacks only, gitignored, chmod 600           |
| Secrets template | `.env.example`              | placeholders, committed                                 |

---

## Idempotency

Re-running the interview rewrites the profile from the new answers. Re-running credential resolution skips any service with an existing MCP binding or a populated `.env` value. Nothing is re-asked unless the answer is missing.
