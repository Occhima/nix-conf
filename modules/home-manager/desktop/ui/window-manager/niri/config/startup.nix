{
  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [
          "wl-paste"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "wl-paste"
          "--type text"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "dbus-update-activation-environment"
          "--systemd"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
        ];
      }
    ];
  };

}
