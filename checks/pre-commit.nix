{...}: {
  check.enable = true;
  settings = {
    hooks = {
      actionlint.enable = true;
      beautysh.enable = true;
      check-added-large-files.enable = true;
      check-case-conflicts.enable = true;
      check-executables-have-shebangs.enable = true;
      check-shebang-scripts-are-executable.enable = false; # many of the scripts in the config aren't executable because they don't need to be.
      check-merge-conflicts.enable = true;
      detect-private-keys.enable = true;
      fix-byte-order-marker.enable = true;
      mixed-line-endings.enable = true;
      trim-trailing-whitespace.enable = true;
      end-of-file-fixer.enable = true;

      alejandra = {
        enable = true;
        excludes = ["modules" "hosts" "home"];
      };

      statix = {
        enable = false;
        excludes = ["modules" "hosts" "home"];
      };
    };
  };
}
