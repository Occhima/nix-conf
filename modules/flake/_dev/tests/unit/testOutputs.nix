{
  lib,
  self,
  ...
}:
let
  inherit (lib)
    all
    any
    attrNames
    attrValues
    concatMap
    count
    elem
    filter
    hasPrefix
    hasInfix
    hasSuffix
    unique
    ;

  hosts = attrNames self.nixosConfigurations;
  hostConfig = h: self.nixosConfigurations.${h}.config;

  installerHosts = [ "voyager" ];
  persistentHosts = filter (h: !(elem h installerHosts)) hosts;
  homeHosts = filter (h: ((hostConfig h).home-manager.users or { }) ? occhima) hosts;

  homeOf = h: (hostConfig h).home-manager.users.occhima;
  standaloneHome = self.homeConfigurations.occhima.config;
  homes = map homeOf homeHosts ++ [ standaloneHome ];

  isDrvPath = p: hasSuffix ".drv" (toString p);

  systemDrv =
    h:
    if elem h installerHosts then
      (hostConfig h).system.build.isoImage.drvPath
    else
      (hostConfig h).system.build.toplevel.drvPath;

  bindsOf = home: home.wayland.windowManager.hyprland.settings.bind or [ ];
  bindKey = b: if builtins.isString b then lib.head (lib.splitString "," b) else lib.head b._args;
  bindCommand =
    b:
    if builtins.isString b then
      b
    else
      let
        argument = lib.elemAt b._args 1;
      in
      if builtins.isAttrs argument then argument.expr or "" else toString argument;

  duplicateKeys =
    home:
    let
      keys = map bindKey (bindsOf home);
    in
    filter (k: count (x: x == k) keys > 1) (unique keys);

  userServices = home: attrValues home.systemd.user.services;
  execStarts = home: concatMap (s: lib.toList (s.Service.ExecStart or [ ])) (userServices home);
  wantedBy = service: service.Install.WantedBy or [ ];

  diskoHosts = filter (h: self.diskoConfigurations ? ${h}) hosts;
  layoutValues =
    key: value:
    if builtins.isList value then
      concatMap (layoutValues key) value
    else if lib.isAttrs value && !(value ? outPath) then
      lib.optional (builtins.isString (value.${key} or null)) value.${key}
      ++ concatMap (layoutValues key) (attrValues value)
    else
      [ ];
  mountpointsOf = h: unique (layoutValues "mountpoint" self.diskoConfigurations.${h});
  contentTypesOf = h: unique (layoutValues "type" self.diskoConfigurations.${h});
in
{
  "every host evaluates its system drvPath" = {
    expr = all (h: isDrvPath (systemDrv h)) hosts;
    expected = true;
  };

  "every home-enabled host evaluates occhima's activation drvPath" = {
    expr = all (h: isDrvPath (homeOf h).home.activationPackage.drvPath) homeHosts;
    expected = true;
  };

  "standalone home evaluates its activationPackage drvPath" = {
    expr = isDrvPath self.homeConfigurations.occhima.activationPackage.drvPath;
    expected = true;
  };

  "exported packages evaluate to drvPaths" = {
    expr = all isDrvPath [
      self.packages.x86_64-linux.nvim.drvPath
      self.packages.x86_64-linux.run-vm.drvPath
    ];
    expected = true;
  };

  "hyprland keybinds are collision free" = {
    expr = concatMap duplicateKeys homes;
    expected = [ ];
  };

  "island keybinds drive the quickshell config the session starts" = {
    expr = all (
      home:
      let
        active = home.programs.quickshell.activeConfig;
        islandBinds = filter (c: hasInfix "ipc call guernica-island" c) (map bindCommand (bindsOf home));
        serviceStarts = filter (c: hasInfix "quickshell" c) (execStarts home);
      in
      home.programs.quickshell.configs ? ${active}
      && islandBinds != [ ]
      && all (c: hasInfix "-c ${active}" c) islandBinds
      && all (c: hasInfix "--config ${active}" c) serviceStarts
    ) homes;
    expected = true;
  };

  "one status bar owns the session" = {
    expr = all (home: home.programs.quickshell.enable -> !home.programs.waybar.enable) homes;
    expected = true;
  };

  "one notification daemon owns the session" = {
    expr = all (
      home:
      let
        backend = home.modules.desktop.notifications.backend;
      in
      (backend == "quickshell") != (home.services.mako.enable or false)
    ) homes;
    expected = true;
  };

  "one screen locker is enabled" = {
    expr = all (
      home: (home.programs.hyprlock.enable or false) != (home.programs.swaylock.enable or false)
    ) homes;
    expected = true;
  };

  "session-scoped units only target a compositor that is enabled" = {
    expr = all (
      home:
      all (
        service:
        elem "hyprland-session.target" (wantedBy service) -> home.wayland.windowManager.hyprland.enable
      ) (userServices home)
    ) homes;
    expected = true;
  };

  "compositor daemons follow the compositor session, not the generic one" = {
    expr = all (
      home:
      home.services.hyprpaper.systemdTarget == "hyprland-session.target"
      && home.services.hypridle.systemdTarget == "hyprland-session.target"
    ) homes;
    expected = true;
  };

  "user services launch absolute store paths" = {
    expr = all (home: all (cmd: hasPrefix "/nix/store/" cmd) (execStarts home)) homes;
    expected = true;
  };

  "the island ships the icon font it renders with" = {
    expr = all (
      home:
      home.programs.quickshell.enable -> any (p: (p.pname or "") == "material-symbols") home.home.packages
    ) homes;
    expected = true;
  };

  "EDITOR resolves to a store path backed by the emacs daemon" = {
    expr = all (
      home:
      hasPrefix "/nix/store/" (home.home.sessionVariables.EDITOR or "")
      && home.services.emacs.enable
      && home.services.emacs.defaultEditor
    ) homes;
    expected = true;
  };

  "persistent hosts declare a bootloader, a root and an ESP" = {
    expr = all (
      h:
      let
        c = hostConfig h;
        bootable = c.boot.loader.grub.enable || c.boot.loader.systemd-boot.enable;
      in
      if c.wsl.enable or false then
        !bootable
      else
        bootable && c.fileSystems ? "/" && c.fileSystems ? "/boot"
    ) persistentHosts;
    expected = true;
  };

  "disko layouts are mounted by the hosts that use them" = {
    expr = all (
      h:
      let
        c = hostConfig h;
        encrypted = elem "luks" (contentTypesOf h);
      in
      all (m: c.fileSystems ? ${m}) (mountpointsOf h)
      && (encrypted -> (c.boot.initrd.luks.devices or { }) != { })
    ) diskoHosts;
    expected = true;
  };

  "ssh stays key-only on persistent hosts" = {
    expr = all (
      h:
      let
        ssh = (hostConfig h).services.openssh;
      in
      ssh.enable -> (ssh.settings.PermitRootLogin == "no" && !ssh.settings.PasswordAuthentication)
    ) persistentHosts;
    expected = true;
  };

  "the pentesting container is private, with no password or autologin" = {
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

  "no host reopens an insecure electron" = {
    expr = all (
      h:
      !(any (p: hasPrefix "electron-" p) ((hostConfig h).nixpkgs.config.permittedInsecurePackages or [ ]))
    ) hosts;
    expected = true;
  };

  "flatpak in home requires the system service on the same host" = {
    expr = all (
      h: (homeOf h).services.flatpak.enable -> (hostConfig h).services.flatpak.enable
    ) homeHosts;
    expected = true;
  };

  "the WSL host stays headless" = {
    expr =
      let
        c = hostConfig "crescendoll";
      in
      c.wsl.enable && !c.services.xserver.enable && !(c.services.displayManager.sddm.enable or false);
    expected = true;
  };

  "the dev shell points nh at this flake" = {
    expr =
      let
        shell = self.devShells.x86_64-linux.default;
      in
      shell.NH_FLAKE == "." && shell.NH_OS_FLAKE == "." && shell.FLAKE == ".";
    expected = true;
  };
}
