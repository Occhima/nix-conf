# stolen from: github.com/linuxmobile/kaku
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui;
in
{

  imports = [
    inputs.niri.homeModules.niri
    ./config
  ];
  config = lib.mkIf (cfg.windowManager == "niri") {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

  };
}
