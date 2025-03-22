{
  lib,
  ...
}:

with lib;

{
  options.modules.hardware.media = {
    sound = {
      enable = mkEnableOption "Audio support";

      backend = mkOption {
        type = types.enum [
          "pipewire"
          "pulseaudio"
        ];
        default = "pipewire";
        description = "Audio backend to use";
      };

      optimizedSettings = mkOption {
        type = types.bool;
        default = false;
        description = "Enable optimized settings for the audio server";
      };
    };

    video = {
      enable = mkEnableOption "Video hardware support";

      benchmarking = mkEnableOption "Benchmarking tools for video hardware";
    };
  };
}
