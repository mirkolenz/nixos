{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation {
  name = "bibtexbrowser";
  src = fetchFromGitHub {
    owner = "monperrus";
    repo = "bibtexbrowser";
    rev = "cf3ad2170062005132b36da6d6eb5a8bddcb6a74";
    hash = "sha256-vCLu37F0oqBZdG5SXijScbGEEjRjQ+z2R30DT6Rso0w=";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/* $out/

    runHook postInstall
  '';
  meta = {
    description = "Beautiful publication lists with bibtex and PHP";
    homepage = "www.monperrus.net/martin/bibtexbrowser/";
    downloadPage = "https://github.com/monperrus/bibtexbrowser/commits/master/";
    platforms = with lib.platforms; darwin ++ linux;
    maintainers = with lib.maintainers; [ mirkolenz ];
  };
}
