{
  lib,
  self,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkImageMediaOverride;
  inherit (lib.sources) cleanSource;
  hostname = config.networking.hostName or "nixos";
  rev = self.shortRev or "dirty";
  name = "${hostname}-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}";
in
{
  image = {
    baseName = mkImageMediaOverride name;
    extension = "iso";
  };

  isoImage = {
    volumeID = mkImageMediaOverride name;
    squashfsCompression = "zstd -Xcompression-level 19";
    appendToMenuLabel = "";
    contents = [
      {
        source = cleanSource self;
        target = "/flake";
      }
    ];
  };
}
