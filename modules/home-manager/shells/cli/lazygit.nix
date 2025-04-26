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
  config = mkIf (cfg.enable && builtins.elem "lazygit" cfg.tools) {
    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme = false;
          selectedLineBgColor = [ "default" ];
        };
      };
    };
  };
}
