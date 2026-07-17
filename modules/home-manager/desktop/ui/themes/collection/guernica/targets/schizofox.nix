# Guernica styling for schizofox. Contributed to the browser-firefox
# aspect (the sole importer of the schizofox module) so the options only
# exist when that browser is actually composed.
{ ... }:
{
  flake.modules.homeManager.browser-firefox =
    {
      config,
      ...
    }:
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
