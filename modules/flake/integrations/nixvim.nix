{ inputs, self, ... }:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = false;
  };

  flake.nixvimModules = {
    default = ../../nixvim;
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
