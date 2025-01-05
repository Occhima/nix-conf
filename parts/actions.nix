{ localFlake }:
{ lib, config, ... }:
with lib;
let
  inherit (localFlake.inputs) github-actions;

  addJobName = m:
    m // {
      matrix.include = map (job:
        job // {
          name = strings.removePrefix "githubActions.checks." job.attr;
        }) m.matrix.include;
    };
in {
  _file = ./actions.nix;

  options.rosetta.githubActionsMatrix = mkOption { type = types.unspecified; };

  config.rosetta.githubActionsMatrix = addJobName
    (github-actions.lib.mkGithubMatrix {
      # Architecture -> Github Runner label mappings
      platforms = { x86_64-linux = "ubuntu-latest"; };

      inherit (config.flake) checks;
    });
}
