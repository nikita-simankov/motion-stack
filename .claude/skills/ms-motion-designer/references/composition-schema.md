# Composition Schema

Two artifacts: src/Root.tsx (the registry) and scenes.json (the manifest). scenes.md is the human render.

## src/Root.tsx pattern

import { Composition } from "remotion";
import { SceneB01 } from "./scenes/B01";
import { SceneB02 } from "./scenes/B02";

export const RemotionRoot: React.FC = () => {
return (
<>
<Composition
id="mcp-explainer-B01"
component={SceneB01}
durationInFrames={60}
fps={30}
width={1080}
height={1920}
defaultProps={{ tokens: "v1", assets: "v1" }}
/>
<Composition
id="mcp-explainer-B02"
component={SceneB02}
durationInFrames={240}
fps={30}
width={1080}
height={1920}
defaultProps={{ tokens: "v1", assets: "v1" }}
/>
</>
);
};

Rules:

- id — letters, numbers, and dash only. Matches the scene id.
- component — the scene's React component, imported from ./scenes/<boardId>/
- durationInFrames — from board.durationFrames
- fps — from brief.runtime.fps
- width, height — from the primary platform aspect
- defaultProps — JSON-serializable; every prop has a default
- calculateMetadata — only when a prop depends on runtime data

## scenes.json

{
"projectId": "string",
"builtAt": "ISO8601",
"briefVersion": "v1",
"boardsVersion": "v1",
"tokensVersion": "v1",
"assetsVersion": "v1",
"fps": 30,
"width": 1080,
"height": 1920,
"bundleSizeKb": 0,
"estimatedMasterRenderMs": 0,
"scenes": [
{
"sceneId": "S-B01",
"boardId": "B01",
"compositionId": "mcp-explainer-B01",
"width": 1080,
"height": 1920,
"fps": 30,
"durationInFrames": 60,
"filePath": "src/scenes/B01/index.tsx",
"entryPoint": "SceneB01",
"assetsUsed": ["A001", "A003"],
"tokensUsed": ["palette.background", "type.hook", "motion.medium"],
"transitionsIn": "hard-cut",
"transitionsOut": "cut-on-action",
"previewPath": "runs/<id>/previews/B01.mp4",
"previewHash": "sha256:...",
"renderMs": 0,
"renderMsLambda": 0,
"determinismCheck": "pass | fail",
"warnings": [],
"errors": []
}
],
"compositionRegistry": [
{ "id": "mcp-explainer-B01", "component": "SceneB01", "durationInFrames": 60 }
],
"blockedBoards": [
{ "boardId": "B07", "reason": "string" }
]
}

Rules:

- One scene per board. No scene covers two boards. No board splits into two scenes.
- compositionId = "<project-slug>-<boardId>"
- renderMs at --preview-scale
- renderMsLambda estimated for the master resolution
- determinismCheck must be pass for at least one scene; recommended for all
- blockedBoards must be empty for gate pass
- bundleSizeKb measured after build
- estimatedMasterRenderMs is the sum of per-scene Lambda estimates

## scenes.md template

MOTION STUDIO — SCENES
project-id: <project-id>
built-at: <ISO8601>
boards-version: <v>
tokens-version: <v>
assets-version: <v>
fps: <fps>
resolution: <w>x<h>
bundle: <kb>

REGISTRY
mcp-explainer-B01 SceneB01 60 frames
mcp-explainer-B02 SceneB02 240 frames
...

SCENES
S-B01 board B01 60 frames render 1240ms det pass A001,A003
S-B02 board B02 240 frames render 4120ms det pass A002,A005,A006
...

BLOCKED
<boardId> <reason>
...

WARNINGS
<sceneId> <warning>
...

NEXT
<approve | revise <notes>>
