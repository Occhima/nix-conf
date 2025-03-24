{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "gh" cfg.tools) {
    programs.gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        pager = "less";
      };

    };
  };
}
