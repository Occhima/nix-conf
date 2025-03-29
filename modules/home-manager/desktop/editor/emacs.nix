{
  config,
  osConfig,
  lib,
  inputs,
  self,
  pkgs,
  ...
}:
let
  inherit (self.lib.custom) ifPackageNotEnabled;
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) getAttr;
  cfg = config.modules.desktop.editor.emacs;

in
{
  options.modules.desktop.editor.emacs = {
    enable = mkEnableOption "Emacs editor";
    default = mkEnableOption "Use emacs as the default editor";
    service = mkEnableOption "Emacs daemon service";
  };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    programs.emacs = {
      enable = true;
      package =
        if osConfig.modules.system.display.type == "wayland" then pkgs.emacs-git-pgtk else pkgs.emacs-git;
      extraPackages =
        epkgs: with epkgs; [
          treesit-grammars.with-all-grammars
          vterm
          mu4e
        ];
    };

    home = {
      packages =
        let
          filteredPackages = ifPackageNotEnabled config osConfig [
            "mu"
            "ripgrep"
            "git"
            "findutils"
            "emacs-all-the-icons-fonts"
            "emacs-lsp-booster"
          ];
        in
        map (packageName: getAttr packageName pkgs) filteredPackages;

      shellAliases = {
        remdaemon = "systemctl daemon-reload --user && systemctl restart emacs --user";
      };
      sessionVariables.EMACSDIR = "${config.home.homeDirectory}/.config/emacs";
      sessionPath = [ "${config.home.homeDirectory}/.config/emacs/bin" ];

    };
    # TODO: maybe add keymaps as a module in the home manager config
    #  like the emacs

    services.emacs = mkIf cfg.service {
      client = {
        enable = true;
        arguments = [ "-c" ];
      };
      defaultEditor = cfg.default;
      startWithUserSession = true;

    };
  };
}
