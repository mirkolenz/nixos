{
  buildGoModule,
  fetchFromGitHub,
  fyne,
  lib,
}:
buildGoModule rec {
  pname = "janice";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ErikKalkoken";
    repo = "janice";
    tag = "v${version}";
    hash = "sha256-OUvOq93hRU4rh3To6VTS7iA/CXcXTtsSrsIrQDfVUiU=";
  };

  vendorHash = "sha256-fYlEhHarCru+LMcE+k/0XC6CpAlpH3nhCtNlinZDv4s=";

  ldflags = [
    "-s"
    "-w"
  ];

  inherit (fyne) buildInputs nativeBuildInputs;

  meta = {
    description = "A desktop app for viewing large JSON files";
    homepage = "https://github.com/ErikKalkoken/janice";
    downloadPage = "https://github.com/ErikKalkoken/janice/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "janice";
  };
}
