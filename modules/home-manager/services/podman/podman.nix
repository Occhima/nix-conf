{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.podman;

  kaliDockerfile = pkgs.writeText "Containerfile" ''
    FROM kalilinux/kali-bleeding-edge
    ENV DEBIAN_FRONTEND noninteractive

    RUN apt-get update && apt-get -y install \
        kali-linux-headless seclists dirsearch gobuster golang exploitdb pipx git \
        && rm -rf /var/lib/apt/lists/*

    # RUN go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
    # ENV PATH "/root/go/bin:/root/.local/bin:''${PATH}"
    # RUN pdtm -install-all

    CMD ["/bin/bash"]
    # SHELL ["/usr/bin/nu", "-c"]
    # CMD ["/usr/bin/nu"]
  '';

  netrunnerScript = pkgs.writeShellScriptBin "netrunner" ''
    SERVICE="podman-netrunner.service"
    CONTAINER="netrunner"
    if ! systemctl --user is-active --quiet "$SERVICE"; then
      echo "⚡ Starting Netrunner container..."
      systemctl --user start "$SERVICE"

      echo "⏳ Waiting for container initialization..."
      until podman container exists "$CONTAINER" && podman container inspect "$CONTAINER" --format '{{.State.Running}}' | grep -q "true"; do
        sleep 0.5
      done
    else
      echo "✅ Netrunner is already running."
    fi

    echo "🚀 Spawning shell..."
    exec podman exec -it "$CONTAINER" bash
  '';
in
{
  options.modules.services.podman = {
    enable = mkEnableOption "User-level podman container management";
  };

  config = mkIf cfg.enable {

    home.packages = [
      netrunnerScript
    ];

    services.podman = {
      enable = true;
      enableTypeChecks = true;

      builds = {
        "netrunner-image" = {
          file = "${kaliDockerfile}";
          extraConfig = {
            Service = {
              TimeoutStartSec = "0";
              Type = "simple";
            };
          };
        };
      };

      containers = {
        netrunner = {
          image = "localhost/netrunner-image";

          autoStart = false;
          network = [ "host" ];
          volumes = [ "${config.home.homeDirectory}/pentest-lab:/home/htb" ];
          environment = {
            DEBIAN_FRONTEND = "noninteractive";
          };
          exec = "sleep infinity";

          extraConfig = {
            Unit = {
              Requires = [ "podman-netrunner-image-build.service" ];
            };
            Service = {
              RestartSec = "10";
            };
          };
        };
      };
    };

    home.activation.createPentestDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p $HOME/pentest-lab
    '';
  };
}
