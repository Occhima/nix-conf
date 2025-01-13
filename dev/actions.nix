{ inputs, lib, config, ... }:
let inherit (inputs) nix-github-actions;
in {
  config.flake.githubActions = nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs [ "x86_64-linux" ] config.flake.checks;
  };
}
