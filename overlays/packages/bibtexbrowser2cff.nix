{
  writeShellApplication,
  fetchFromGitHub,
  lib,
  php,
}:
let
  src = fetchFromGitHub {
    owner = "monperrus";
    repo = "bibtexbrowser";
    rev = "8fdc86f4bd4ebbce5740c8653620ba02aa51af73";
    hash = "sha256-kAaVi5GTgghfGD/B0Hw6aE6k1NFNSEFX/6G2/pVTCaY=";
  };
in
writeShellApplication {
  name = "bibtexbrowser2cff";
  text = ''
    exec ${lib.getExe php} ${src}/bibtex-to-cff.php "$@"
  '';
}
