{
  flake.modules.nixos.system-assertions =
    { config, ... }:
    let
      bootable = config.boot.loader.grub.enable || config.boot.loader.systemd-boot.enable;
    in
    {
      assertions = [
        {
          assertion =
            if config.wsl.enable or false then
              !bootable
            else
              bootable && config.fileSystems ? "/" && config.fileSystems ? "/boot";
          message = "a host must declare a bootloader, a root filesystem and an ESP (or be WSL)";
        }
      ];
    };
}
