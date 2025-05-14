{
  buildGoModule,
  fetchFromGitHub,
  fyne,
  lib,
}:
buildGoModule rec {
  pname = "janice";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ErikKalkoken";
    repo = "janice";
    tag = "v${version}";
    hash = "sha256-zd8CHisCDP1Bk5qf9dmHfmnNCnPFHkCPGqSPMLCw76g=";
  };

  vendorHash = "sha256-rNL3eMWaT+Q+NoutUDvD9Gs9SM0B6s95P88ynsRp1GQ=";

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
