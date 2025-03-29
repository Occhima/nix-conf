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
      homeDirectory = "/home/occhima";
      preferXdgDirectories = true;
      sessionVariables = {
        # EDITOR = config.modules.editor;
        FLAKE = config.modules.home.flakePath;
        NH_FLAKE = config.modules.home.flakePath;
        # EDITOR = defaults.editor;
        # GIT_EDITOR = defaults.editor;
        # VISUAL = defaults.editor;
        # TERMINAL = defaults.terminal;
        SYSTEMD_PAGERSECURE = "true";
        # PAGER = defaults.pager;
        # MANPAGER = defaults.manpager;
        DO_NOT_TRACK = 1;

      };
      # packages = with pkgs; [
      #   home-manager
      # ];

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
