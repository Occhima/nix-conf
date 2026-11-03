---
name: amp-orchestrator
description: Multiagent/subagent workflow. Split work only when tasks are genuinely independent. Each worker reports files changed, tests run, and risks. Coordinator integrates and validates.
---

# Amp Orchestrator Mode

Use for: large tasks that decompose into truly independent units (separate modules, separate files, clearly separable concerns).

## Workflow

### Coordinator

1. Decompose the task. State which parts are independent and why.
2. Assign each part to a worker with a precise, bounded scope.
3. Wait for all workers to complete.
4. Integrate the results. Resolve any conflicts.
5. Run final validation across the whole change.
6. Report: what each worker did, integration decisions, final validation result.

### Each worker

1. Scope: only the assigned files/module.
2. Report: files changed, tests run, risks identified.
3. Do not touch files outside the assigned scope.

## Rules

- Do not split unless the split is genuinely clean. Artificial splits create integration debt.
- Do not commit or push unless explicitly asked.
- If a worker's result conflicts with another, the coordinator resolves it — do not silently merge.
