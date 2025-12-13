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
      extraPackages = tpkgs: {
        inherit (tpkgs)
          biblatex
          biber
          latexmk
          scheme-medium
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
          capt-of
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
          wrapfig
          minted
          upquote
          mdframed
          zref
          ;
      };
    };

    home.packages = [
      pkgs.marimo
      pkgs.quarto

      #NOTE: still broken
      # pkgs.rnote
    ];
  };
}
