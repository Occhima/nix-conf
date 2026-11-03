{
  flake.modules.nixos.headless = {
    systemd = {
      enableEmergencyMode = false;

      watchdog = {
        runtimeTime = "20s";
        rebootTime = "30s";
      };

      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
    };
  };
}
