# Agent Configuration

## Shell Tools

**RTK** runs transparently — all bash commands are token-optimized via hook.
Direct use: `rtk git log`, `rtk grep`, `rtk test`, `rtk err <cmd>`, `rtk diff`

## MCP Servers

### Codegraph

Pre-indexed knowledge graph. **Consult before writing code**, not during.

| Intent                       | Tool                          |
| ---------------------------- | ----------------------------- |
| Understand area/feature      | `codegraph_context` (primary) |
| Find symbol by name          | `codegraph_search`            |
| What calls this?             | `codegraph_callers`           |
| What does this call?         | `codegraph_callees`           |
| Blast radius before refactor | `codegraph_impact`            |
| Survey source                | `codegraph_explore`           |

### Engram

Persistent cross-session memory. The MCP client starts the local stdio server.

- `mem_context` — load recent project context
- `mem_search` — retrieve prior findings and decisions
- `mem_save` — persist durable decisions, fixes, and lessons
- `mem_session_summary` — record a useful handoff before ending work

## Skills

`/caveman` — ultra-compressed responses when token budget matters
`/caveman ultra` — maximum compression
