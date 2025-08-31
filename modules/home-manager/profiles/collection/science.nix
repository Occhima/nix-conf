{
  config,
  self,
  pkgs,
  lib,
  ...

}:
let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
in
{

  config = mkIf (hasProfile config [ "science" ]) {
    programs.tex-fmt.enable = true;
    programs.texlive = {
      enable = true;
      # packageSet = pkgs.texliveMedium;
      extraPackages = tpkgs: {
        inherit (tpkgs)
          biblatex
          latexmk
          latexindent
          chktex
          collection-basic
          amsfonts
          collection-latexrecommended
          collection-fontsrecommended
          fontspec
          collection-fontsextra
          scheme-basic
          enumitem
          datetime
          fancyhdr
          lipsum
          varwidth
          eulervm
          needspace
          biblatex-trad
          biblatex-software
          xkeyval
          xurl
          xifthen
          ;
      };
    };

    home.packages = [
      # pkgs.marimo
      pkgs.quarto
    ];
  };
}
