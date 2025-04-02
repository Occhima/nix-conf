{
  lib,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.modules.profiles = {
    enable = mkEnableOption "Enable profiles configurations";

    active = mkOption {
      type = types.listOf (
        types.enum [
          "desktop"
          "laptop"
          "headless"
          "graphical"
          "wsl"
        ]
      );
      default = [ ];
      description = "List of active profiles to enable";
      example = ''[ "desktop" "graphical" ]'';
    };
  };
}
