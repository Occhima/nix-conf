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
          additional_packages = "git npm build-essential fish zsh neovim starship eza bat zoxide fzf seclists";
        };
      };
    };
    home.packages = [ pkgs.distrobox-tui ];
  };
}
