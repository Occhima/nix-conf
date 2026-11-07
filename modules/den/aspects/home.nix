{
  config,
  den,
  hm,
  nixos,
  lib,
  ...
}:
let
  withHost = lib.mapAttrs (
    name: nixosModule: {
      includes = [ (hm name) ];
      provides.to-hosts.nixos.imports = [ config.flake.modules.nixos.${nixosModule} ];
    }
  );
in
{
  den.aspects = lib.mkMerge [
    (withHost {
      hyprland = "display-hyprland";
      flatpak = "flatpak-daemon";
      podman = "podman-host";
      niri = "display-niri";
    })
    {
      pentesting = {
        includes = [ (nixos "pentesting-container") ];
        provides.to-users.homeManager.imports = [ config.flake.modules.homeManager.pentesting ];
      };

      cli-core.includes = map hm [
        "bat"
        "eza"
        "fzf"
        "ripgrep"
        "jq"
        "pandoc"
      ];
      cli-git.includes = map hm [
        "gh"
        "gitbutler"
        "lazygit"
        "jujutsu"
        "git"
        "email"
      ];
      cli-shell.includes = map hm [
        "atuin"
        "zoxide"
        "direnv"
        "nix-your-shell"
        "navi"
        "pay-respects"
      ];
      cli-tui.includes = map hm [
        "yazi"
        "fastfetch"
        "zellij"
      ];
      cli-security.includes = map hm [
        "ssh"
        "gpg"
      ];
      cli-ai.includes = map hm [
        "opencode"
        "claude-code"
        "codex"
        "fabric"
        "jcode"
        "pi"
        "codegraph"
        "feynman"
      ];

      shell.includes =
        (map hm [
          "shell-zsh"
          "prompt-starship"
          "password-store"
          "distrobox"
        ])
        ++ (with den.aspects; [
          cli-core
          cli-git
          cli-shell
          cli-tui
          cli-security
        ]);

      # Doom flavor + daemon/default editor (selected by import).
      emacs.includes = map hm [
        "emacs-doom"
        "emacs-daemon"
      ];

      # hm "julia" is intentionally NOT included: even plain `pkgs.julia` performs
      # import-from-derivation on this pinned nixpkgs, which the flake-wide
      # no-IFD gate forbids.
      languages.includes = map hm [
        "python"
        "c"
      ];

      personal-data.includes = map hm [
        "xdg"
        "persistence"
        "maestral"
        "maestral-service"
      ];

      ai.includes = [
        (hm "ai")
        den.aspects.cli-ai
      ];

      desktop.includes =
        (map hm [
          "desktop-notifications"
          "discord" # vesktop wraps EOL electron; re-enable once nixpkgs bumps electron
          # grimblast
          "flameshot"
          "chess"
          "browser-nyxt"
          "terminal-ghostty"
          "mako-notifier"
          "hyprlock"
          "wlogout"
          "foliate"
          # calibre
          "spotify"
          "browser-zen-beta"
          "browser-qutebrowser"
        ])
        ++ (with den.aspects; [
          hyprland
          flatpak
          guernica
        ]);
    }
  ];
}
