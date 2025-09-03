{
  stdenv,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "bibtexbrowser";
  version = "latest";
  src = fetchFromGitHub {
    owner = "monperrus";
    repo = "bibtexbrowser";
    rev = "fbbf95f8a4085d81157ae0df58506b92e4a40b58";
    hash = "sha256-CUnVkuoFLZkYM8fcHTemN/a66LycAH6LOWqNSZXgIeI=";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/* $out/

    runHook postInstall
  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Beautiful publication lists with bibtex and PHP";
    homepage = "www.monperrus.net/martin/bibtexbrowser/";
    downloadPage = "https://github.com/monperrus/bibtexbrowser/releases/tag/latest";
    maintainers = with lib.maintainers; [ mirkolenz ];
    githubActionsCheck = true;
  };
}
