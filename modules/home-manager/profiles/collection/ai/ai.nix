# NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
# MCP servers config stolen from: https://github.com/ViZiD/dotfiles/blob/master/modules/cli/vibecoding.nix
{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf getExe getExe';
  inherit (lib.custom) hasProfile;
  hasAgeKeys = osConfig.modules.secrets.agenix.enable or false;
  homeDir = config.home.homeDirectory;

  abTop = (
    pkgs.rustPlatform.buildRustPackage rec {
      pname = "abtop";
      version = "0.2.14";

      src = pkgs.fetchFromGitHub {
        owner = "graykode";
        repo = "abtop";
        rev = "v${version}";
        hash = "sha256-9gIBRWNek7588d/t/EV4Yv1dRoop2ZuHxZVCeSA9vIk=";
      };

      cargoLock = {
        lockFile = "${src}/Cargo.lock";
      };

      doCheck = true;

      meta = with pkgs.lib; {
        description = "";
        homepage = "https://github.com/graycode/abtop";
        license = licenses.mit;
        platforms = platforms.all;
      };
    }
  );

in

{
  config = mkIf (hasProfile config [ "ai" ]) {
    home = {

      # TODO: add codeburn
      packages = [
        pkgs.python313Packages.google-generativeai
        pkgs.rtk
        abTop

      ];

      sessionVariables = mkIf hasAgeKeys {
        OPENAI_API_KEY = "$( cat ${osConfig.age.secrets.openai-api-key.path} )";
        ANTHROPIC_API_KEY = "$( cat ${osConfig.age.secrets.aider-anthropic.path} )";
        GEMINI_API_KEY = "$( cat ${osConfig.age.secrets.gemini-api-key.path} )";
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

        devenv = {
          command = getExe pkgs.devenv;
          args = [ "mcp" ];
          type = "stdio";
        };

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

        time = {
          command = getExe pkgs.mcp-server-time;
          type = "stdio";
        };

        github = {
          command = getExe pkgs.github-mcp-server;
          args = [ "stdio" ];
          type = "stdio";
          env = {
            GITHUB_PERSONAL_ACCESS_TOKEN = "{{env:GITHUB_TOKEN}}";
          };
        };

        filesystem = {
          command = getExe pkgs.mcp-server-filesystem;
          args = [
            homeDir
            "/tmp"
          ];
          type = "stdio";
        };

        memory = {
          command = getExe pkgs.mcp-server-memory;
          args = [ ];
          type = "stdio";

        };

        playwright-mcp = {
          command = getExe pkgs.playwright-mcp;
          args = [ ];
          type = "stdio";
        };
        perplexity = {
          command = getExe pkgs.perplexity-mcp;
          args = [ ];
          type = "stdio";
        };

        sequential-thinking = {
          command = getExe pkgs.mcp-server-sequential-thinking;
          args = [ ];
          type = "stdio";
        };

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
}
