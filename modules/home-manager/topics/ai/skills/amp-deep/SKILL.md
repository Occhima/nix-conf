---
name: amp-deep
description: Use this for complex debugging, design review, deep refactors, or research-heavy coding work. The agent must inspect the repository first, plan before editing, make one coherent patch, and validate changes.
---

# Amp Deep Mode

Use for: complex debugging, design review, deep refactors, research-heavy implementation.

## Workflow

1. **Inspect first.** Read the relevant files, trace the call path, understand the invariants before touching anything.
2. **Identify the root cause or design target.** State it explicitly before editing.
3. **Make one coherent patch.** All related changes in one pass. No partial fixes.
4. **Subagents only when the split is genuinely clean.** Separate modules, separate concerns. No artificial splits.
5. **Run focused validation.** The narrowest check that catches a regression.
6. **Report:** files changed, validation run, residual risks, recommended next step.

## Rules

- No exploratory edits. Know what you're changing before you change it.
- No refactors beyond the stated goal.
- If the root cause is unclear, say so and ask rather than guessing.
