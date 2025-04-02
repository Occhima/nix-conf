{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkDefault;
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;

  MHz = x: x * 1000;
in
{
  config = mkIf (hasProfile config [ "laptop" ]) {
    services.auto-cpufreq = {
      enable = true;

      settings = {
        battery = {
          governor = "powersave";
          energy_performance_preference = "power";
          scaling_min_freq = mkDefault (MHz 1200);
          scaling_max_freq = mkDefault (MHz 1800);
          turbo = "never";

          enable_thresholds = true;
          start_threshold = 20;
          stop_threshold = 80;
        };

        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          scaling_min_freq = mkDefault (MHz 1800);
          scaling_max_freq = mkDefault (MHz 3800);
          turbo = "auto";
        };
      };
    };
  };
}
