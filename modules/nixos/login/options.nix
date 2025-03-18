{
  lib,
  ...
}:

let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.modules.login = {
    enable = mkEnableOption "Enable login manager configuration";

    manager = mkOption {
      type = types.enum [
        "greetd"
        "sddm"
        "gdm"
        "lightdm"
        "slim"
        "none"
      ];
      default = "none";
      description = "The login manager to use";
    };

    autoLogin = mkEnableOption "Enable automatic login (best with FDE)";
  };
}
