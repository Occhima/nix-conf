{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.hardware.media.video;
in
{
  # Options are now defined in options.nix

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = pkgs.stdenv.hostPlatform.isx86;
      };
    }

    (mkIf cfg.benchmarking {
      environment.systemPackages = with pkgs; [
        mesa-demos
        glmark2
      ];
    })
  ]);
}
