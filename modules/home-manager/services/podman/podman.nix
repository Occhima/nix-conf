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
    # Stage 1: Get Nushell
    FROM ghcr.io/nushell/nushell:latest AS nu-source

    # Stage 2: Kali Layer
    FROM kalilinux/kali-bleeding-edge
    ENV DEBIAN_FRONTEND noninteractive

    # Install tools (No 'nushell' here, we copy it)
    RUN apt-get update && apt-get -y install \
        kali-linux-headless seclists dirsearch gobuster golang exploitdb pipx git \
        && rm -rf /var/lib/apt/lists/*

    # Copy Nushell binary from Stage 1
    COPY --from=nu-source /usr/bin/nu /usr/bin/nu

    # Set Default Shell
    SHELL ["/usr/bin/nu", "-c"]
    CMD ["/usr/bin/nu"]
  '';

  netrunnerScript = pkgs.writeShellScriptBin "netrunner" ''
    g="${pkgs.gum}/bin/gum"
    IMAGE_NAME="localhost/netrunner-image"
    SERVICE="podman-netrunner.service"
    CONTAINER="netrunner"

    if ! podman image exists "$IMAGE_NAME"; then
      $g log "Image missing. Initializing build..."

      $g spin --spinner --dot --title "Building Kali Image (Please Wait)..." -- \
        podman build -t "$IMAGE_NAME" -f "${kaliDockerfile}" .

      $g "Build Complete."
    fi

    if ! systemctl --user is-active --quiet "$SERVICE"; then
      $g spin --spinner dot --title "Starting Service..." -- \
        systemctl --user start "$SERVICE"

      $g spin --spinner points --title "Waiting for container..." -- \
        bash -c "until podman container exists $CONTAINER && podman container inspect $CONTAINER --format '{{.State.Running}}' | grep -q 'true'; do sleep 0.5; done"
    fi

    echo ""
    $g style "Container started."
    sleep 0.5
    clear
    exec podman exec -it "$CONTAINER" nu
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
