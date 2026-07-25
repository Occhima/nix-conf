{ config, ... }:
let
  cliAi = config.flake.modules.homeManager.cli-ai;
in
{
  # Agent instructions/skills live in this directory; other features
  # (e.g. jcode) consume them through the fixed point instead of
  # reaching across the tree with relative paths.
  flake.lib.custom.aiAssets = {
    skills = ./skills;
    agentsMd = ./AGENTS.md;
  };

  flake.modules.homeManager.ai =
    # NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
    # MCP servers config stolen from: https://github.com/ViZiD/dotfiles/blob/master/modules/cli/vibecoding.nix
    {
      pkgs,
      lib,
      config,
      osConfig ? { },
      ...
    }:
    let
      inherit (lib) mkIf getExe getExe';
      hasAgeKeys = (osConfig.age.secrets or { }) ? openrouter-api-key;

      engram = pkgs.buildGoModule rec {
        pname = "engram";
        version = "1.19.0";

        src = pkgs.fetchFromGitHub {
          owner = "Gentleman-Programming";
          repo = "engram";
          rev = "v${version}";
          hash = "sha256-EGcxj3GVLP5080oqaNFtK1FFv5gSDDyWXX7H1Pzf5Qs=";
        };

        vendorHash = "sha256-O+pC4x4DKNUWr7Sx9iZOjK6a64wrQA4/lnjvkNLBX64=";

        subPackages = [ "cmd/engram" ];

        env.CGO_ENABLED = 0;
        ldflags = [
          "-s"
          "-w"
          "-X main.version=${version}"
        ];

        doCheck = false;

        meta = {
          description = "Persistent memory for AI coding agents via MCP";
          homepage = "https://github.com/Gentleman-Programming/engram";
          license = pkgs.lib.licenses.mit;
          mainProgram = "engram";
        };
      };
    in
    {
      imports = [ cliAi ];

      config = {
        home = {
          # TODO: add codeburn
          packages = [
            # pkgs.python313Packages.google-generativeai
            # pkgs.rtk
          ];

          sessionVariables = mkIf hasAgeKeys {
            OPENROUTER_API_KEY = "$( cat ${osConfig.age.secrets.openrouter-api-key.path} )";
          };
        };

        services.ollama.enable = false;

        programs.claude-code = {
          agentsDir = ./agents;
          skills = ./skills;
        };
        programs.opencode = {
          agents = ./agents;
          skills = ./skills;
        };

        programs.mcp = {
          enable = true;
          servers = {
            nixos = {
              command = "nix";
              args = [
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
              type = "stdio";
            };

            # devenv = {
            #   command = getExe pkgs.devenv;
            #   args = [ "mcp" ];
            #   type = "stdio";
            # };

            deepwiki = {
              type = "http";
              url = "https://mcp.deepwiki.com/mcp";
            };

            context7 = {
              type = "http";
              url = "https://mcp.context7.com/mcp";
              headers = {
                CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
              };
            };

            # time = {
            #   command = getExe pkgs.mcp-server-time;
            #   type = "stdio";
            # };

            github = {
              command = getExe pkgs.github-mcp-server;
              args = [ "stdio" ];
              type = "stdio";
              env = {
                GITHUB_PERSONAL_ACCESS_TOKEN = "{{env:GITHUB_TOKEN}}";
              };
            };

            # filesystem = {
            #   command = getExe pkgs.mcp-server-filesystem;
            #   args = [
            #     homeDir
            #     "/tmp"
            #   ];
            #   type = "stdio";
            # };

            memory = {
              command = getExe pkgs.mcp-server-memory;
              args = [ ];
              type = "stdio";
            };
            engram = {
              command = getExe engram;
              args = [ "mcp" ];
              type = "stdio";
            };

            # NOTE: Taking tooo long to build
            # playwright-mcp = {
            #   command = getExe pkgs.playwright-mcp;
            #   args = [ ];
            #   type = "stdio";
            # };

            # perplexity = {
            #   command = getExe pkgs.perplexity-mcp;
            #   args = [ ];
            #   type = "stdio";
            # };

            # sequential-thinking = {
            #   command = getExe pkgs.mcp-server-sequential-thinking;
            #   args = [ ];
            #   type = "stdio";
            # };

            paper-search = {
              command = getExe' pkgs.uv "uvx";
              args = [
                "--from"
                "paper-search-mcp"
                "python"
                "-m"
                "paper_search_mcp.server"
              ];
              type = "stdio";
              env = {
                PAPER_SEARCH_MCP_UNPAYWALL_EMAIL = config.accounts.email.accounts.usp.address;
              };
            };
          };
        };
      };
    };
}
