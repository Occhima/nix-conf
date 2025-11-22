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

    CMD ["/bin/bash"]
  '';

  netrunnerScript = pkgs.writeShellScriptBin "netrunner" ''
    IMAGE_NAME="localhost/netrunner-image"
    SERVICE="podman-netrunner.service"
    CONTAINER="netrunner"

    # A. Build if missing
    if ! podman image exists "$IMAGE_NAME"; then
      echo "[-] Image not found. Building $IMAGE_NAME..."
      podman build -t "$IMAGE_NAME" -f "${kaliDockerfile}" .
    fi

    # B. Start Service if stopped
    if ! systemctl --user is-active --quiet "$SERVICE"; then
      echo "[-] Starting Netrunner service..."
      systemctl --user start "$SERVICE"

      echo "[-] Waiting for container initialization..."
      until podman container exists "$CONTAINER" && podman container inspect "$CONTAINER" --format '{{.State.Running}}' | grep -q "true"; do
        sleep 1
      done
    fi

    # C. Connect (Switched to bash)
    echo "[+] Connecting to shell..."
    exec podman exec -it "$CONTAINER" bash
  '';

in
{
  options.modules.services.podman = {
    enable = mkEnableOption "User-level podman container management";
  };

  config = mkIf cfg.enable {
    home.packages = [ netrunnerScript ];

    services.podman = {
      enable = true;
      enableTypeChecks = true;

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
