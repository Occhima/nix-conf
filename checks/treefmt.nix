{...}: {
  projectRootFile = "flake.nix";

  programs = {
    # Nix
    alejandra = {
      enable = false;
    };

    deadnix = {
      enable = false;
    };

    # Github Actions
    actionlint = {
      enable = true;
    };

    # Bash
    beautysh = {
      enable = false;
    };

    # TypeScript / JSON
    biome = {
      enable = true;
    };

    # YAML
    yamlfmt = {
      enable = false;
    };
  };
}
