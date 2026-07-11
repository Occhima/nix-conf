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

  isPackageEnabled =
    config: program: hasAttr program config.programs && config.programs.${program}.enable;

  ifPackageNotEnabled =
    config: osConfig: programs:
    filter (program: !(isPackageEnabled config program || isPackageEnabled osConfig program)) programs;

  hasProfile = conf: list: any (profile: builtins.elem profile conf.modules.profiles.active) list;
}
