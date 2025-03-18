{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.security.polkit;
in
{
  options.modules.security.polkit = {
    enable = mkEnableOption "Enable and configure polkit";
  };

  config = mkIf cfg.enable {
    # Enable the polkit authentication agent
    security.polkit = {
      enable = true;

      # Allow users in wheel group to execute commands without password
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    # Install the authentication agent for desktop environments
    environment.systemPackages = with pkgs; [
      polkit_gnome # GNOME polkit agent
      libsForQt5.polkit-kde-agent # KDE polkit agent
    ];

    # Auto-start the polkit agent
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
