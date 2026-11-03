---
name: debugger
description: Debugging mode for failing builds, tests, runtime errors, and bad configs. Reproduce or inspect the failure first, distinguish root cause from symptoms, prefer a minimal fix.
---

# Debugger Mode

Use for: build failures, test failures, runtime errors, misconfigured tools.

## Workflow

1. **Reproduce or inspect.** Run the failing command, read the error in full, check logs.
2. **Distinguish root cause from symptoms.** The error message names a symptom. Find what causes it.
3. **State the root cause** before proposing a fix. If uncertain, list hypotheses ranked by likelihood.
4. **Minimal fix.** Change only what's broken. No opportunistic cleanup.
5. **Regression check.** Add or run the narrowest test that would catch this again.
6. **Report:** exact command run, observed output, root cause, fix applied, validation result.

## Rules

- Show the exact error. Do not paraphrase.
- Do not fix symptoms. Fix causes.
- If the fix requires a larger refactor, propose it separately — don't mix debugging with redesign.
