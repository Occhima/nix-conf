{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.services.location;
in
{
  options.modules.services.location = {
    enable = mkEnableOption "Enable location services";

    provider = mkOption {
      type = types.enum [
        "geoclue2"
        "mozilla"
      ];
      default = "geoclue2";
      description = "Location provider to use";
    };

    timeZone = mkEnableOption "Enable automatic timezone based on location";
  };

  config = mkIf cfg.enable {
    # Location services with GeoClue2
    services.geoclue2 = mkIf (cfg.provider == "geoclue2") {
      enable = true;

      # Enable apps that can use geoclocation
      appConfig = {
        "org.gnome.Shell" = {
          isAllowed = true;
          isSystem = true;
        };

        "firefox" = {
          isAllowed = true;
          isSystem = false;
        };
      };
    };

    # Enable Mozilla Location Service
    location.provider = mkIf (cfg.provider == "mozilla") "mozilla";

    # Enable automatic timezone based on location
    services.automatic-timezoned = mkIf cfg.timeZone {
      enable = true;
    };

    # Enable redshift for automatic screen temperature based on time/location
    services.redshift = {
      enable = true;
      temperature = {
        day = 5700;
        night = 3500;
      };
    };
  };
}
