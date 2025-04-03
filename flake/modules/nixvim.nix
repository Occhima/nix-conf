{ inputs, self, ... }:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  flake.nixvimModules = {
    default = self + /modules/home-manager/editor/neovim/config;
  };

  perSystem =
    { system, ... }:
    {
      nixvimConfigurations = {
        nvim = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [
            self.nixvimModules.default
          ];
          extraSpecialArgs = {
            inherit self;
          };
        };
      };
    };
}
