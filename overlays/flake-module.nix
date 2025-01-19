{ localFlake, ... }:
{ ... }:
let
  inherit (localFlake) inputs;
  inherit (inputs) nixpkgs;
  overlays = import ./. { inherit inputs; };
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
        };
      };
    };

}
