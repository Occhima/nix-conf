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
  '';
in
{
  options.modules.services.podman = {
    enable = mkEnableOption "User-level podman container management";
  };

  config = mkIf cfg.enable {
    services.podman = {
      enable = true;
      enableTypeChecks = true;

      builds = {
        "netrunner-image" = {
          file = "${kaliDockerfile}";
        };
      };

      containers = {
        netrunner = {
          image = "localhost/netrunner-image";

          autoStart = true;
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
