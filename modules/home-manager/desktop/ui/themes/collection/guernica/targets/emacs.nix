{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  stylix.targets.emacs.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;
}
