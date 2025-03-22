{ config, inputs, ... }:
let
  localConfig = "${config.home.homeDirectory}/.config/flake";
  configSource =
    if builtins.pathExists localConfig then localConfig else inputs.nixos-flake-config.outPath;
in
{

  config = {
    home = {
      stateVersion = "25.05";
      homeDirectory = "/home/${config.home.username}";
      preferXdgDirectories = true;

      file = {
        ".config/flake" = {
          source = configSource;
          recursive = true;
        };
      };
      sessionVariables = {
        # EDITOR = config.modules.editor;
        FLAKE = ".config/flake";
        NH_FLAKE = ".config/flake";
        # EDITOR = defaults.editor;
        # GIT_EDITOR = defaults.editor;
        # VISUAL = defaults.editor;
        # TERMINAL = defaults.terminal;
        SYSTEMD_PAGERSECURE = "true";
        # PAGER = defaults.pager;
        # MANPAGER = defaults.manpager;
        # FLAKE = osConfig.garden.environment.flakePath;
        # NH_FLAKE = osConfig.garden.environment.flakePath;
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
      };

      shell = {
        enableShellIntegration = false;
      };
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

  };

}
