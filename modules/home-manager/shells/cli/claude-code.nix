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

      settings = {
        theme = "dark";
        includeCoAuthoredBy = true;
      };
    };

    programs.git.ignores = [ ".claude/" ];
  };
}
