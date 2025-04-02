{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkForce;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "headless" ]) {
    fonts = mapAttrs (_: mkForce) {
      packages = [ ];
      fontDir.enable = false;
      fontconfig.enable = false;
    };
  };
}
