# emacs-core: shared Emacs session environment. Imported by the flavor
# modules (emacs-doom, emacs-vanilla); enable a flavor to get an editor.
{
  flake.modules.homeManager.emacs-core =
    {
      config,
      pkgs,
      ...
    }:
    {
      home = {
        packages = [
          (pkgs.writeShellScriptBin "restart-emacs-daemon" ''
            set -euo pipefail
            systemctl --user daemon-reload
            systemctl --user restart emacs
          '')
        ];
        sessionVariables.EMACSDIR = "${config.xdg.configHome}/emacs";
        sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
      };
    };
}
