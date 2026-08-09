{
  flake.modules.homeManager.niri =
    {
      config,
      lib,
      osConfig ? { },
      ...
    }:
    let
      inherit (builtins) concatStringsSep;
      monitors = osConfig.modules.hardware.monitors or { };
      primary = monitors.primaryMonitorName or "";
      displays = monitors.displays or { };
      primaryOutput = displays.${primary}.output or "";
    in
    {
      programs.niri.settings = {
        input = {
          focus-follows-mouse.enable = true;
          workspace-auto-back-and-forth = true;
          keyboard = {
            repeat-delay = 250;
            repeat-rate = 50;
            xkb = {
              layout = config.home.keyboard.layout;
              variant = config.home.keyboard.variant;
              options = concatStringsSep "," config.home.keyboard.options;
            };
          };

          mouse = {
            enable = true;
            accel-speed = -0.5;
            natural-scroll = false;
          };

          touchpad.natural-scroll = false;
        };
      };

      programs.niri.settings.input.tablet = lib.mkIf (primaryOutput != "") {
        # Hyprland's tablet transform = 1 is a 90-degree clockwise rotation.
        calibration-matrix = [
          [
            0.0
            (-1.0)
            1.0
          ]
          [
            1.0
            0.0
            0.0
          ]
        ];
        map-to-output = primaryOutput;
      };
    };
}
