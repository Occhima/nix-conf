{
  config,
  lib,
  inputs,
  ...
}:
{
  flake.homeConfigurations.occhima = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;
      };
      overlays = builtins.attrValues inputs.self.overlays;
    };
    modules = [ config.flake.modules.homeManager.occhima ];
    extraSpecialArgs = {
      inherit inputs;
      lib = inputs.self.lib;
      self = inputs.self;
      # ponytail: empty osConfig for standalone HM — modules use `osConfig.x or default`
      osConfig = { };
    };
  };
}
