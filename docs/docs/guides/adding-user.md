# Adding a New User

Users are aspects, split across three small files under
`modules/users/<name>/`.

## 1. NixOS account aspect

`modules/users/alice/account.nix`:

```nix
{ config, ... }:
let
  aliceHome = config.flake.modules.homeManager.alice;
in
{
  flake.modules.nixos.user-alice =
    { pkgs, ... }:
    {
      users.users.alice = {
        isNormalUser = true;
        initialPassword = "changeme";
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
      };

      home-manager.users.alice.imports = [ aliceHome ];
    };
}
```

## 2. Home Manager aspect

`modules/users/alice/home.nix` — compose the environment from named HM
aspects:

```nix
{ config, ... }:
{
  config.flake.modules.homeManager.alice = {
    imports = with config.flake.modules.homeManager; [
      home-base
      shell-zsh
      cli-core
      cli-git
      # …
    ];
    config = {
      home.username = "alice";
      home.homeDirectory = "/home/alice";
    };
  };
}
```

## 3. Use it

Add `user-alice` to a host's imports. Importing the aspect creates the
account — there is no `enabledUsers` list.

## 4. Standalone Home Manager (optional)

Mirror `modules/users/occhima/standalone.nix` to publish
`homeConfigurations.alice` for non-NixOS machines. Do **not** fabricate an
`osConfig`; modules needing host facts must declare `osConfig ? { }`.
