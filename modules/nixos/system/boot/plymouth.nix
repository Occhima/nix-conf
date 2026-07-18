{
  flake.modules.nixos.boot-plymouth =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.meta) getExe';
      inherit (lib.options) mkOption;
      inherit (lib.types) bool;

    in
    {
      options.modules.system.boot.plymouth = {
        enable = mkOption {
          type = bool;
          default = true;
          description = "Enable plymouth boot splash";
        };
      };

      config = {
        boot.plymouth = {
          enable = true;
          theme = "deus_ex";

          themePackages = with pkgs; [
            # By default we would install all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "deus_ex" ];
            })
          ];
        };

        # Make plymouth work with sleep
        powerManagement = {
          powerDownCommands = "${getExe' pkgs.plymouth "plymouth"} --show-splash";
          resumeCommands = "${getExe' pkgs.plymouth "plymouth"} --quit";
        };
      };
    };
}
