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
  config = mkIf (cfg.enable && builtins.elem "claude-code" cfg.tools) {

    programs.claude-code = {
      enable = true;

      # skills = [
      #   (pkgs.fetchFromGitHub {
      #     owner = "anthropics";
      #     repo = "skills";
      #     rev = "main";
      #     sha256 = "sha256-0000000000000000000000000000000000000000000=";
      #   })
      # ];

      settings = {
        preferences = {
          vimMode = true;
        };

        # NOTE: stolen from: https://github.com/ViZiD/dotfiles/blob/master/modules/cli/vibecoding.nix
        extraKnownMarketplaces = {
          perplexity-mcp-server = {
            source.source = "github";
            source.repo = "perplexityai/modelcontextprotocol";
          };
          anthropic-agent-skills = {
            source.source = "github";
            source.repo = "anthropics/skills";
          };
          superpowers-marketplace = {
            source.source = "github";
            source.repo = "obra/superpowers";
          };
        };
        enabledPlugins = {
          "perplexity@perplexity-mcp-server" = true;
          "superpowers@superpowers-marketplace" = true;
          "document-skills@anthropic-agent-skills" = true;
          "web-artifacts-builder@anthropic-agent-skills" = true;
        };
        permissions = {
          disableBypassPermissionsMode = "disable";
          allow = [
            "Bash(git diff:*)"
            "WebSearch"
            "WebFetch(domain:docs.letta.com)"
          ];
          ask = [
            "Bash(git push:*)"
          ];
          deny = [
            "Read(./.env)"
            "Read(./.env.*)"
            "Read(./secrets/**)"
            "Read(./venv/**)"
            "Read(./config/credentials.json)"
            "Read(./build)"
          ];
          # defaultMode = "acceptEdits";
        };

        theme = "dark";
        includeCoAuthoredBy = true;
        enableMcpIntegration = true;
      };
    };
  };
}
