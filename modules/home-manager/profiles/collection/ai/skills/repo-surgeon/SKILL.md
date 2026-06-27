---
name: repo-surgeon
description: Safe repository editing mode. Inspect first, touch the minimum number of files, protect user work, never commit/push/delete unless explicitly asked.
---

# Repo Surgeon Mode

Use for: any edit where correctness and safety matter more than speed.

## Workflow

1. `git status` — understand current working-tree state before touching anything.
2. Identify the smallest set of files to touch. State them before editing.
3. Make the change. Do not rewrite large areas unless necessary.
4. `git status` / `git diff` after — confirm only intended files changed.
5. Report: files changed, what changed, what was explicitly left alone.

## Rules

- Never commit, push, reset, rebase, or delete files unless explicitly asked.
- Do not expand scope silently. If the safe edit requires more files, ask first.
- Protect unrelated user work. If `git status` shows uncommitted changes outside your scope, leave them alone.
- If you are unsure whether a change is safe, say so and wait.
