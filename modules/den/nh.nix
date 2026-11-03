{ den, lib, ... }:
let
  hosts = lib.concatMap lib.attrValues (lib.attrValues den.hosts);
  unsupported = map (h: h.name) (lib.filter (h: h.class != "nixos" && h.class != "darwin") hosts);
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages = removeAttrs (den.lib.nh.denPackages { fromFlake = true; } pkgs) unsupported;
    };
}
