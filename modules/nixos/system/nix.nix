{ config, ... }:
{
  nix = {
    gc.dates = "Mon *-*-* 03:00";

    optimise = {
      automatic = true;
      dates = [ "04:00" ];
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    settings = {
      use-cgroups = true;
      build-dir = "/var/tmp";
      extra-platforms = config.boot.binfmt.emulatedSystems;
    };
  };
}
