{
  flake.modules.nixos.boot-systemd = {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 15;
      consoleMode = "max";
      editor = false;
    };
  };
}
