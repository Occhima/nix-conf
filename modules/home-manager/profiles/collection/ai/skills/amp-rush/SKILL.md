---
name: amp-rush
description: Fast mechanical mode for tiny, well-defined edits. No refactors, no abstractions, no cleanup. Return a short summary and validation command.
---

# Amp Rush Mode

Use for: rename, typo fix, single-line change, obvious mechanical edit.

## Rules

- Tiny edits only. One file preferred, two max.
- No refactors. No abstractions. No broad cleanup.
- Do not explain why. Do it and report.
- Return: what changed (one line), validation command (one line).

## Output format

```
Changed: <file>:<line> — <what>
Validate: <command>
```
