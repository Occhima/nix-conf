# Home Manager Aspects

Every file under `modules/home-manager/` contributes to
`flake.modules.homeManager.<aspect>`. A user environment (e.g.
`modules/users/occhima/home.nix`) composes these by importing them.

## Aspect families

| Area | Aspects (examples) |
| --- | --- |
| Base | `home-base`, `home`, `xdg`, `persistence` |
| Shells | `shell-zsh`, `shell-nushell`, `prompt-starship` |
| CLI aggregates | `cli-core`, `cli-git`, `cli-shell`, `cli-tui`, `cli-security`, `cli-dev`, `cli-ai` |
| CLI tools | `bat`, `eza`, `fzf`, `ripgrep`, `jq`, `atuin`, `direnv`, `gh`, `lazygit`, `jujutsu`, `yazi`, `zellij`, `zoxide`, `password-store`, … |
| Editors | `neovim`, `emacs`, `vscode`, `antigravity` |
| Development | `python`, `c`, `julia`, `haskell`, `r`, `beancount` |
| Desktop | `browser-zen-beta`, `browser-brave`, `nyxt`, `schizofox`, `terminal-kitty`, `terminal-ghostty` |
| Wayland UI | `hyprland` (merged from many fragment files), `niri`, `quickshell-dock`, `caelestia-dock`, `waybar`, `anyrun`, `rofi`, `hyprlock`, `mako`, `wlogout` |
| Themes | `themes-stylix`, `themes-guernica` (targets merge from `targets/`) |
| Apps | `flatpak`, `spotify`, `discord`, `calibre`, `grimblast`, `flameshot`, `lutris` |
| Services | `espanso`, `podman`, `maestral`, `cachix`, `clipboard` |
| Aggregates | `shell`, `desktop`, `editors`, `languages`, `data-core` |
| Topic profiles | `web`, `data`, `ai`, `dev`, `science`, `finance`, `pentesting` |

## Standalone vs integrated

Under NixOS, aspects can read host facts through `osConfig`. Always
declare it with a default so standalone Home Manager keeps evaluating:

```nix
{ osConfig ? { }, ... }:
{
  # (osConfig.age.secrets or { }) ? my-key, etc.
}
```
