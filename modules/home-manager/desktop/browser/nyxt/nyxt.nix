{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.browser-nyxt =
    {
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    let
      inherit (lib.modules) mkIf;

      nyxt = flakePkgs.${pkgs.stdenv.hostPlatform.system}.nyxt-source;

      systemFonts = osConfig.environment.etc.fonts.source or null;

      fontconfig = pkgs.runCommand "nyxt-fontconfig" { } ''
        mkdir -p "$out/conf.d"
        for conf in ${systemFonts}/conf.d/*.conf; do
          if grep -qE 'genericfamily|xsi:nil' "$conf"; then continue; fi
          ln -s "$(readlink -f "$conf")" "$out/conf.d/$(basename "$conf")"
        done
        substitute ${systemFonts}/fonts.conf "$out/fonts.conf" \
          --replace-fail /etc/fonts/conf.d "$out/conf.d"
      '';

      nyxtWrapped = pkgs.symlinkJoin {
        inherit (nyxt) meta;
        name = "nyxt-${nyxt.version}";
        paths = [ nyxt ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          rm "$out/bin/nyxt"
          makeWrapper ${nyxt}/bin/nyxt "$out/bin/nyxt" \
            --set-default FONTCONFIG_FILE ${fontconfig}/fonts.conf \
            --add-flags '--electron-opts "--enable-gpu-rasterization --enable-zero-copy --ignore-gpu-blocklist"'
        '';
      };
    in
    {
      config = mkIf pkgs.stdenv.hostPlatform.isLinux {
        home = {
          packages = [
            (if systemFonts == null then nyxt else nyxtWrapped)
          ];

          activation.nyxtBookmarks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            bookmarks="''${HOME}/.local/share/nyxt/bookmarks.lisp"
            if [ ! -e "$bookmarks" ]; then
              run mkdir -p "$(dirname "$bookmarks")"
              run install -m 0644 ${./bookmarks.lisp} "$bookmarks"
            fi
          '';
        };

        xdg.configFile = {
          "nyxt".source = ./config;

          "flake-nyxt/slynk.lisp".text = ''
            (in-package #:nyxt-user)

            (define-command-global start-slynk (&optional (port 4008))
              "Start a Slynk server on localhost, for `sly-connect' from Emacs.

            This lets Emacs evaluate arbitrary code inside Nyxt, so it binds to the
            loopback interface only and is never started automatically."
              (handler-case
                  (progn
                    (asdf:initialize-output-translations
                     '(:output-translations
                       (t (:home ".cache/common-lisp" :implementation))
                       :ignore-inherited-configuration))
                    (asdf:initialize-source-registry
                     '(:source-registry
                       (:directory #p"${pkgs.sbclPackages.slynk}/slynk/")
                       :ignore-inherited-configuration))
                    (asdf:load-system :slynk)
                    (uiop:symbol-call :slynk :create-server
                                      :port port :dont-close t
                                      :interface "127.0.0.1")
                    (echo "Slynk listening on 127.0.0.1:~a" port))
                (error (c) (echo-warning "Could not start Slynk: ~a" c))))
          '';
        };
      };
    };
}
