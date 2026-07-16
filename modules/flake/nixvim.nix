# Nixvim flake plumbing: evaluates the merged `flake.modules.nixvim.default`
# aspect (contributed by the fragment files under modules/nixvim/) into the
# `nvim` configuration and its packages, and republishes it as
# `nixvimModules.default` for compatibility.
{ config, inputs, ... }:
{
  imports = [ inputs.nixvim.flakeModules.default ];

  nixvim = {
    packages.enable = true;
    checks.enable = false;
  };

  flake.nixvimModules.default = config.flake.modules.nixvim.default;

  perSystem =
    { system, ... }:
    {
      nixvimConfigurations = {
        nvim = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [ config.flake.modules.nixvim.default ];
        };
      };
    };
}
