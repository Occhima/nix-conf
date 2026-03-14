# NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
# MCP servers config stolen from: https://github.com/ViZiD/dotfiles/blob/master/modules/cli/vibecoding.nix
{
  pkgs,
  lib,
  config,
  self,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
  hasAgeKeys = osConfig.modules.secrets.agenix.enable or false;
  homeDir = config.home.homeDirectory;
  npx = "${pkgs.nodejs}/bin/npx";
  agentsDir = ./agents;
in

{
  config = mkIf (hasProfile config [ "ai" ]) {
    home = {
      packages = [
        pkgs.python313Packages.google-generativeai
        pkgs.crush
      ];

      sessionVariables = mkIf hasAgeKeys {
        OPENAI_API_KEY = "$( cat ${osConfig.age.secrets.openai-api-key.path} )";
        ANTHROPIC_API_KEY = "$( cat ${osConfig.age.secrets.aider-anthropic.path} )";
        GEMINI_API_KEY = "$( cat ${osConfig.age.secrets.gemini-api-key.path} )";
      };
    };

    services.ollama.enable = false;

    programs.claude-code.agentsDir = ./agents;
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

        deepwiki = {
          type = "http";
          url = "https://mcp.deepwiki.com/mcp";
        };

        time = {
          command = "${pkgs.uv}/bin/uvx";
          args = [ "mcp-server-time" ];
          type = "stdio";
        };

        github = {
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
          args = [ "stdio" ];
          type = "stdio";
          env = {
            GITHUB_PERSONAL_ACCESS_TOKEN = "{{env:GITHUB_TOKEN}}";
          };
        };

        filesystem = {
          command = npx;
          args = [
            "-y"
            "@modelcontextprotocol/server-filesystem"
            homeDir
            "/tmp"
          ];
          type = "stdio";
        };

        fetch = {
          command = npx;
          args = [
            "-y"
            "@anthropics/mcp-fetch"
          ];
          type = "stdio";
        };

        memory = {
          command = npx;
          args = [
            "-y"
            "@modelcontextprotocol/server-memory"
          ];
          type = "stdio";
        };

        sequential-thinking = {
          command = npx;
          args = [
            "-y"
            "@modelcontextprotocol/server-sequential-thinking"
          ];
          type = "stdio";
        };
      };
    };
  };
}
