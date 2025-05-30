{
  config,
  lib,
  ...
}:
{
  options.modules.home = {
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = ".config/flake";
      description = "Path to the flake configuration";
    };
  };

  config = {

    home = {
      stateVersion = "25.05";
      homeDirectory = "/home/${config.home.username}";
      preferXdgDirectories = true;
      sessionVariables = {
        FLAKE = config.modules.home.flakePath;
        NH_FLAKE = config.modules.home.flakePath;
        SYSTEMD_PAGERSECURE = "true";
        DO_NOT_TRACK = 1;
      };

      keyboard = {
        layout = "us,br";
        variant = "intl,abnt2";
        options = [
          "grp:alt_shift_toggle"
        ];
      };

      shellAliases = {
        mkdir = "mkdir -pv";
        df = "df -h";
        reboot = "systemctl reboot";
        sysctl = "sudo systemctl";
        jctl = "journalctl -p 3 -xb";
        errors = "journalctl -p err -b";
      };

      shell = {
        enableShellIntegration = true;
      };

    };

    # FIXME: Don't know why, home-manager not available in path
    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

  };

}
