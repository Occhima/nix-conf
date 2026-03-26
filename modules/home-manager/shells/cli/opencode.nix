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
        share = "manual";

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

          bash = {
            "*" = "ask";
            "git diff*" = "allow";
            "git push*" = "deny";
          };

          websearch = "allow";
          webfetch = {
            "*" = "ask";
            "https://docs.letta.com*" = "allow";
          };
        };
      };
    };
  };
}
