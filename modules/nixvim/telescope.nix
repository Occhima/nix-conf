# Nixvim: telescope — one of several top-level contributors merging
# into `flake.modules.nixvim.default`.
{ ... }:
{
  flake.modules.nixvim.default =
    {
      plugins.telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          media-files.enable = true;
        };
      };
    };
}
