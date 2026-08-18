{
  flake.modules.nixos.iso-space =
    { lib, ... }:
    let
      inherit (lib.modules) mkForce mkDefault;
    in
    {
      documentation = {
        enable = mkDefault false;
        doc.enable = mkDefault false;
        info.enable = mkDefault false;
      };
      services = {
        logrotate.enable = false;
        udisks2.enable = false;
      };

      fonts.fontconfig.enable = mkForce false;

      boot.enableContainers = false;

      programs = {
        less.lessopen = null;
        command-not-found.enable = false;
      };

      environment = {
        stub-ld.enable = mkForce false;
        defaultPackages = [ ];
      };

      xdg = {
        autostart.enable = false;
        icons.enable = false;
        mime.enable = false;
        sounds.enable = false;
      };
    };
}
