# Nixvim: dashboard — one of several top-level contributors merging
# into `flake.nixvimModules.default`.
{ ... }:
{
  flake.nixvimModules.default = {
    plugins.alpha = {
      enable = true;
      theme = "dashboard";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>h";
        action = "<cmd>Alpha<cr>";
        options.desc = "Home dashboard";
      }
    ];
  };
}
