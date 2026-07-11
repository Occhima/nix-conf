_: {
  flake.templates = {
    monorepo = {
      path = ../../templates/monorepo;
      description = "Data science/ML monorepo with UV workspace, Python 3.12, Marimo notebooks, and Nix flake-parts";
    };

    academic = {
      path = ../../templates/academic;
      description = "Academic research monorepo with UV workspace, LaTeX thesis, Python research packages, and Nix flake-parts";
    };

    agents-project = {
      path = ../../templates/agents-project;
      description = "Agents based software engineering project";
    };

  };
}
