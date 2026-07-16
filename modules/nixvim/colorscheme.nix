# Nixvim: colorscheme — one of several top-level contributors merging
# into `flake.modules.nixvim.default`.
{ ... }:
{
  flake.modules.nixvim.default =
    {
      colorschemes.monokai-pro = {
        enable = true;
        settings = {
          devicons = true;
          filter = "classic";
          background_clear = [ "telescope" ];
          transparent_background = true;
        };
      };
    };
}
