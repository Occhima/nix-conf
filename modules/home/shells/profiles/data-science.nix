# home/profiles/data-science.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    python3
    python3Packages.numpy
    python3Packages.pandas
    python3Packages.matplotlib
    rustc
    cargo
  ];
}
