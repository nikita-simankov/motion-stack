# Motion Lint

`ms-setup/audit-motion.sh` (a wrapper over `audit_motion.py`) statically checks scene source. `/ms-motion-designer audit` runs it, scene QA reads its output, and `ms-quality-assurance` cites its codes.

```
audit-motion.sh [path ...] [--tokens runs/<id>/style-tokens.json] [--json] [--strict]
```

Default path is `src/scenes`. `src/motion/` (the runtime) is excluded. Exit 0 means no errors; warnings fail only under `--strict`. `--tokens` also checks every hex literal against the frozen palette.

## Rules

| code | severity | rule |
|---|---|---|
| ANIM-01 | error | CSS `transition`, `animation`, or `@keyframes` |
| ANIM-02 | error | Tailwind `animate-`, `transition-`, `duration-`, `delay-`, `ease-` classes |
| ANIM-03 | error | `setTimeout`, `setInterval`, `requestAnimationFrame`, `Math.random`, `Date.now` |
| ANIM-04 | error | raw `Easing.*` in a scene; use `m.tween` / `m.ease` with a named curve |
| ANIM-06 | error | `interpolate()` with no `easing` (linear by default); name a curve, or mark continuous motion `// ms:linear` |
| ANIM-07 | warn | a `.map()` that animates items without using the index for timing (no stagger) |
| ANIM-09 | warn | one curve covers more than 80% of the eased motion in a file with six or more |
| ANIM-10 | error | `spring()` with an inline `config`; use `m.springOf` with a preset |
| ANIM-11 | error | `interpolate()` not clamped on both sides |
| ANIM-13 | warn | a literal `blur(Npx)`; blur must be frame-driven or come from `MotionBlur` / `CameraRig` |
| ANIM-16 | error | a hex colour not in the frozen palette (with `--tokens`) |

ANIM-01 to ANIM-05 existed before as checklist items in `scene-qa.md`; ANIM-01 to ANIM-04 are now automated. ANIM-05 (transition outside the frozen set) and ANIM-08 (text hold under the read-time rule) need the board and the rendered frames, so QA checks them with the motion proof sheet instead.

## Suppression

```ts
// ms:allow ANIM-07 reviewed: one logo, not a group
// ms:linear progress bar is continuous motion
```

A directive applies to its own line and the next. Every `ms:allow` needs a reason, and QA samples them.

## Limits

The lint is a heuristic text scan. It does not parse TypeScript, so it can miss patterns built indirectly (an easing passed through a variable) and can warn on legitimate code (ANIM-07 on a group that animates as one unit). Errors are strict because the patterns they match are unambiguous. Warnings are questions for the designer.

## Test fixtures

`ms-setup/fixtures/scene-good.tsx` must produce zero findings. `scene-bad.tsx` must produce every error code. `scene-mono.tsx` must produce ANIM-09. A change to the lint that breaks one of these fails `ms-setup verify`.
