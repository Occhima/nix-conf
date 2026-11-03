{
  flake.modules.nixos.graphical = {
    programs = {
      # we need dconf to interact with gtk
      dconf.enable = true;

      # gnome's keyring manager
      seahorse.enable = false;

      # NetworkManager tray applet: explicitly wanted on graphical desktops.
      nm-applet.enable = true;
    };
  };
}
