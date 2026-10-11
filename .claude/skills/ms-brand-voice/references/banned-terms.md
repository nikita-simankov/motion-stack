# Banned Terms

Banned term list and detection rules.

## The rule

A banned term anywhere in any artifact fails the stage. Hard fail. No override. No waiver.

## Detection scope

Banned terms are checked in:

- VO text (script.json)
- On-screen text (script.json, boards.json, scenes)
- Captions (SRT, VTT, burned)
- Metadata (title, description, tags, hashtags)
- Thumbnail text (designed and auto-extracted with overlay)
- CTAs
- Slate text
- Any text in the distribution pack

## Default banned list

### Legal risk

- guaranteed
- risk-free
- 100%
- cures
- prevents
- eliminates
- riskless
- assured
- promised

### Unsupported superlatives

- the only
- the best
- the first
- the fastest
- the largest
- the smallest
- world-class
- best-in-class
- unrivaled
- unbeatable

Exception: a superlative is allowed if the artifact cites a source that supports it. The source must be in the dossier with used = true and confidence in {high, medium}.

### Overclaims

- revolutionary
- disruptive (unless the brief is a market analysis)
- game-changing
- unprecedented
- breakthrough
- paradigm-shifting
- next-generation
- future-proof

### Corporate filler

- synergy
- circle back
- low-hanging fruit
- move the needle
- boil the ocean
- touch base
- deep dive (as a verb)
- reach out (when "contact" would do)
- take it offline

### Platform-policy risk

- follow-for-follow
- like-for-like
- comment YES
- DM me
- link in bio (when the platform bans off-platform links)
- any term the platform's policy bans

## Case and stem matching

- Case-insensitive
- Stemmed (so "guarantee", "guaranteed", "guarantees" all match)
- Word-boundary matching (so "assuredly" matches "assured", but "unassured" matches only if the rubric includes it)
- Multi-word phrases matched literally

## Contextual exceptions

- "the only" allowed if the artifact cites a source that supports exclusivity
- "the best" allowed if the artifact cites a source that supports the ranking
- "the first" allowed if the artifact cites a source that supports precedence
- "disruptive" allowed if the brief is a market analysis and the term is descriptive
- Any exception must be recorded in the rubric under whitelist

## Recording

Every banned term check records: term, artifact, frame or path, context, pass/fail.

## Consequence

- BRD-05 or BRD-10 is a blocker.
- The pipeline halts.
- The stage that owns the artifact fixes it.
- Re-run of the voice check follows.
- Re-run of the gate follows.

## Rejected patterns

- Waiving a banned term for aesthetic reasons
- Waiving a banned term because the platform is more lenient
- Waiving a banned term because the client asked (legal risk terms and unsupported superlatives are non-negotiable)
- Shipping a banned term in metadata even if the video is clean
- Shipping a banned term in a hashtag

## Legal note

Banned terms in the legal-risk and unsupported-superlative categories are a compliance issue, not a style issue. The brand voice skill flags them, but the fix is owned by the stage that produced the artifact, and any waiver requires a written client sign-off recorded in run.json.approvals.
