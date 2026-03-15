{ ... }:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
      python = pkgs.python312;
      uv = pkgs.uv;

      texlive = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-medium
          # Build tooling
          latexmk
          biber
          biblatex
          # Fonts
          libertinus-fonts
          libertinust1math
          sourcecodepro
          fourier
          # Typography & layout
          microtype
          setspace
          footmisc
          fnpct
          emptypage
          textcase
          ragged2e
          parskip
          indentfirst
          contour
          # Floats & figures
          floatrow
          stfloats
          fewerfloatpages
          subcaption
          caption
          pdflscape
          pdfpages
          # Tables
          threeparttable
          makecell
          colortbl
          # Math
          thmtools
          mathtools
          cancel
          # Code listings
          listings
          lstautogobble
          fvextra
          framed
          # TikZ / PGF
          pgfplots
          pgfgantt
          # Headers, sections & TOC
          fancyhdr
          titlesec
          tocbibind
          enumitem
          appendix
          epigraph
          # Hyperlinks & metadata
          hyperxmp
          hypcap
          # Misc
          csquotes
          soul
          soulutf8
          multicol
          qrcode
          imakeidx
          hologo
          xpatch
          regexpatch
          filehook
          letltxmacro
          fontaxes
          iflang
          translator
          ;
      };

      commonPackages = [
        uv
        python
        pkgs.nil
        pkgs.marimo
        texlive
      ];

      uvSync = ''
        if [ -s coding/python/pyproject.toml ]; then
          echo "Synchronizing Python dependencies with uv..."
          uv sync --directory coding/python --all-groups
        fi

        ${config.pre-commit.installationScript}
      '';
    in
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.treefmt.build.devShell ];
        name = "academic";
        packages = commonPackages;
        shellHook = uvSync;

        env = {
          UV_PYTHON_PREFERENCE = "only-managed";
          PYTHONDONTWRITEBYTECODE = "1";
        };
      };
    };
}
