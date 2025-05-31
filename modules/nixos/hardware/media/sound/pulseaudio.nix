{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.hardware.media.sound;
in
{
  config = mkIf (cfg.enable && cfg.backend == "pulseaudio") {
    # Enable PulseAudio
    hardware.pulseaudio = {
      enable = true;
      support32Bit = pkgs.stdenv.hostPlatform.isx86;
      package = pkgs.pulseaudioFull;
    };

    # Essential audio utilities
    environment.systemPackages = with pkgs; [
      alsa-utils
      pavucontrol
    ];
  };
}
