{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  writeShellApplication,
  symlinkJoin,
  uv,
  python3,
  git,
  rsync,
  bash,
  coreutils,
  cacert,
}:
let
  pname = "neurico";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ChicagoHAI";
    repo = "NeuriCo";

    rev = "d2a29c367061687f714541977618cc7bdfef6305";
    hash = lib.fakeHash;
  };

  repoTemplate = stdenvNoCC.mkDerivation {
    inherit pname version src;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/${pname}"
      cp -R . "$out/share/${pname}/repo"
      chmod -R u+w "$out/share/${pname}/repo"
      rm -rf "$out/share/${pname}/repo/.git"

      runHook postInstall
    '';
  };

  neurico = writeShellApplication {
    name = "neurico";

    runtimeInputs = [
      uv
      python3
      git
      rsync
      bash
      coreutils
      cacert
    ];

    text = ''
      set -euo pipefail

      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      export CURL_CA_BUNDLE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      export REQUESTS_CA_BUNDLE="${cacert}/etc/ssl/certs/ca-bundle.crt"

      XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
      XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
      XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"

      app_root="$XDG_DATA_HOME/${pname}"
      repo_dir="$app_root/repo"
      template_dir="${repoTemplate}/share/${pname}/repo"
      state_dir="$XDG_STATE_HOME/${pname}"
      cache_dir="$XDG_CACHE_HOME/${pname}"

      bootstrap_repo() {
        if [ ! -e "$repo_dir/pyproject.toml" ]; then
          mkdir -p "$app_root"
          rsync -a --delete "$template_dir/" "$repo_dir/"
          chmod -R u+w "$repo_dir"

          if [ -f "$repo_dir/.env.example" ] && [ ! -f "$repo_dir/.env" ]; then
            cp "$repo_dir/.env.example" "$repo_dir/.env"
          fi

          echo "Bootstrapped NeuriCo into $repo_dir"
        fi
      }

      ensure_env() {
        mkdir -p "$state_dir" "$cache_dir"

        export UV_CACHE_DIR="$cache_dir/uv"
        export UV_PROJECT_ENVIRONMENT="$state_dir/.venv"

        uv sync \
          --project "$repo_dir" \
          --frozen \
          --no-install-project \
          --python "${python3}/bin/python3"
      }

      run_py() {
        local rel="$1"
        shift
        exec "$UV_PROJECT_ENVIRONMENT/bin/python" "$repo_dir/$rel" "$@"
      }

      show_help() {
        cat <<EOF
      Usage:
        neurico fetch <ideahub_url> [args...]
        neurico submit <idea.yaml> [args...]
        neurico run <idea_id> [args...]
        neurico sync
        neurico shell
        neurico repo-path
        neurico bootstrap

      Paths:
        repo   : $repo_dir
        env    : $repo_dir/.env
        venv   : $state_dir/.venv
        cache  : $cache_dir/uv
      EOF
      }

      cmd="''${1:-help}"
      if [ "$#" -gt 0 ]; then
        shift
      fi

      bootstrap_repo

      case "$cmd" in
        bootstrap)
          echo "$repo_dir"
          ;;
        repo-path)
          echo "$repo_dir"
          ;;
        sync)
          ensure_env
          ;;
        fetch)
          ensure_env
          cd "$repo_dir"
          run_py "src/cli/fetch_from_ideahub.py" "$@"
          ;;
        submit)
          ensure_env
          cd "$repo_dir"
          run_py "src/cli/submit.py" "$@"
          ;;
        run)
          ensure_env
          cd "$repo_dir"
          run_py "src/core/runner.py" "$@"
          ;;
        shell)
          ensure_env
          cd "$repo_dir"
          exec "''${SHELL:-${bash}/bin/bash}"
          ;;
        help|-h|--help|"")
          show_help
          ;;
        *)
          echo "Unknown subcommand: $cmd" >&2
          show_help >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  inherit neurico;

  scripts = symlinkJoin {
    name = "${pname}-scripts";
    paths = [ neurico ];
  };
}
