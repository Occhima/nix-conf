{
  flake.modules.homeManager.themes-guernica =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf mkForce;
      inherit (config.lib.stylix) colors;

      themedConfig = pkgs.runCommand "quickshell-guernica-config" { } ''
        cp -R ${../../../../dock/quickshell/config} "$out"
        chmod -R u+w "$out"
        substituteInPlace "$out/data/Settings.qml" \
          --replace-fail '"#141818"' '"#${colors.base00}"' \
          --replace-fail '"#1e2424"' '"#${colors.base01}"' \
          --replace-fail '"#3c4848"' '"#${colors.base02}"' \
          --replace-fail '"#f8f8f8"' '"#${colors.base05}"' \
          --replace-fail '"#909090"' '"#${colors.base03}"' \
          --replace-fail '"#40c4ff"' '"#${colors.base0D}"' \
          --replace-fail '"#ffb000"' '"#${colors.base08}"' \
          --replace-fail '"#a0ff20"' '"#${colors.base0A}"' \
          --replace-fail '"#ff0060"' '"#${colors.base0E}"' \
          --replace-fail '"#c080ff"' '"#${colors.base0C}"' \
          --replace-fail '"#6080ff"' '"#${colors.base09}"' \
          --replace-fail '"#ffe080"' '"#${colors.base0B}"'
      '';
    in
    {
      programs.quickshell.configs.base = mkIf config.programs.quickshell.enable (mkForce themedConfig);
    };
}
