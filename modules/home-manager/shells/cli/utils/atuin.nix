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
  # Atuin is enabled when requested in tools list
  config = mkIf (cfg.enable && builtins.elem "atuin" cfg.tools) {
    programs.atuin = {
      enable = true;

      flags = [
        "--disable-up-arrow"
      ];

      settings = {
        show_preview = true;
        inline_height = 30;
        style = "compact";
        update_check = false;
        sync_frequency = "5m";
      };
    };
  };
}
