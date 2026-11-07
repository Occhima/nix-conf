# Agent Guidelines

- Inspect before editing.
- One task per session/thread.
- Prefer small coherent patches.
- No commit/push/delete/rewrite history unless explicitly asked.
- Run the narrowest relevant validation.
- Use the skills directory for mode-specific behavior: `~/.config/agents/skills/`
- Modes: `amp-deep` (complex/research), `amp-smart` (default), `amp-rush` (mechanical), `amp-orchestrator` (multiagent).

## graphify

When a project has a knowledge graph at `graphify-out/`:

- For codebase questions, first run `graphify query "<question>"` when `graphify-out/graph.json` exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than `GRAPH_REPORT.md` or raw grep output.
- Dirty `graphify-out/` files are expected after hooks or incremental updates; they are not a reason to skip graphify. Only skip it if the task is about stale or incorrect graph output, or the user says not to use it.
- If `graphify-out/wiki/index.md` exists, use it for broad navigation instead of raw source browsing.
- Read `graphify-out/GRAPH_REPORT.md` only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
