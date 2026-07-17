{ ... }:
{
  occhima.julia.homeManager = (
    {
      config,
      pkgs,
      ...
    }:
    let
      juliaPackages = [
        "LanguageServer"
        "SymbolServer"
      ];

      juliaEnv = pkgs.julia.withPackages juliaPackages;
    in
    {
      config = {
        home.packages = [
          juliaEnv
        ];
      };
    }
  );
}
