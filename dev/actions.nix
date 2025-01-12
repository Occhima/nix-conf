{ inputs, config, ... }:
let inherit (inputs) nix-github-actions;
in {
  config.flake.githubActions = nix-github-actions.lib.mkGithubMatrix {

    inherit (config.flake) checks;

  };
}
