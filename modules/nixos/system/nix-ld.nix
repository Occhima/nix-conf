{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.system.nix-ld;
in
{
  options.modules.system.nix-ld = {
    enable = mkEnableOption "Enable Nix-ld support";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
    };
  };
}
