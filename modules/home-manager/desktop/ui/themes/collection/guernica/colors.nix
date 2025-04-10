{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in

{
  stylix = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  };
}
