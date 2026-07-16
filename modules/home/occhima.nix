# Standalone HM config for occhima (used by homeConfigurations.occhima).
# When HM is loaded through NixOS (via accounts aspect), osConfig is real.
# When standalone, osConfig is {} (set in modules/homeConfigurations.nix).
{
  inputs,
  ...
}:
{
  config.flake.modules.homeManager.occhima = {
    imports = with inputs.self.modules.homeManager; [
      # Base
      home-base
      # Shell
      shell-zsh
      prompt-starship
      cli-core
      cli-git
      cli-shell
      cli-tui
      cli-security
      cli-dev
      password-store
      # Data
      xdg
      persistence
      maestral
      email
      # Editor
      neovim
      emacs
      # Services
      espanso
      podman
      # Dev
      python
      c
      julia
      # Desktop
      browser-zen-beta
      terminal-kitty
      hyprland
      quickshell-dock
      anyrun
      hyprlock
      themes-guernica
      # Apps
      flatpak
      spotify
      discord
      grimblast
      wlogout
      calibre
      # Profiles
      web
      data
      ai
      dev
      science
      finance
      pentesting
    ];
    config = {
      home.username = "occhima";
      home.homeDirectory = "/home/occhima";
      modules.editor.emacs = {
        flavor = "doom";
        service = true;
        default = true;
      };
    };
  };
}
