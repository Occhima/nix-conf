{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  # Maybe I'll want nvim to manage its colorscheme and opacity itself
  stylix.targets.nixvim.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;
}
