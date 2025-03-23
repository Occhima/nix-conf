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

      # HACK: This creates a symlink, and i don't want that, this may be kinda dumb
      # file = {
      #   ".config/flake" = {
      #     source = ../../.;
      #     recursive = true;
      #   };
      # };
      # activation = {
      #   cloneFlakeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      #     set -e
      #     FLAKE_PATH="$HOME/${config.modules.home.flakePath}"

      #     if [ ! -d "$FLAKE_PATH" ]; then
      #       echo "Populating $FLAKE_PATH from pinned GitHub snapshot..."
      #        mkdir -p $FLAKE_PATH
      #       git clone https://github.com/Occhima/nix-conf $FLAKE_PATH
      #       echo "Done!"
      #     else
      #       echo "$FLAKE_PATH already exists; skipping copy."
      #     fi
      #   '';
      # };
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
