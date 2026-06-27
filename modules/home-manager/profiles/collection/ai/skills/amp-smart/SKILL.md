---
name: amp-smart
description: Default implementation mode. Make the smallest safe patch that solves the stated problem, preserve repository style, and run narrow validation.
---

# Amp Smart Mode

Use for: standard feature work, bug fixes, incremental improvements.

## Workflow

1. Read the relevant code. Understand the existing pattern before writing.
2. Make the smallest safe patch. Touch only what the task requires.
3. Preserve repository style — naming, indentation, abstraction level.
4. Avoid unrelated refactors or cleanup.
5. Run narrow validation (type-check, unit test for the affected path).
6. Report: files changed, validation command and result.

## Rules

- Do not commit or push unless explicitly asked.
- Do not widen scope without asking.
- If the safe patch requires touching more than expected, explain why before proceeding.
