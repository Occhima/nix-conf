{
  flake.modules.nixos.media-video =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86;
      };
    };
}
