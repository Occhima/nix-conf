---
description: Inspect visible research run state, scheduled research follow-ups when available, and durable watch artifacts.
section: Project & Session
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

Inspect active research work for this project.

Requirements:

- Use the `process` tool with the `list` action only when that tool is visible and the user is asking about research-run state; otherwise record `Process state: BLOCKED - process tool not available`.
- Use scheduling tooling only when it is visible; otherwise record `Schedule state: BLOCKED - scheduling tool not available`.
- Inspect durable state in `outputs/.plans/`, `outputs/`, `experiments/`, and `notes/` for watch baselines, autoresearch logs, replication runs, and recent research artifacts.
- Summarize:
  - active research-run background processes if the process tool is visible
  - queued or recurring research watches if scheduling tooling is visible
  - durable watch/autoresearch/replication artifacts found on disk
  - failures that need attention
  - the next concrete command the user should run if they want logs or detailed status
- Be concise and operational.
