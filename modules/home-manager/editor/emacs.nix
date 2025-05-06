{
  config,
  osConfig,
  lib,
  self,
  pkgs,
  ...
}:
let
  inherit (self.lib.custom) ifPackageNotEnabled;
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) getAttr;

  cfg = config.modules.editor.emacs;
  mkEmacsHomePackages =
    packages:
    let
      filteredPackages = ifPackageNotEnabled config osConfig packages;
    in
    map (packageName: getAttr packageName pkgs) filteredPackages;

  basePackages = mkEmacsHomePackages [
    "mu"
    "ripgrep"
    "git"
    "fd"
    "sqlite"
    "cmake"
    "gnumake"
    "graphviz"
    "pandoc"
    "gnutls"
    "ffmpeg"
    "texliveBasic"
    "beancount"
    "fava"
    "beancount-language-server"
    "imagemagick"
    "binutils"
    "editorconfig-core-c"
    "languagetool"
    "emacs-all-the-icons-fonts"
    "emacs-lsp-booster"
  ];
in

{
  options.modules.editor.emacs = {
    enable = mkEnableOption "Emacs editor";
    default = mkEnableOption "Use emacs as the default editor";
    service = mkEnableOption "Emacs daemon service";
  };

  config = mkIf cfg.enable {

    programs.emacs = {
      enable = true;
      package =
        if osConfig.modules.system.display.type == "wayland" then pkgs.emacs-git-pgtk else pkgs.emacs-git;
      extraPackages =
        epkgs: with epkgs; [
          treesit-grammars.with-all-grammars
          vterm
          mu4e
          pdf-tools
          all-the-icons-nerd-fonts
        ];

    };

    home = {
      packages = basePackages;

      shellAliases = {
        remdaemon = "systemctl daemon-reload --user && systemctl restart emacs --user";
      };
      sessionVariables.EMACSDIR = "${config.xdg.configHome}/emacs";
      sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    };
    # TODO: maybe add keymaps as a module in the home manager config
    #  like the emacs

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
