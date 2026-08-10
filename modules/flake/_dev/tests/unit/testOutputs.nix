# Evaluation contract tests: force the public outputs far enough to prove
# the composition holds, plus regression facts that catch unwanted behavior.
# Eval-only, no network, no builds — drvPaths are the regression gate.
{
  lib,
  self,
  ...
}:
let
  hosts = [
    "aerodynamic"
    "beyond"
    "crescendoll"
    "steammachine"
    "voyager"
  ];
  homeHosts = [
    "aerodynamic"
    "beyond"
    "crescendoll"
    "steammachine"
  ];
  isDrvPath = p: lib.isString (toString p) && lib.hasSuffix ".drv" (toString p);
  hostConfig = h: self.nixosConfigurations.${h}.config;
  home = self.homeConfigurations.occhima.config;
  quickshellSources = ../../../../home-manager/desktop/ui/themes/collection/guernica/targets/quickshell;
in
{
  # ── outputs evaluate ─────────────────────────────────────────────────────
  "every host evaluates its system drvPath" = {
    expr = lib.all (
      h:
      isDrvPath (
        if h == "voyager" then
          self.nixosConfigurations.${h}.config.system.build.isoImage.drvPath
        else
          self.nixosConfigurations.${h}.config.system.build.toplevel.drvPath
      )
    ) hosts;
    expected = true;
  };

  "standalone home evaluates its activationPackage drvPath" = {
    expr = isDrvPath self.homeConfigurations.occhima.activationPackage.drvPath;
    expected = true;
  };

  "host inventory is exactly the five hosts" = {
    expr = builtins.sort builtins.lessThan (builtins.attrNames self.nixosConfigurations);
    expected = hosts;
  };

  "standalone occhima home exists" = {
    expr = builtins.attrNames self.homeConfigurations;
    expected = [ "occhima" ];
  };

  "hosts wire the occhima home; voyager has none" = {
    expr =
      lib.all (h: self.nixosConfigurations.${h}.config.home-manager.users ? occhima) homeHosts
      && (self.nixosConfigurations.voyager.config.home-manager.users or { } == { });
    expected = true;
  };

  "crescendoll keeps its WSL behavior" = {
    expr = self.nixosConfigurations.crescendoll.config.wsl.enable;
    expected = true;
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

  "split hyprland fragments merge into one aspect" = {
    expr = home.wayland.windowManager.hyprland.enable;
    expected = true;
  };

  "niri is an alternate session on every physical workstation" = {
    expr = lib.all (host: (hostConfig host).programs.niri.enable) [
      "aerodynamic"
      "beyond"
      "steammachine"
    ];
    expected = true;
  };

  "desktop keeps the Home Manager niri config opt-in" = {
    expr = !(home.programs ? niri);
    expected = true;
  };

  "quickshell runtime and Guernica source stay decoupled" = {
    expr =
      home.programs.quickshell.enable
      && home.programs.quickshell.activeConfig == "guernica-ukishima"
      && builtins.attrNames home.programs.quickshell.configs == [ "guernica-ukishima" ];
    expected = true;
  };

  "Guernica quickshell variants are independently launchable source trees" = {
    expr = lib.all builtins.pathExists [
      "${quickshellSources}/configs/base/shell.qml"
      "${quickshellSources}/configs/base/data/Settings.qml"
      "${quickshellSources}/configs/base/components/bar/Workspaces.qml"
      "${quickshellSources}/configs/base/modules/Osd.qml"
      "${quickshellSources}/configs/ukishima/shell.qml"
      "${quickshellSources}/configs/ukishima/data/Settings.qml"
      "${quickshellSources}/configs/ukishima/components/bar/Workspaces.qml"
      "${quickshellSources}/configs/ukishima/components/island/CalendarPage.qml"
      "${quickshellSources}/configs/ukishima/components/island/PillIcon.qml"
      "${quickshellSources}/configs/ukishima/components/island/SystemPage.qml"
      "${quickshellSources}/configs/ukishima/components/dashboard/MediaCard.qml"
      "${quickshellSources}/configs/ukishima/components/notifications/NotificationCard.qml"
      "${quickshellSources}/configs/ukishima/components/quicksettings/VolumeSlider.qml"
      "${quickshellSources}/configs/ukishima/components/shared/CardFrame.qml"
      "${quickshellSources}/configs/ukishima/modules/Osd.qml"
      "${quickshellSources}/configs/ukishima/services/Pipewire.qml"
      "${quickshellSources}/configs/ukishima/services/Weather.qml"
    ];
    expected = true;
  };

  "compositor daemons stay scoped to their own sessions" = {
    expr =
      home.services.hyprpaper.systemdTarget == "hyprland-session.target"
      && home.services.hypridle.systemdTarget == "hyprland-session.target";
    expected = true;
  };

  "desktop keeps the existing locker stack" = {
    expr = home.programs.hyprlock.enable && !home.programs.swaylock.enable;
    expected = true;
  };

  "feature modules are exported through flake.modules" = {
    expr =
      self.modules.nixos ? workstation
      && self.modules.nixos ? gaming-workstation
      && self.modules.homeManager ? home-base
      && self.modules.homeManager ? quickshell-runtime
      && self.modules.homeManager ? themes-guernica-quickshell-base
      && self.modules.homeManager ? themes-guernica-quickshell-ukishima;
    expected = true;
  };

  "run-vm package is wired" = {
    expr = lib.isDerivation self.packages.x86_64-linux.run-vm;
    expected = true;
  };

  # ── regression facts ─────────────────────────────────────────────────────
  "emacs doom is selected; vanilla is not" = {
    expr =
      home.programs.emacs.package.version == "30.2"
      && home.xdg.configFile.doom.enable
      && !(lib.hasPrefix "emacs-with-packages" home.programs.emacs.package.name);
    expected = true;
  };

  "emacs daemon and default editor stay active" = {
    expr = home.services.emacs.enable && home.services.emacs.defaultEditor;
    expected = true;
  };

  "pentesting container is private with no password or autologin" = {
    expr =
      let
        c = hostConfig "steammachine";
        cc = c.containers.pentesting.config;
      in
      c.containers.pentesting.privateNetwork
      && (cc.services.getty.autologinUser or null) == null
      && (cc.users.users.rednix.initialPassword or null) == null
      && cc.services.openssh.settings.PermitRootLogin == "no"
      && !cc.services.openssh.settings.PasswordAuthentication;
    expected = true;
  };

  "electron-40.10.5 is not permitted" = {
    expr = lib.all (
      h:
      !(builtins.elem "electron-40.10.5" ((hostConfig h).nixpkgs.config.permittedInsecurePackages or [ ]))
    ) hosts;
    expected = true;
  };

  "flatpak nixos/hm composition stays active" = {
    expr = (hostConfig "aerodynamic").services.flatpak.enable && home.services.flatpak.uninstallUnused;
    expected = true;
  };

  "NH points at the current flake" = {
    expr =
      let
        shell = self.devShells.x86_64-linux.default;
      in
      shell.NH_FLAKE == "." && shell.NH_OS_FLAKE == "." && shell.FLAKE == ".";
    expected = true;
  };
}
