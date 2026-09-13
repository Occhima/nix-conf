{
  flake.modules.homeManager.codex =
    { ... }:
    {
      programs.codex = {
        enable = true;
        enableMcpIntegration = true;

        settings = {
          model_provider = "openai";
          model_reasoning_effort = "high";
          model_reasoning_summary = "concise";

          approval_policy = "on-request";
          sandbox_mode = "workspace-write";
          sandbox_workspace_write = {
            network_access = true;
          };

          # No vscode/cursor/windsurf installed; this is an Emacs/terminal setup.
          file_opener = "none";
          hide_agent_reasoning = false;

          history.persistence = "save-all";

          tui = {
            vim_mode_default = true;
            notifications = true;
          };
        };

        # Alternate configs selected with `codex --profile <name>`.
        profiles = {
          # Unattended runs (scripts, CI-style loops): never prompt.
          auto = {
            approval_policy = "never";
            sandbox_mode = "workspace-write";
          };
          # Read-only exploration: no writes, no surprises.
          strict = {
            approval_policy = "on-request";
            sandbox_mode = "read-only";
          };
        };

        rules.safety = ''
          prefix_rule(
            pattern = ["rm", "-rf"],
            decision = "prompt",
            justification = "Confirm destructive recursive delete",
          )
          prefix_rule(
            pattern = ["git", "push", "--force"],
            decision = "prompt",
            justification = "Confirm force push",
          )
          prefix_rule(
            pattern = ["git", "reset", "--hard"],
            decision = "prompt",
            justification = "Confirm hard reset discards uncommitted work",
          )
        '';
      };
    };
}
