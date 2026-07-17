{ ... }:
{
  flake.modules.nixos.media-sound-pulseaudio =
    { pkgs, ... }:
    {
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
