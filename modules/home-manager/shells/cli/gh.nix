{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "gh" cfg.tools) {
    programs.gh = {
      enable = true;

      extensions = [
        pkgs.gh-eco
        pkgs.gh-cal

      ];

      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        pager = "less";
      };

    };
  };
}
