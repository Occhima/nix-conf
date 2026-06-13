{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "distrobox" cfg.tools) {
    programs.distrobox = {
      enable = true;
      enableSystemdUnit = true;

      containers = {
        netrunner = {
          image = "kalilinux/kali-rolling:latest";
          entry = true;
          home = "${config.home.homeDirectory}/pentesting/kali";
          init = true;
          pre_init_hooks = "export SHELL=/usr/bin/nu;";
          additional_packages = [
            "git"
            "npm"
            "build-essential"
            "fish"
            "zsh"
            "neovim"
            "starship"
            "eza"
            "bat"
            "zoxide"
            "fzf"
            "kali-linux-headless"
            "golang"
            "pipx"
            "ca-certificates"
            "curl"
            "unzip"
            "tar"
          ];

          init_hooks = [
            "GOPATH=/root/go GOBIN=/usr/local/bin go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest"
            "/usr/local/bin/pdtm -install-all -bp /usr/local/bin"
            "PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install pwncat-cs || true"
          ];
        };
      };
    };

    home.packages = [ pkgs.distrobox-tui ];
  };
}
