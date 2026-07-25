{
  flake.modules.nixos.login-ly = {
    config = {
      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "matrix";
          clear_password = true;
          hide_version_string = true;
          xinitrc = ""; # Hide xinitrc option (X11 not configured)
          setup_cmd = ""; # Don't use xsession-wrapper for shell sessions
        };
      };
    };
  };
}
