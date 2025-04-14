{
  lib,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.modules.profiles = {
    enable = mkEnableOption "Enable profiles for home-manager";

    active = mkOption {
      type = types.listOf (
        types.enum [
          "pentesting"
        ]
      );
      default = [ ];
      description = "List of active profiles to enable";
      example = ''[ "pentesting"  ]'';
    };
  };
}
