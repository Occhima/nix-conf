# Nixvim: telescope — one of several top-level contributors merging
# into `flake.nixvimModules.default`.
{
  flake.nixvimModules.default = {
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        media-files.enable = true;
      };
    };
  };
}
