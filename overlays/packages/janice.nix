{
  buildGoModule,
  fetchFromGitHub,
  fyne,
  lib,
}:
buildGoModule rec {
  pname = "janice";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ErikKalkoken";
    repo = "janice";
    tag = "v${version}";
    hash = "sha256-g9v6f1znQLrM0dImw9rDaCREjIt0bSezubkhBvjoEFE=";
  };

  vendorHash = "sha256-OeKGDrL6iKGk+RQiQhIJ8Uoi5JeAvW1J9lvTdJ/2YEo=";

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
