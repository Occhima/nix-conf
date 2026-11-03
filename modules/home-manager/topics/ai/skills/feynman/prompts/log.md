---
description: Write a durable session log with completed work, findings, open questions, and next steps.
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

Write a session log for the current research work.

Requirements:

- Summarize what was done in this session.
- Capture the strongest findings or decisions.
- List open questions, unresolved risks, and concrete next steps.
- Reference any important artifacts written to `notes/`, `outputs/`, `experiments/`, or `papers/`.
- If any external claims matter, include direct source URLs.
- Save the log to `notes/` as markdown with a date-oriented filename.
