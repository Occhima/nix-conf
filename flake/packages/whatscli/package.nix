{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "whatscli";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "normen";
    repo = "whatscli";
    rev = "v${version}";
    hash = "sha256-hluIyeVnz0uVUDvzgKUIha6A4VcgRDyG3BESONABV0Y=";
  };

  vendorHash = lib.fakeHash;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  meta = with lib; {
    description = "CLI for communicating with users via WhatsApp";
    homepage = "https://github.com/normen/whatscli";
    changelog = "https://github.com/normen/whatscli/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "whatscli";
    maintainers = [ ];
  };
}
