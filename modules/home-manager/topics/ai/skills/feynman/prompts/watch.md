---
description: Create a research watch baseline with an optional scheduled follow-up when scheduling tools are visible.
args: <topic>
section: Research Workflows
topLevelCli: true
---

## Tool Discipline (Read First)

Tool names are literal. Use only tools visible in the current tool set.

- Search with `web_search`; do not call `search_web`, `google_search`, `google:search`, `search_google`, or `WebSearch`.
- Fetch URLs with `fetch_content`; do not call bare `fetch`, `WebFetch`, `read_url_content`, or pass an array as `url`. Use `urls` for multiple URLs when the tool supports it.
- Use visible Feynman alpha tools such as `alpha_search` when present. For shell access, call `feynman alpha ...`; do not call the user's bare global `alpha` binary.
- To ask the user a question, write plain chat text and wait for the next user message. Do not call `ask_user_question`, `ask_user`, `ask_followup_question`, or `user_choice`.
- Do not use `Task` as an agent dispatcher. Use only the visible `subagent` tool when it exists.
- If a tool returns `Tool not found` or `Invalid URL`, do not retry the same invalid call. Map to a canonical visible tool and valid arguments, or record the capability as blocked.

Create a research watch baseline for: $@

Derive a short slug from the watch topic (lowercase, hyphens, no filler words, ≤5 words). Use this slug for all files in this run.

Requirements:

- Before starting, outline the watch plan: what to monitor, what signals matter, what counts as a meaningful change, and the requested or sensible check frequency. Write the plan to `outputs/.plans/<slug>.md`. Briefly summarize the plan to the user and continue immediately. Do not ask for confirmation or wait for a proceed response unless the user explicitly requested plan review.
- Start with a baseline sweep of the topic.
- Use `schedule_prompt` to create the recurring or delayed follow-up only when that tool is visible in the current tool set.
- If `schedule_prompt` is not visible, do not claim a recurring watch was scheduled. Record `Scheduling: BLOCKED - schedule_prompt not available` in the plan and baseline artifact, then give the exact command or prompt the user can run later to refresh the watch.
- Save exactly one baseline artifact to `outputs/<slug>-baseline.md`.
- End with a `Sources` section containing direct URLs for every source used.
