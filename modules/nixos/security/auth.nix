{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkDefault;
  inherit (lib.types) str;

  cfg = config.modules.security.auth;
in
{
  options.modules.security.auth = {
    passwordless = mkEnableOption "Allow members of wheel group to execute commands without password";

    extraSudoConfig = mkOption {
      type = str;
      default = "";
      description = "Additional sudo configuration";
    };
  };

  config = {
    security = {
      # Sudo configuration
      sudo = {
        enable = true;
        execWheelOnly = true;
        wheelNeedsPassword = !cfg.passwordless;

        extraConfig = ''
          Defaults lecture = never
          Defaults pwfeedback
          Defaults env_keep += "EDITOR PATH DISPLAY"
          Defaults timestamp_timeout = 300
          ${cfg.extraSudoConfig}
        '';

        extraRules = [
          {
            groups = [ "wheel" ];
            commands =
              let
                currentSystem = "/run/current-system/";
                storePath = "/nix/store/";
              in
              [
                {
                  command = "${storePath}/*/bin/switch-to-configuration";
                  options = [
                    "SETENV"
                    "NOPASSWD"
                  ];
                }
                {
                  command = "${currentSystem}/sw/bin/nix-store";
                  options = [
                    "SETENV"
                    "NOPASSWD"
                  ];
                }
                {
                  command = "${currentSystem}/sw/bin/nix-env";
                  options = [
                    "SETENV"
                    "NOPASSWD"
                  ];
                }
                {
                  command = "${currentSystem}/sw/bin/nixos-rebuild";
                  options = [ "NOPASSWD" ];
                }
                {
                  command = "${currentSystem}/sw/bin/nix-collect-garbage";
                  options = [
                    "SETENV"
                    "NOPASSWD"
                  ];
                }
                {
                  command = "${currentSystem}/sw/bin/systemctl";
                  options = [ "NOPASSWD" ];
                }
              ];
          }
        ];
      };

      sudo-rs.enable = false;

      # PAM configuration
      pam.loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      # Polkit configuration
      polkit = {
        enable = mkDefault true;
        debug = true;
      };
    };

    # Add polkit agents to system packages
    environment.systemPackages = with pkgs; [
      polkit_gnome
      libsForQt5.polkit-kde-agent
    ];

    # Auto-start polkit agent
    systemd.user.services.polkit-agent = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
