{ config, den, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  den.aspects = {
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

    anyrun.homeManager.imports = [ hm.anyrun ];
    terminal-kitty.homeManager.imports = [ hm.terminal-kitty ];
    terminal-ghostty.homeManager.imports = [ hm.terminal-ghostty ];
    rofi.homeManager.imports = [ hm.rofi ];
    mako-notifier.homeManager.imports = [ hm.mako-notifier ];
    hyprlock.homeManager.imports = [ hm.hyprlock ];
    wlogout.homeManager.imports = [ hm.wlogout ];
    zellij.homeManager.imports = [ hm.zellij ];
    opencode.homeManager.imports = [ hm.opencode ];
    waybar-dock.homeManager.imports = [ hm.waybar-dock ];
    foliate.homeManager.imports = [ hm.foliate ];
    browser-nyxt.homeManager.imports = [ hm.browser-nyxt ];
    calibre.homeManager.imports = [ hm.calibre ];
    spotify.homeManager.imports = [ hm.spotify ];
    browser-zen-beta.homeManager.imports = [ hm.browser-zen-beta ];
    browser-qutebrowser.homeManager.imports = [ hm.browser-qutebrowser ];
    browser-firefox.homeManager.imports = [ hm.browser-firefox ];
    hyprland = {
      nixos.imports = [ config.flake.modules.nixos.display-hyprland ];
      homeManager.imports = [ hm.hyprland ];
    };
    flatpak = {
      nixos.imports = [ config.flake.modules.nixos.flatpak-daemon ];
      homeManager.imports = [ hm.flatpak ];
    };
    podman = {
      nixos.imports = [ config.flake.modules.nixos.podman-host ];
      homeManager.imports = [ hm.podman ];
    };

    caelestia-dock.homeManager.imports = [ hm.caelestia-dock ];
    niri = {
      nixos.imports = [ config.flake.modules.nixos.display-niri ];
      homeManager.imports = [ hm.niri ];
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
  };
}
