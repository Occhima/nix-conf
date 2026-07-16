{
  config,
  lib,
  inputs,
  ...
}:
let
  # ponytail: hardcoded host list — add new hosts here
  hosts = [
    "aerodynamic"
    "beyond"
    "crescendoll"
    "steammachine"
    "voyager"
  ];
in
{
  flake.nixosConfigurations = lib.genAttrs hosts (
    host:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ config.flake.modules.nixos.${host} ];
      specialArgs = {
        inherit inputs;
        lib = inputs.self.lib;
        self = inputs.self;
      };
    }
  );
}
