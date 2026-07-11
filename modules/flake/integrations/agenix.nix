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
    "aerodynamic"
    "beyond"
  ];
  nixosConfigs = filterAttrs (name: _: builtins.elem name configs) self.nixosConfigurations;
in
{

  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = _: {
    agenix-rekey = {
      nixosConfigurations = nixosConfigs;
      collectHomeManagerConfigurations = false;
    };
  };

}
