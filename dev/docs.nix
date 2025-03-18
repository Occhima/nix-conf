{ inputs, ... }:
{

  imports = [
    inputs.mkdocs-flake.flakeModule
  ];

  perSystem =
    { ... }:
    {
      documentation.mkdocs-root = ./docs;
    };

}
