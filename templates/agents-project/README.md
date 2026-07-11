# Agents Project Template

Coding agent workspace with RTK, Codegraph, AgentMemory, and Caveman.
Works with Claude Code and OpenCode.

## Structure

```
.
├── CLAUDE.md              # Agent instructions (harness-agnostic)
├── .mcp.json              # Claude Code project MCP servers
├── opencode.json          # OpenCode project config
├── .claude/settings.json  # Claude Code permissions
├── flake.nix
└── nix/
    ├── shell.nix          # Dev shell: codegraph sync + rtk init on enter
    └── modules/
        ├── fmt.nix
        └── pre-commit.nix
```

## Prerequisites

In PATH via NixOS/home-manager or `nix develop`:

- `rtk` — token-optimized CLI proxy
- `codegraph` — code knowledge graph
- `agentmemory` — persistent agent memory (daemon at `$AGENTMEMORY_URL`)

## Getting Started

```bash
nix develop   # enters shell, runs: codegraph sync && rtk init -g
```

## Harness Config

| File                    | Claude Code         | OpenCode                  |
| ----------------------- | ------------------- | ------------------------- |
| `.mcp.json`             | project MCP servers | —                         |
| `opencode.json`         | —                   | project MCP + permissions |
| `.claude/settings.json` | permissions         | —                         |
| `CLAUDE.md`             | agent instructions  | agent instructions        |

## Env Vars

```bash
AGENTMEMORY_URL=http://localhost:3111   # agentmemory daemon address
AGENTMEMORY_SECRET=<secret>             # agentmemory auth token
```
