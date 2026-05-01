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
      enableMcpIntegration = true;

      settings = {
        preferences = {
          vimMode = true;
        };

        # NOTE: stolen from: https://github.com/ViZiD/dotfiles/blob/master/modules/cli/vibecoding.nix
        extraKnownMarketplaces = {
          "thedotmack/claude-mem" = {
            source = {
              source = "github";
              repo = "thedotmack/claude-mem";
            };
          };
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
          autoresearch = {
            source = {
              source = "github";
              repo = "uditgoenka/autoresearch";
            };
          };
          caveman = {
            source = {
              source = "github";
              repo = "JuliusBrussee/caveman";
            };
          };
          "everything-claude-code" = {
            source = {
              source = "github";
              repo = " affaan-m/everything-claude-code";
            };
          };
          "forrestchang/andrej-karpathy-skills" = {
            source = {
              source = "github";
              repo = "forrestchang/andrej-karpathy-skills";
            };
          };

        };
        enabledPlugins = {
          #"perplexity@perplexity-mcp-server" = true;
          "superpowers@superpowers-marketplace" = true;
          # "document-skills@anthropic-agent-skills" = true;
          "everything-claude-code@everything-claude-code" = true;
          # "web-artifacts-builder@anthropic-agent-skills" = true;
          # "nyldn@claude-octopus" = true;
          # "nyldn@claude-octopus" = true;
          "autoresearch@autoresearch" = true;
          "caveman@caveman" = true;
          "feature-dev@claude-plugins-official" = true;
          "claude-md-management@claude-plugins-official" = true;
          "claude-code-setup@claude-plugins-official" = true;
          "andrej-karpathy-skills@karpathy-skills" = true;
        };
        permissions = {
          disableBypassPermissionsMode = "disable";
          allow = [
            "Bash(git diff:*)"
            "WebSearch"
            "WebFetch(domain:docs.letta.com)"
            # Web
            "WebSearch"
            "WebFetch(domain:raw.githubusercontent.com)"
            "WebFetch(domain:github.com)"
            "WebFetch(domain:discourse.nixos.org)"
            "WebFetch(domain:hackage.haskell.org)"
            "WebFetch(domain:flake.parts)"
            "WebFetch(domain:pyproject-nix.github.io)"
            "WebFetch(domain:inside.java)"
            "WebFetch(domain:wiki.openjdk.org)"
            "WebFetch(domain:bugs.openjdk.org)"
            "WebFetch(domain:gvolpe.com)"
            "WebFetch(domain:greenfield.blog)"
            "WebFetch(domain:thurs.dev)"
            "WebFetch(domain:firefox-source-docs.mozilla.org)"
            "WebFetch(domain:searchfox.org)"
            "WebFetch(domain:cat-in-136.github.io)"
            "WebFetch(domain:intoli.com)"
            "WebFetch(domain:bugzilla.mozilla.org)"

            # Read-only system inspection
            "Bash(ls:*)"
            "Bash(find:*)"
            "Bash(grep:*)"
            "Bash(wc:*)"
            "Bash(sort:*)"
            "Bash(echo:*)"
            "Bash(ps:*)"
            "Bash(top:*)"
            "Bash(ss:*)"
            "Bash(mount:*)"
            "Bash(lsusb:*)"
            "Bash(dmesg:*)"
            "Bash(command:*)"
            "Bash(journalctl:*)"
            "Bash(systemctl status:*)"
            "Bash(systemctl list-timers:*)"
            "Bash(systemctl --user list-timers:*)"
            "Bash(crontab:*)"
            "Bash(sudo crontab:*)"
            "Bash(docker ps:*)"
            "Bash(docker stats:*)"
            "Bash(virsh list:*)"
            "Bash(sudo virsh:*)"

            # Dev tools
            "Bash(gh api:*)"
            "Bash(curl:*)"
            "Bash(python3:*)"
            "Bash(emacs:*)"
            "Bash(nix develop:*)"
            "Bash(nix-prefetch-git:*)"
            "Bash(nix-prefetch-url:*)"

          ];
          ask = [
            "Bash(git push:*)"
            "Bash(rm*)"
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

      };
    };
  };
}
