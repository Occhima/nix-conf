{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    mkIf
    mkMerge
    mapAttrs
    mkOptionDefault
    mkBefore
    singleton
    ;
  cfg = config.modules.hardware.media.sound;
  mapOptionDefault = mapAttrs (_: mkOptionDefault);
in
{
  config = mkIf (cfg.enable && cfg.backend == "pipewire") (mkMerge [
    {
      # Core pipewire configuration
      services.pipewire = {
        enable = true;
        audio.enable = true;
        pulse.enable = true;
        jack.enable = true;

        alsa = {
          enable = true;
          support32Bit = pkgs.stdenv.hostPlatform.isx86;
        };

        # Enable wireplumber
        wireplumber.enable = true;
      };

      # Make sure pipewire services start properly
      systemd.user.services = {
        pipewire.wantedBy = [ "default.target" ];
        pipewire-pulse.wantedBy = [ "default.target" ];
      };

      # Realtime kit for better audio performance
      security.rtkit.enable = true;

      # Essential audio utilities
      environment.systemPackages = with pkgs; [
        alsa-utils
        pavucontrol
        pulseaudio # For pactl
      ];
    }

    # Optimized PipeWire settings
    (mkIf cfg.optimizedSettings {
      services.pipewire.extraConfig = {
        pipewire = {
          # Logging settings
          "10-logging" = {
            "context.properties"."log.level" = 3;
          };

          # Default settings
          "10-defaults" = {
            "context.properties" = mapOptionDefault {
              "clock.power-of-two-quantum" = true;
              "core.daemon" = true;
              "core.name" = "pipewire-0";
              "link.max-buffers" = 16;
              "settings.check-quantum" = true;
            };

            "context.spa-libs" = mapOptionDefault {
              "audio.convert.*" = "audioconvert/libspa-audioconvert";
              "avb.*" = "avb/libspa-avb";
              "api.alsa.*" = "alsa/libspa-alsa";
              "api.v4l2.*" = "v4l2/libspa-v4l2";
              "api.libcamera.*" = "libcamera/libspa-libcamera";
              "api.bluez5.*" = "bluez5/libspa-bluez5";
              "api.vulkan.*" = "vulkan/libspa-vulkan";
              "api.jack.*" = "jack/libspa-jack";
              "support.*" = "support/libspa-support";
              "video.convert.*" = "videoconvert/libspa-videoconvert";
            };
          };
        };

        pipewire-pulse = {
          "10-defaults" = {
            "context.spa-libs" = mapOptionDefault {
              "audio.convert.*" = "audioconvert/libspa-audioconvert";
              "support.*" = "support/libspa-support";
            };

            # "pulse.cmd" = mkBefore [
            #   {
            #     cmd = "load-module";
            #     args = "module-always-sink";
            #     flags = [ ];
            #   }
            # ];

            "pulse.rules" = mkBefore [
              {
                # Fix for apps that don't support S16 sample format
                matches = [
                  { "application.process.binary" = "teams"; }
                  { "application.process.binary" = "teams-insiders"; }
                  { "application.process.binary" = "skypeforlinux"; }
                ];
                actions.quirks = [ "force-s16-info" ];
              }
              {
                # Fix for Firefox capture streams
                matches = singleton { "application.process.binary" = "firefox"; };
                actions.quirks = [ "remove-capture-dont-move" ];
              }
            ];
          };
        };
      };
    })
  ]);
}
