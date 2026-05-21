{
  lib,
  buildGoModule,
  git,
  gh,
  nix,
  nix-prefetch-github,
  makeWrapper,
}:
buildGoModule {
  pname = "update-packages";
  version = "0.1.0";

  src = ./.;

  vendorHash = "sha256-tvJNIzIV0/YDEWUXjUbZOLeePMKaAf7D02qd11hUSUY=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/update-packages \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          gh
          nix
          nix-prefetch-github
        ]
      }
  '';

  meta = {
    description = "update fetchFromGitHub packages in flake";
    mainProgram = "update-packages";
  };
}
