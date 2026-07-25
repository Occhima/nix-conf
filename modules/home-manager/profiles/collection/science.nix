{
  flake.modules.homeManager.science = { pkgs, ... }: {
    programs.tex-fmt.enable = true;

    home.packages = [
      pkgs.typst
      pkgs.rnote
      pkgs.biber
      # HM's programs.texlive calls deprecated texlive.combine; build the env directly.
      (pkgs.texliveMedium.withPackages (
        tpkgs: with tpkgs; [
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
        ]
      ))
    ];
  };
}
