# Agents Project Template

Coding agent workspace with RTK, Codegraph, Engram, and Caveman.
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

These commands must be available in `PATH`. The default Home Manager AI/CLI
profiles provide them; otherwise add them to the template's dev shell:

- `rtk` — token-optimized CLI proxy
- `codegraph` — code knowledge graph
- `engram` — local persistent agent memory and stdio MCP server

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

## Engram

The MCP client starts `engram mcp` on demand. No separate daemon, port, or
secret is required for the local setup. Engram stores its database under
`~/.engram/` by default.
