{ localFlake, lib, ... }:
{ ... }:
# with builtins;
# with lib;
let
  inherit (localFlake) inputs;
  inherit (lib.custom) collectNixModulePaths;
  allModules = collectNixModulePaths ../modules/nixos;

  # TODO: link with nixosModules outputs....
  # flattenModules = x: concatLists (map (v: if isAttrs v then flatten v else [ v ]) (attrValues x));
  # allModules = flattenModules nixos;

in

{

  flake.nixosConfigurations = {
    wsl = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./wsl ] ++ allModules;
      specialArgs = {
        inherit
          inputs
          lib
          ;
      };
    };
  };

}
