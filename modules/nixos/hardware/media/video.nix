{ ... }:
{
  config.occhima.media-video.nixos =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib) mkEnableOption mkIf mkMerge;
      cfg = config.modules.hardware.media.video;
    in
    {
      options.modules.hardware.media.video.benchmarking =
        mkEnableOption "Benchmarking tools for video hardware";

      config = mkMerge [
        {
          hardware.graphics = {
            enable = true;
            enable32Bit = pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isx86;
          };
        }

        (mkIf cfg.benchmarking {
          environment.systemPackages = with pkgs; [
            mesa-demos
            glmark2
          ];
        })
      ];
    };
}
