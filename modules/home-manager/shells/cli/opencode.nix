{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "opencode" cfg.tools) {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;

      settings = {
        autoupdate = false;
        provider = {
          sakana = {
            npm = "@ai-sdk/openai-compatible";
            name = "Sakana Fugu";
            options = {
              baseURL = "https://api.sakana.ai/v1";
              apiKey = "{env:SAKANA_API_KEY}";
            };
            models = {
              "fugu" = {
                name = "Fugu";
              };
              "fugu-ultra" = {
                name = "Fugu Ultra";
              };
            };
          };
        };
        share = "manual";
        # Agents are defined centrally in profiles/collection/ai/agents.nix
        # and injected via programs.opencode.settings.agent in ai.nix.
        plugin = [
          "oh-my-openagent@latest"
          "opencode-claude-auth@latest"
          "@mohak34/opencode-notifier"
          "@tarquinen/opencode-dcp"
        ];

        permission = {
          read = {
            "*" = "allow";
            "./.env" = "deny";
            "./.env.*" = "deny";
            "./secrets/**" = "deny";
            "./venv/**" = "deny";
            "./config/credentials.json" = "deny";
            "./build" = "deny";
          };
        };
      };
    };
  };
}
