{
  flake.modules.homeManager.browser-nyxt =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkIf;

      readability = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/mozilla/readability/0.6.0/Readability.js";
        sha256 = "0x7ivzw4ym2h4mphr7rbqgl2kq14c5mys3lr0agh3l1j10yspp1l";
      };

    in
    {
      config = mkIf pkgs.stdenv.hostPlatform.isLinux {
        modules.desktop.apps.flatpak.packages = [
          rec {
            appId = "engineer.atlas.Nyxt";
            sha256 = "sha256-Wb/IndwOejpHzC0Jw5yL9HI53xNo0Q806qcvEh31V8s=";
            bundle = "${pkgs.fetchurl {
              url = "https://github.com/atlas-engineer/nyxt/releases/download/5.0.0/Nyxt-5.0.0-x86_64.flatpak";
              inherit sha256;
            }}";
          }
        ];

        services.flatpak.overrides.settings."engineer.atlas.Nyxt".Context.filesystems = [
          "/nix/store:ro"
          "xdg-config/nyxt:ro"
          "xdg-config/flake-nyxt:ro"
          "xdg-config/flake-themes:ro"
          "xdg-run/nyxt:create"
        ];

        home = {
          packages = [
            (pkgs.writeShellScriptBin "nyxt" ''
              exec ${lib.getExe pkgs.flatpak} run --user engineer.atlas.Nyxt "$@"
            '')
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

          "flake-nyxt/paths.lisp".text = ''
            (in-package #:nyxt-user)
            (defvar *readability-js* #p"${readability}")
            (defvar *pandoc* "${lib.getExe pkgs.pandoc}")
            (defvar *mpv* "${lib.getExe pkgs.mpv}")
          '';

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
