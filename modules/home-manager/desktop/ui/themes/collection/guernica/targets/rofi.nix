{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  stylix.targets.rofi.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") true;

  # TODO .... setup the rofi theme, my current one sucks
  # programs.rofi.theme = lib.mkIf (cfg.enable && cfg.name == "guernica") {
  #   ...
  # };
}
