{
  config,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.cachix;
in
{
  options.modules.services.cachix = {
    enable = mkEnableOption "cachix service";
  };

  config = mkIf cfg.enable {
    services.cachix-agent = {
      name = "home-manager-${config.home.username}";
      enable = true;
      credentialsFile = osConfig.age.secrets.cachix-key.path;
    };
  };
}
