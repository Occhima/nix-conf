{ ... }:
{
  config.occhima.headless.nixos =
    { lib, ... }:
    let
      inherit (lib.modules) mkForce;
      inherit (lib.attrsets) mapAttrs;
    in
    {
      fonts = mapAttrs (_: mkForce) {
        packages = [ ];
        fontDir.enable = false;
        fontconfig.enable = false;
      };
    };
}
