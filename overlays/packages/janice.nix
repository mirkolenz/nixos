{
  buildGoModule,
  fetchFromGitHub,
  fyne,
  lib,
}:
buildGoModule rec {
  pname = "janice";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ErikKalkoken";
    repo = "janice";
    tag = "v${version}";
    hash = "sha256-KVyGa7/1HAViWzTnXhcnc1U1nOubHLYOTy+vwA6F1Qw=";
  };

  vendorHash = "sha256-6wrgWuv64KLrRzGfINDNUxBD0r0rTIoA955kPZHOKIM=";

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
