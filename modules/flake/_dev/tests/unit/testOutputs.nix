# Evaluation-level contract tests: these force the public outputs far
# enough to prove the dendritic composition actually merges — hosts,
# standalone Home Manager, split Hyprland/Nixvim fragments, disko,
# per-aspect exports. Eval-only: nothing is built.
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
  "every host evaluates to a system derivation" = {
    expr = lib.all (h: isDrvPath self.nixosConfigurations.${h}.config.system.build.toplevel.drvPath) hosts;
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
    expr = isDrvPath self.homeConfigurations.occhima.activationPackage.drvPath;
    expected = true;
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

  "the occhima aspect library is exported through den" = {
    expr =
      self.denful ? occhima
      && self.denful.occhima ? workstation
      && self.denful.occhima ? gaming-workstation;
    expected = true;
  };

  "hosts wire the occhima home through den" = {
    expr = self.nixosConfigurations.steammachine.config.home-manager.users ? occhima;
    expected = true;
  };
}
