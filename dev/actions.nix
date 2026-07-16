{
  inputs,
  ...
}:
{
  imports = [
    inputs.actions-nix.flakeModules.default
  ];

  flake.actions-nix = {
    pre-commit.enable = false;
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
          push = {
            branches = "[main]";
          };
          pull_request = { };
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
                uses = "GitGuardian/ggshield/actions/secret@main";
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
          flake-check = {
            name = "Flake Check";
            steps = [
              {
                uses = "actions/checkout@v4";
              }
              {
                uses = "DeterminateSystems/nix-installer-action@main";
              }
              {
                uses = "DeterminateSystems/flakehub-cache-action@main";
              }
              {
                uses = "DeterminateSystems/flake-checker-action@main";
              }
              {
                run = "nix flake check";
              }
            ];
          };
        };
      };
      ".github/workflows/update.yml" = {
        name = "Bump Flake Inputs";
        on = {
          workflow_dispatch = null;
          schedule = [ { cron = "0 1 * * 0"; } ];
        };
        permissions = { };
        jobs = {
          update-lockfile = {
            runs-on = "ubuntu-latest";
            permissions = {
              pull-requests = "write";
              contents = "write";
            };
            outputs = {
              pr = "\${{ steps.pr.outputs.pull-request-url }}";
              branch = "\${{ steps.pr.outputs.pull-request-branch }}";
            };
            steps = [
              {
                name = "Checkout";
                uses = "actions/checkout@v4";
                "with" = {
                  persist-credentials = false;
                };
              }
              {
                name = "Install Nix";
                uses = "DeterminateSystems/nix-installer-action@main";
              }
              {
                name = "Cache setup";
                uses = "DeterminateSystems/magic-nix-cache-action@main";
              }
              {
                name = "Update Lockfile";
                run = "nix flake update";
              }
              {
                name = "Create Pull request";
                id = "pr";
                uses = "peter-evans/create-pull-request@v7";
                "with" = {
                  title = "chore: update flake inputs";
                  commit-message = "chore: update flake inputs";
                  branch = "update-flake-inputs";
                  token = "\${{ github.token }}";
                };
              }
            ];
          };

          check = {
            name = "Check Flake";
            needs = [ "update-lockfile" ];
            runs-on = "ubuntu-latest";
            steps = [
              {
                uses = "actions/checkout@v4";
                "with" = {
                  ref = "\${{ needs.update-lockfile.outputs.branch }}";
                };
              }
              { uses = "DeterminateSystems/nix-installer-action@main"; }
              { uses = "DeterminateSystems/magic-nix-cache-action@main"; }
              { uses = "DeterminateSystems/flake-checker-action@main"; }
              { run = "nix flake check"; }
            ];
          };

          merge = {
            name = "Merge Pull Request";
            needs = [
              "update-lockfile"
              "check"
            ];
            runs-on = "ubuntu-latest";
            permissions = {
              pull-requests = "write";
              contents = "write";
            };
            steps = [
              {
                name = "Merge Pull Request";
                run = "gh pr merge --rebase --auto --delete-branch \"$PR\"";
                env = {
                  GH_TOKEN = "\${{ github.token }}";
                  PR = "\${{ needs.update-lockfile.outputs.pr }}";
                };
              }
            ];
          };
        };
      };
    };

  };
}
