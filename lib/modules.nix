{ lib }:
rec {

  kebabCaseToCamelCase = builtins.replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

  listNixFilesRecursiveToAttrs =
    dir:
    lib.pipe dir [
      lib.filesystem.listFilesRecursive
      (builtins.filter (lib.hasSuffix ".nix"))
      (builtins.filter (x: !lib.hasSuffix "interface.nix" x))
      (map (value: {
        name = lib.pipe value [
          toString
          (lib.removePrefix "${toString dir}/")
          (lib.removeSuffix "/default.nix")
          (lib.removeSuffix ".nix")
          kebabCaseToCamelCase
          (builtins.replaceStrings [ "/" ] [ "-" ])
        ];
        inherit value;
      }))
      builtins.listToAttrs
    ];

  modulesFromDir =
    dir:
    lib.pipe dir [
      listNixFilesRecursiveToAttrs
      (modules: modules // { })
    ];

}
