# Adding a New User

A user is one Den aspect in `modules/den/aspects/users/<name>.nix`.

## 1. User aspect

`modules/den/aspects/users/alice.nix`:

```nix
{ config, den, ... }:
{
  den.aspects.alice = {
    nixos =
      { pkgs, ... }:
      {
        users.users.alice = {
          isNormalUser = true;
          initialPassword = "changeme";
          shell = pkgs.zsh;
          extraGroups = [ "wheel" ];
        };
      };

    homeManager = {
      imports = with config.flake.modules.homeManager; [ web dev ];
      home.username = "alice";
      home.homeDirectory = "/home/alice";
    };

    # grouping aspects from modules/den/aspects/home.nix
    includes = with den.aspects; [ home-base shell editors ];
  };
}
```

## 2. Use it

Add `users.alice = { };` to a host in `modules/den/hosts.nix`.

## 3. Standalone Home Manager (optional)

Add `den.homes.x86_64-linux.alice` in `modules/den/hosts.nix` to
publish `homeConfigurations.alice` for non-NixOS machines. Do **not**
fabricate an `osConfig`; modules needing host facts must declare
`osConfig ? { }`.
