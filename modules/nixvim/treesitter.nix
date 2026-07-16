# Nixvim: treesitter — one of several top-level contributors merging
# into `flake.modules.nixvim.default`.
{ ... }:
{
  flake.modules.nixvim.default =
    {
      plugins.treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      plugins.treesitter-context = {
        enable = true;
        settings = {
          max_lines = 4;
          min_window_height = 40;
        };
      };
      # tpope's indent fixes
      plugins.sleuth.enable = true;
    };
}
