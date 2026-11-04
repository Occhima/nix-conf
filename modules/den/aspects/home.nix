{
  config,
  den,
  lib,
  ...
}:
let
  hm = config.flake.modules.homeManager;
  nixos = config.flake.modules.nixos;

  homeOnly =
    names:
    lib.genAttrs names (name: {
      homeManager.imports = [ hm.${name} ];
    });

  withNixos = lib.mapAttrs (
    name: nixosModule: {
      nixos.imports = [ nixos.${nixosModule} ];
      homeManager.imports = [ hm.${name} ];
    }
  );
in
{
  den.aspects = lib.mkMerge [
    (homeOnly [
      "anyrun"
      "terminal-kitty"
      "terminal-ghostty"
      "rofi"
      "mako-notifier"
      "hyprlock"
      "wlogout"
      "zellij"
      "opencode"
      "waybar-dock"
      "foliate"
      "browser-nyxt"
      "calibre"
      "spotify"
      "browser-zen-beta"
      "browser-qutebrowser"
      "browser-firefox"
      "caelestia-dock"
      "espanso"
      "web"
      "data"
      "dev"
      "science"
      "finance"
    ])
    (withNixos {
      hyprland = "display-hyprland";
      flatpak = "flatpak-daemon";
      podman = "podman-host";
      niri = "display-niri";
      pentesting = "pentesting-container";
    })
    {
      home-base.homeManager.imports = [ hm.home ];

      cli-core.homeManager.imports = with hm; [
        bat
        eza
        fzf
        ripgrep
        jq
        pandoc
      ];
      cli-git.homeManager.imports = with hm; [
        gh
        gitbutler
        lazygit
        jujutsu
        git
        email
      ];
      cli-shell.homeManager.imports = with hm; [
        atuin
        zoxide
        direnv
        nix-your-shell
        navi
        pay-respects
      ];
      cli-tui = {
        homeManager.imports = with hm; [
          yazi
          fastfetch
        ];
        includes = [ den.aspects.zellij ];
      };
      cli-security.homeManager.imports = with hm; [
        ssh
        gpg
      ];
      cli-dev.homeManager.imports = [ hm.distrobox ];
      cli-ai.includes = [ den.aspects.opencode ];
      cli-ai.homeManager.imports = with hm; [
        claude-code
        codex
        fabric
        jcode
        pi
        codegraph
        feynman
      ];

      shell = {
        homeManager.imports = with hm; [
          shell-zsh
          prompt-starship
          password-store
        ];
        includes = with den.aspects; [
          cli-core
          cli-git
          cli-shell
          cli-tui
          cli-security
          cli-dev
        ];
      };

      editors.homeManager.imports = [ hm.neovim ];

      # Doom flavor + daemon/default editor (selected by import).
      emacs.homeManager.imports = with hm; [
        emacs-doom
        emacs-daemon
      ];

      # hm.julia is intentionally NOT imported: even plain `pkgs.julia` performs
      # import-from-derivation on this pinned nixpkgs, which the flake-wide
      # no-IFD gate forbids.
      languages.homeManager.imports = with hm; [
        python
        c
      ];

      personal-data.homeManager.imports = with hm; [
        xdg
        persistence
        maestral
        maestral-service
        email
      ];

      ai = {
        homeManager.imports = [ hm.ai ];
        includes = [ den.aspects.cli-ai ];
      };

      desktop = {
        homeManager.imports = with hm; [
          desktop-notifications
          discord # vesktop wraps EOL electron; re-enable once nixpkgs bumps electron
          # grimblast
          flameshot
          chess
        ];
        includes = with den.aspects; [
          hyprland
          flatpak
          browser-nyxt
          terminal-ghostty
          mako-notifier
          hyprlock
          wlogout
          foliate
          guernica
          # calibre
          spotify
          browser-zen-beta
          browser-qutebrowser
        ];
      };
    }
  ];
}
