nixpkgs:
let
  lib = nixpkgs.lib;
  extension = {
    dirModules = import ./modules.nix {inherit lib;};
    custom = import ./custom.nix { inherit lib ; };
  };

  mkLib = pkgs:
    pkgs.lib.extend
    (_: _: extension );
  customLib = (mkLib nixpkgs);
in
  customLib
