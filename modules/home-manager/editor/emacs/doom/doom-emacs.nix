{ inputs, config, ... }:
let
  inherit (config.flake.lib.custom) ifPackageNotEnabled;
  emacs-core = config.flake.modules.homeManager.emacs-core;
in
{
  flake-file.inputs.nix-doom-emacs-unstraightened = {
    url = "github:marienz/nix-doom-emacs-unstraightened";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.homeManager.emacs-doom =
    {
      config,
      osConfig ? { },
      pkgs,
      ...
    }:
    let
      inherit (builtins) getAttr;

      emacsBase = pkgs.emacs-pgtk;
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
        "gnutls"
        "ffmpeg"
        "imagemagick"
        "binutils"
        "editorconfig-core-c"
        "languagetool"
        "emacs-all-the-icons-fonts"
        "emacs-lsp-booster"
      ];
    in
    {
      imports = [
        emacs-core
        inputs.nix-doom-emacs-unstraightened.homeModule
      ];

      programs.doom-emacs = {
        enable = true;
        doomDir = ./doom-cfg;
        emacs = emacsBase;
        # The 2026-09 MELPA snapshot of ct.el is broken: ct.el now (require 'ct-hct)
        # at the top before defining ct-clamp, and ct-hct.el calls it while loading,
        # so byte-compilation dies with "Symbol's function definition is void:
        # ct-clamp". Pin the last commit before the hct-colorspace rewrite.
        # Drop this override once upstream neeasade/ct.el fixes the load order.
        emacsPackageOverrides = eself: esuper: {
          ct = esuper.melpaBuild {
            pname = "ct";
            version = "0.3-unstable-2026-09-03";
            commit = "d47271cc1b5ef55cf74a3e25ac45a187b36910d5";
            src = pkgs.fetchFromGitHub {
              owner = "neeasade";
              repo = "ct.el";
              rev = "d47271cc1b5ef55cf74a3e25ac45a187b36910d5";
              hash = "sha256-Cp6pOfZ3yT6xypnPSM6zU9GixSJN+qigNY631jcMlZ8=";
            };
            packageRequires = with esuper; [
              dash
              hsluv
            ];
            meta = with pkgs.lib; {
              description = "Color Tools - a color api";
              license = licenses.mit;
            };
          };
          # consult-omni's sources require optional packages that its
          # Package-Requires header doesn't declare, so nde's dep scanner misses
          # them and byte-compilation fails. Add them to the build env; drop the
          # ones upstream declares later.
          consult-omni = esuper.consult-omni.overrideAttrs (old: {
            packageRequires =
              (old.packageRequires or [ ])
              ++ (with eself; [
                browser-hist
                elfeed
                gptel
                notmuch
                s
                consult-gh
                consult-mu
                embark-consult
              ]);
          });
          # Same issue in consult-mu: embark and mu4e are required but undeclared.
          consult-mu = esuper.consult-mu.overrideAttrs (old: {
            packageRequires =
              (old.packageRequires or [ ])
              ++ (with eself; [
                embark
                mu4e
              ]);
          });
        };
        extraPackages =
          epkgs: with epkgs; [
            treesit-grammars.with-all-grammars
            vterm
            eat
            mu4e
            pdf-tools
            all-the-icons-nerd-fonts
            telega
            ement
            browser-hist
          ];
      };

      home.packages = basePackages ++ [
        (pkgs.writeShellApplication {
          name = "refresh-doom";
          runtimeInputs = [ pkgs.systemd ];
          text = ''
            doom sync
            systemctl --user daemon-reload
            systemctl --user restart emacs
          '';
        })

        (pkgs.writeShellApplication {
          name = "upgrade-doom";
          runtimeInputs = [ pkgs.systemd ];
          text = ''
            doom upgrade
            systemctl --user daemon-reload
            systemctl --user restart emacs
          '';
        })
      ];
    };
}
