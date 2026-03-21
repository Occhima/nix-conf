{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.modules.editor.emacs;

in
{
  options.modules.editor.emacs = {
    enable = mkEnableOption "Emacs editor";
    default = mkEnableOption "Use emacs as the default editor";
    service = mkEnableOption "Emacs daemon service";

    flavor = mkOption {
      type = types.enum [
        "vanilla"
        "doom"
      ];
      default = "vanilla";
      description = "Select which Emacs configuration tree to deploy.";
    };
  };

  config = mkIf cfg.enable {

    home = {
      packages = [
        (pkgs.writeShellScriptBin "remdaemon" ''
          set -euo pipefail
          systemctl --user daemon-reload
          systemctl --user restart emacs
        '')
      ];
      sessionVariables.EMACSDIR = "${config.xdg.configHome}/emacs";
      sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    };

    services.emacs = mkIf cfg.service {
      enable = true;
      client = {
        enable = true;
        arguments = [ "-c" ];
      };
      defaultEditor = cfg.default;
      startWithUserSession = "graphical";
    };
  };
}
