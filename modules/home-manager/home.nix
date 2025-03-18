{ config, ... }:
{

  config = {
    home = {
      stateVersion = "25.05";
      homeDirectory = "/home/${config.home.username}";
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
      shellAliases = { };
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

  };

}
