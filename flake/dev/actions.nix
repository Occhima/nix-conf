{
  inputs,
  ...
}:
{
  imports = [
    inputs.actions-nix.flakeModules.default
  ];

  flake.actions-nix = {
    pre-commit.enable = true;
    defaults = {
      jobs = {
        timeout-minutes = 120;
        runs-on = "ubuntu-latest";
      };
    };
    workflows = {
      ".github/workflows/ci.yml" = {
        name = "Flake Check";
        on = {
          push = { };
        };
        jobs = {
          scanning = {
            name = "GitGuardian scan";
            steps = [
              {
                name = "Checkout";
                uses = "actions/checkout@v4";
              }
              {
                name = "GitGuardian scan";
                uses = "GitGuardian/ggshield/actions/secret@v1.38.1";
                env = {
                  GITHUB_PUSH_BEFORE_SHA = "\${{ github.event.before }}";
                  GITHUB_PUSH_BASE_SHA = "\${{ github.event.base }}";
                  GITHUB_PULL_BASE_SHA = "\${{ github.event.pull_request.base.sha }}";
                  GITHUB_DEFAULT_BRANCH = "\${{ github.event.repository.default_branch }}";
                  GITGUARDIAN_API_KEY = "\${{ secrets.GITGUARDIAN_API_KEY }}";
                };
              }
            ];
          };
          # flake-check = {
          #   name = "Flake Check";
          #   steps = [
          #     {
          #       uses = "actions/checkout@v4";
          #     }
          #     {
          #       uses = "DeterminateSystems/nix-installer-action@main";
          #     }
          #     {
          #       uses = "DeterminateSystems/flakehub-cache-action@main";
          #     }
          #     {
          #       uses = "DeterminateSystems/flake-checker-action@main";
          #     }
          #     {
          #       run = "nix flake check";
          #     }
          #   ];
          # };
        };
      };
    };
  };
}
