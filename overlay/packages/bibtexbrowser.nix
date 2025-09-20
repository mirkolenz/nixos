{
  stdenv,
  fetchFromGitHub,
  lib,
  nix-update-script,
  php,
  writeShellApplication,
}:
stdenv.mkDerivation (finalAttrs: {
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

  passthru = {
    updateScript = nix-update-script { };
    bibtex2cff = writeShellApplication {
      name = "bibtex2cff";
      text = ''
        exec ${lib.getExe php} ${finalAttrs.finalPackage}/bibtex-to-cff.php "$@"
      '';
      meta = finalAttrs.meta // {
        platforms = php.meta.platforms;
      };
    };
  };

  meta = {
    description = "Beautiful publication lists with bibtex and PHP";
    homepage = "www.monperrus.net/martin/bibtexbrowser/";
    downloadPage = "https://github.com/monperrus/bibtexbrowser/releases/tag/latest";
    maintainers = with lib.maintainers; [ mirkolenz ];
    githubActionsCheck = true;
  };
})
