{ localFlake, ... }:
{ ... }:
let
  inherit (localFlake.inputs) nixpkgs nur;
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        overlays = [ nur.overlays.default ];
        config = {
          allowUnfree = true;
        };
      };
    };

}
