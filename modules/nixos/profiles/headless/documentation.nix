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
    documentation = mapAttrs (_: mkForce) {
      enable = false;
      dev.enable = false;
      doc.enable = false;
      info.enable = false;
      nixos.enable = false;
      man = {
        enable = false;
        generateCaches = false;
        man-db.enable = false;
        mandoc.enable = false;
      };
    };
  };
}
