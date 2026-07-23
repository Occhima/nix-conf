{
  flake.modules.nixos.security-auth =
    {
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      config = {
        security = {
          # Sudo configuration. Wheel requires normal authentication — no
          # NOPASSWD rules for system binaries.
          sudo = {
            enable = true;
            execWheelOnly = true;
            wheelNeedsPassword = true;

            extraConfig = ''
              Defaults lecture = never
              Defaults pwfeedback
              Defaults env_keep += "EDITOR PATH DISPLAY"
              Defaults timestamp_timeout = 300
            '';
          };

          sudo-rs.enable = false;

          # PAM configuration
          pam.loginLimits = [
            {
              domain = "@wheel";
              item = "nofile";
              type = "soft";
              value = "524288";
            }
            {
              domain = "@wheel";
              item = "nofile";
              type = "hard";
              value = "1048576";
            }
          ];

          # Polkit configuration
          polkit = {
            enable = mkDefault true;
          };

          soteria.enable = true;
        };
      };
    };
}
