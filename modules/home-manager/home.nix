{ config, ... }:
{

  config = {
    home = {
      stateVersion = "23.11";
      homeDirectory = "/home/${config.home.username}";
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";

  };

}
