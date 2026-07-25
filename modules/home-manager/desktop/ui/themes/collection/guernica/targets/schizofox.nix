# Guernica styling for schizofox. Explicit integration module: importing
# Requires `themes-guernica` in the same composition (homeManager.desktop provides it).
# `browser-firefox` alone no longer activates any theme configuration.
{ ... }: {
  flake.modules.homeManager.themes-guernica-firefox =
    { config, ... }:
    let
      inherit (config.lib.stylix) colors;
    in
    {
      programs.schizofox = {
        extensions.simplefox.enable = true;
        theme = {
          colors = {
            background-darker = colors.base01;
            background = colors.base00;
            foreground = colors.base05;
          };
          font = config.stylix.fonts.monospace.name;
        };
      };
    };
}
