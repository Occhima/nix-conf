{
  inputs,
  config,
  username,
  ...
}:

{
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  config = {

    home = {
      stateVersion = "24.11";
      homeDirectory = "/home/${username}";
      username = username;
      preferXdgDirectories = true;

      persistence = {
        "${config.home.homeDirectory}/persist" = {
          defaultDirectoryMethod = "symlink";
          directories = [
            "Documents"
            "Dropbox"
            "Downloads"
            "Pictures"
            "Videos"
            ".local/bin"
            ".ssh"
            ".local/share/nix" # trusted settings and repl history
          ];
          allowOther = true;
        };
      };

    };

    xdg = {
      enable = true;
      configHome = "${config.home.homeDirectory}/.config"; # Use $HOME instead of trying to reference config
      dataHome = "${config.home.homeDirectory}/.local/share";
      cacheHome = "${config.home.homeDirectory}/.cache";
    };

    systemd.user.startServices = "sd-switch";
    programs.home-manager.enable = true;

  };
}
