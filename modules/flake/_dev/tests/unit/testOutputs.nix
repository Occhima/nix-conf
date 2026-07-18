# Evaluation-level contract tests: these force the public outputs far
# enough to prove the dendritic composition actually merges — hosts,
# standalone Home Manager, split Hyprland/Nixvim fragments, disko,
# per-feature module exports. Eval-only: nothing is built.
#
# We deliberately do NOT force `system.build.toplevel.drvPath` /
# `activationPackage.drvPath`. Some packages in these closures use
# import-from-derivation (e.g. `julia.withPackages` resolves its registry
# via IFD), and computing those drvPaths realises the IFD mid-evaluation —
# which the sandboxed `nix flake check` evaluator cannot do. Forcing a
# resolved option instead proves the module tree composed and evaluated
# without building anything; the specific-fact tests below carry the
# coverage that the merge produced the right values.
{ lib, self, ... }:
let
  hosts = [
    "aerodynamic"
    "beyond"
    "crescendoll"
    "steammachine"
    "voyager"
  ];
  isDrvPath = p: lib.isString (toString p) && lib.hasSuffix ".drv" (toString p);
in
{
  "every host evaluates its NixOS module tree" = {
    expr = lib.all (
      h: builtins.isString self.nixosConfigurations.${h}.config.networking.hostName
    ) hosts;
    expected = true;
  };

  "crescendoll keeps its WSL behavior" = {
    expr = self.nixosConfigurations.crescendoll.config.wsl.enable;
    expected = true;
  };

  "voyager evaluates as an installer ISO" = {
    expr = isDrvPath self.nixosConfigurations.voyager.config.system.build.isoImage.drvPath;
    expected = true;
  };

  "standalone home-manager evaluates without a fabricated osConfig" = {
    expr = self.homeConfigurations.occhima.config.home.username;
    expected = "occhima";
  };

  "split hyprland fragments merge into one aspect" = {
    expr = self.homeConfigurations.occhima.config.wayland.windowManager.hyprland.enable;
    expected = true;
  };

  "hosts publish the wayland display fact" = {
    expr = self.nixosConfigurations.steammachine.config.modules.system.display.type;
    expected = "wayland";
  };

  "disko layouts are published per host" = {
    expr = builtins.sort builtins.lessThan (builtins.attrNames self.diskoConfigurations);
    expected = [
      "aerodynamic"
      "beyond"
      "face2face"
      "steammachine"
    ];
  };

  "split nixvim fragments evaluate to the nvim package" = {
    expr = lib.isDerivation self.packages.x86_64-linux.nvim;
    expected = true;
  };

  "expected packages are wired" = {
    expr = lib.all (n: self.packages.x86_64-linux ? ${n}) [
      "run-vm"
      "scripts"
      "install-tools"
      "docs"
      "nyxt-source"
      "antigravity"
      "jcode"
      "ampcode"
      "update-packages"
      "codegraph"
      "feynman"
    ];
    expected = true;
  };

  "feature modules are exported through flake.modules" = {
    expr =
      self.modules.nixos ? workstation
      && self.modules.nixos ? gaming-workstation
      && self.modules.homeManager ? home-base;
    expected = true;
  };

  "hosts wire the occhima home through den" = {
    expr = self.nixosConfigurations.steammachine.config.home-manager.users ? occhima;
    expected = true;
  };
}
