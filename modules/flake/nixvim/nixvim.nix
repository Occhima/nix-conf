# Nixvim flake plumbing. nixvim's flakeModule already declares the
# mergeable `flake.nixvimModules` option (lazyAttrsOf deferredModule), so
# every fragment under modules/flake/nixvim/ contributes to
# `flake.nixvimModules.default` independently; the merged module is
# evaluated into the `nvim` configuration and its packages.
{ config, inputs, ... }:
{
  imports = [ inputs.nixvim.flakeModules.default ];

  nixvim = {
    packages.enable = true;
    checks.enable = false;
  };

  perSystem =
    { system, ... }:
    {
      nixvimConfigurations = {
        nvim = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [ config.flake.nixvimModules.default ];
        };
      };
    };
}
