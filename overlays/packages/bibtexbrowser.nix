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
    rev = "4cdfb81a64e836fb7225e29258bea0258889dd17";
    hash = "sha256-OwRtRiXNzQUVxc6NFnrSXZp94D2viAnCJoZ0ySplS5Q=";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/* $out/

    runHook postInstall
  '';
  meta = with lib; {
    description = "Beautiful publication lists with bibtex and PHP";
    homepage = "www.monperrus.net/martin/bibtexbrowser/";
    downloadPage = "https://github.com/monperrus/bibtexbrowser/commits/master/";
    maintainers = with maintainers; [ mirkolenz ];
  };
}
