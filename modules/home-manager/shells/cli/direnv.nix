{ ... }:
{
  flake.modules.homeManager.direnv = (
    {
      config,
      ...
    }:
    {
      # Direnv is enabled when requested in tools list
      config = {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;

          stdlib = ''
            # Extend direnv's stdlib
            layout_poetry() {
              if [[ ! -f pyproject.toml ]]; then
                log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one.'
                exit 2
              fi

              local VENV=$(dirname $(poetry env info --path))
              if [[ -z $VENV || ! -d $VENV/bin ]]; then
                log_error 'No poetry virtual environment found. Use `poetry install` to create one.'
                exit 2
              fi

              export VIRTUAL_ENV=$VENV
              export POETRY_ACTIVE=1
              PATH_add "$VENV/bin"
            }
          '';

          config = {
            global = {
              warn_timeout = "10m";
              load_dotenv = true;
            };
          };
        };
      };
    }
  );
}
