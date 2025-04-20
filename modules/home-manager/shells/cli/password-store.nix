{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) getExe mkIf mkEnableOption;
  cfg = config.modules.shell.cli.passwordStore;
  cfgShell = config.modules.shell.cli;
  storeSettings = config.programs.password-store;

  agePackage = pkgs.rage;
  passageRoot = "${config.xdg.configHome}/secrets";

  passage-yubikey-update = pkgs.writeShellApplication {
    name = "passage-yubikey-update";
    runtimeInputs = [
      pkgs.age-plugin-yubikey
    ];
    text = # bash
      ''
        if ! [[ -d "${storeSettings.settings.PASSAGE_DIR}" ]]; then
              echo >&2 "Error: ${storeSettings.settings.PASSAGE_DIR} must be created manually."
              exit 1
        fi

        identitiesFile="${storeSettings.settings.PASSAGE_IDENTITIES_FILE}"
        recipientsFile="${storeSettings.settings.PASSAGE_RECIPIENTS_FILE}"


        mkdir -p "$(dirname "$identitiesFile")"
        mkdir -p "$(dirname "$recipientsFile")"

        age-plugin-yubikey --identity >> "$identitiesFile"
        echo >&2 "Updated $identitiesFile"

        age-plugin-yubikey --list >> "$recipientsFile"
        echo >&2 "Updated $recipientsFile"
      '';
  };
in
{
  options.modules.shell.cli.passwordStore = {
    enable = mkEnableOption "passage password manager";
    secretService = mkEnableOption "pass secret service integration";
  };

  config = mkIf (cfg.enable && cfgShell.enable) {
    programs.password-store = {
      enable = true;
      package = pkgs.passage;
      settings = {
        PASSAGE_DIR = "${passageRoot}/store";
        PASSAGE_AGE = getExe agePackage;
        PASSAGE_IDENTITIES_FILE = "${passageRoot}/identities";
        PASSAGE_RECIPIENTS_FILE = "${passageRoot}/store/.age-recipients";
      };
    };

    services.pass-secret-service = mkIf cfg.secretService {
      enable = true;
      storePath = storeSettings.settings.PASSAGE_DIR;
    };

    home = {
      shellAliases = {
        pass = "passage";
      };

      packages = [
        passage-yubikey-update
      ];
    };
  };
}
