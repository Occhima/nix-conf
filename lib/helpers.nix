# Small helpers used inside NixOS and Home Manager modules.
_:
let
  inherit (builtins) filter hasAttr any;
in
rec {
  # Check if the system is using Wayland based on the configuration
  isWayland = config: (config.modules.system.display.type or "") == "wayland";

  # stolen from: https://github.com/isabelroses/dotfiles/blob/main/modules/flake/lib/validators.nix
  ifTheyExist = config: groups: filter (group: hasAttr group config.users.groups) groups;

  # Tolerates a null/absent config (standalone home-manager passes
  # osConfig = null).
  isPackageEnabled = config: program: config.programs.${program}.enable or false;

  ifPackageNotEnabled =
    config: osConfig: programs:
    filter (program: !(isPackageEnabled config program || isPackageEnabled osConfig program)) programs;

  hasProfile = conf: list: any (profile: builtins.elem profile conf.modules.profiles.active) list;
}
