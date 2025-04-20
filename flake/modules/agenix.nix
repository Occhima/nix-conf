{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets) filterAttrs;
  configs = [
    "steammachine"
    "face2face"
    "aerodynamic"
  ];
  nixosConfigs = filterAttrs (name: _: builtins.elem name configs) self.nixosConfigurations;
in
{

  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem =
    { ... }:
    {
      agenix-rekey = {
        nixosConfigurations = nixosConfigs;
        collectHomeManagerConfigurations = false;
      };
    };

}
