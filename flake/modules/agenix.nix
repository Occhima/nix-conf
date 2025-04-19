{
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib.attrsets) filterAttrs hasAttrByPath attrByPath;
  nixosConfigs = filterAttrs (
    _: sys:
    hasAttrByPath [ "config" "age" "rekey" "masterIdentities" ] sys
    && attrByPath [ "config" "age" "rekey" "masterIdentities" ] [ ] sys != [ ]
  ) self.nixosConfigurations;
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
