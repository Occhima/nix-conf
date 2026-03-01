{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.shell.cli;
  cfgClaude = config.modules.shell.cli.claudeCode;
in
{
  options.modules.shell.cli.claudeCode = {
    enable = mkEnableOption "Claude Code CLI";

    model = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Default Claude model to use.
        Examples: "claude-opus-4-6", "claude-sonnet-4-6", "claude-haiku-4-5-20251001".
        If null, uses Claude Code's built-in default.
      '';
      example = "claude-sonnet-4-6";
    };

    theme = mkOption {
      type = types.enum [
        "dark"
        "light"
        "light-daltonism"
        "dark-daltonism"
      ];
      default = "dark";
      description = "Visual theme for the Claude Code interface.";
    };

    includeCoAuthoredBy = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to include Co-Authored-By in git commits made by Claude Code.";
    };

    permissions = {
      defaultMode = mkOption {
        type = types.enum [
          "default"
          "acceptEdits"
          "bypassPermissions"
          "plan"
        ];
        default = "default";
        description = ''
          Default permission mode for tool usage.
          - default: Ask before potentially destructive actions
          - acceptEdits: Auto-accept file edits, ask for commands
          - bypassPermissions: Skip all permission checks (use with caution)
          - plan: Read-only planning mode
        '';
      };

      allow = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of tool patterns to always allow without asking.";
        example = [
          "Bash(git *)"
          "Read"
          "Edit"
        ];
      };

      deny = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of tool patterns to always deny.";
        example = [ "Bash(rm -rf *)" ];
      };

      additionalDirectories = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Additional directories Claude Code is allowed to access beyond the project root.";
        example = [ "/home/user/shared-notes" ];
      };
    };

    mcpServers = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = ''
        Model Context Protocol (MCP) server configurations.
        Each entry is an attrset with type, command, args, and env fields.
      '';
      example = {
        filesystem = {
          type = "stdio";
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-filesystem"
            "/home/user/projects"
          ];
        };
      };
    };

    memory = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Inline content for the global CLAUDE.md memory file.
        This is injected into every Claude Code session as context.
      '';
      example = ''
        # Global Memory

        - Always use conventional commits
        - Prefer functional programming patterns
        - Write tests for all new code
      '';
    };

    hooks = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Shell scripts to run at hook points.
        Keys are hook names (e.g., "PreToolUse", "PostToolUse").
      '';
      example = {
        PostToolUse = "echo 'Tool used: $TOOL_NAME'";
      };
    };
  };

  config = mkIf (cfg.enable && cfgClaude.enable) {
    programs.claude-code = {
      enable = true;

      settings =
        {
          theme = cfgClaude.theme;
          includeCoAuthoredBy = cfgClaude.includeCoAuthoredBy;

          permissions = {
            defaultMode = cfgClaude.permissions.defaultMode;
            allow = cfgClaude.permissions.allow;
            deny = cfgClaude.permissions.deny;
            additionalDirectories = cfgClaude.permissions.additionalDirectories;
          };
        }
        // (lib.optionalAttrs (cfgClaude.model != null) {
          model = cfgClaude.model;
        })
        // (lib.optionalAttrs (cfgClaude.mcpServers != { }) {
          mcpServers = cfgClaude.mcpServers;
        });
    } // (lib.optionalAttrs (cfgClaude.memory != null) {
      memory.text = cfgClaude.memory;
    }) // (lib.optionalAttrs (cfgClaude.hooks != { }) {
      hooks = cfgClaude.hooks;
    });

    programs.git.ignores = [
      ".claude/"
      "CLAUDE.md"
      ".claudeignore"
    ];
  };
}
