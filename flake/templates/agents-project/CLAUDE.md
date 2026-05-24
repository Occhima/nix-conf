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

### AgentMemory

Persistent cross-session memory. Assume server running at `$AGENTMEMORY_URL`.

- `memory_save` — persist findings, decisions, patterns
- `memory_recall` — retrieve prior context
- `memory_smart_search` — semantic search

## Skills

`/caveman` — ultra-compressed responses when token budget matters
`/caveman ultra` — maximum compression
