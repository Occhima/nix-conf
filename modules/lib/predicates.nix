# Small predicates shared between NixOS and Home Manager features.
# Only helpers with real consumers live here — new helpers earn their
# place by having one.
{ ... }:
let
  # True when the selected display stack is Wayland. The display aspects
  # (display-wayland / display-x11) publish this fact through
  # `modules.system.display.type`; features read it to adapt values.
  isWayland = config: (config.modules.system.display.type or "") == "wayland";

  # Filter a list of group names down to the ones that exist on the host.
  # stolen from: https://github.com/isabelroses/dotfiles/blob/main/modules/flake/lib/validators.nix
  ifTheyExist =
    config: groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  # `or false` also covers a null config (standalone HM passes osConfig = null).
  isPackageEnabled = config: program: config.programs.${program}.enable or false;

  # Programs not already enabled through HM or NixOS — avoids installing a
  # package twice when a `programs.*` module also ships it.
  ifPackageNotEnabled =
    config: osConfig: programs:
    builtins.filter (
      program: !(isPackageEnabled config program || isPackageEnabled osConfig program)
    ) programs;
in
{
  flake.lib.custom = {
    inherit
      isWayland
      ifTheyExist
      isPackageEnabled
      ifPackageNotEnabled
      ;
  };
}
