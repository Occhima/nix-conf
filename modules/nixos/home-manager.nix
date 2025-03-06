{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.modules.home-manager;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {

    # Make home-manager CLI available in system PATH
    # XXX this is dumb, home-manager should manage itself
    environment.systemPackages = with pkgs; [
      home-manager
    ];

    home-manager = {
      verbose = true;
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };
  };
}
