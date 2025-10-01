{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    concatStringsSep
    mkIf
    mkDefault
    ;

  cfg = config.modules.services.oom;
  systemdEnabled = config.modules.services.systemd.enable;

  # another idea stolen from https://github.com/isabelroses/dotfiles/blob/60b78b2eff0eb86b0c8306b12927e419055d48b3/modules/nixos/system/earlyoom.nix#L53
  avoid = concatStringsSep "|" [
    "(h|H)yprland"
    "sway"
    "Xwayland"
    "cryptsetup"
    "dbus-.*"
    "gpg-agent"
    "greetd"
    "ssh-agent"
    ".*qemu-system.*"
    "sddm"
    "sshd"
    "systemd"
    "systemd-.*"
    "kitty"
    "bash"
    "zsh"
    "n?vim"
    "emacs"
  ];

  prefer = concatStringsSep "|" [
    "Web Content"
    "Isolated Web Co"
    "firefox.*"
    "chrom(e|ium).*"
    "electron"
    "dotnet"
    ".*.exe"
    "java.*"
    "pipewire(.*)"
    "nix"
    "npm"
    "node"
    "pipewire(.*)"
  ];

in
{
  options.modules.services.oom = {
    enable = mkEnableOption "out of memory prevention";
    earlyoom = {
      enable = mkEnableOption "earlyoom (Early OOM Daemon)";
    };
  };

  config = mkIf (cfg.enable && systemdEnabled) {
    services.earlyoom = mkIf cfg.earlyoom.enable {
      enable = true;
      enableNotifications = true;
      enableDebugInfo = true;

      reportInterval = 0;
      freeSwapThreshold = 15;
      freeSwapKillThreshold = 2;
      freeMemThreshold = 15;
      freeMemKillThreshold = 2;
      extraArgs = [
        "-g"
        "--avoid"
        "'^(${avoid})$'" # things that we want to avoid killing
        "--prefer"
        "'^(${prefer})$'" # things we want to remove fast
      ];

      # we should ideally write the logs into a designated log file; or even better, to the journal
      # for now we can hope this echo sends the log to somewhere we can observe later
      killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
        echo "Process $EARLYOOM_NAME ($EARLYOOM_PID) was killed"
      '';
    };

    systemd = {
      oomd = {
        enable = true;
        enableRootSlice = true;
        enableSystemSlice = true;
        enableUserSlices = true;
        extraConfig = {
          "DefaultMemoryPressureDurationSec" = "20s";
        };
      };
      services."nix-daemon".serviceConfig.OOMScoreAdjust = mkDefault 350;
    };
  };
}
