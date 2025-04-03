{
  python311Packages,
  writeShellApplication,
}:
writeShellApplication {
  name = "nixos-docs";

  runtimeInputs = with python311Packages; [
    mkdocs
    mkdocs-material
    # pymdownx
    # pymdown-extensions
    # python3Packages.pymdown-extensions
    # python3Packages.mkdocstrings
    # python3Packages.mkdocs-git-revision-date-localized-plugin
  ];

  text = ''
    #!/usr/bin/env bash
    echo "Starting MkDocs server..."
    cd "$FLAKE/docs"
    echo "Starting cleaning build ... "
    mkdocs serve
  '';
}
