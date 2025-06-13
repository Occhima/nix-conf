{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  stylix.targets.vscode.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") true;
}
