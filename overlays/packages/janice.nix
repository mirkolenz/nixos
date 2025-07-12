{
  buildGoModule,
  fetchFromGitHub,
  fyne,
  lib,
  nix-update-script,
}:
buildGoModule rec {
  pname = "janice";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ErikKalkoken";
    repo = "janice";
    tag = "v${version}";
    hash = "sha256-SWs8HX8yzxFxU9wQbwoRU6JUGGySnvtV5iZbOcl7kl0=";
  };

  vendorHash = "sha256-rNL3eMWaT+Q+NoutUDvD9Gs9SM0B6s95P88ynsRp1GQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  inherit (fyne) buildInputs nativeBuildInputs;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A desktop app for viewing large JSON files";
    homepage = "https://github.com/ErikKalkoken/janice";
    downloadPage = "https://github.com/ErikKalkoken/janice/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "janice";
  };
}
