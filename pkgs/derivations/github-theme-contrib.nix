{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "github-theme-contrib";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "projekt0n";
    repo = "github-theme-contrib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MKB9JtU6Gv16ma7S9J7n1QCjAiJhBrD0mUHum+blJOs=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r themes $out/share/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = {
    description = "GitHub's themes ports and extras";
    homepage = "https://github.com/projekt0n/github-theme-contrib";
    downloadPage = "https://github.com/projekt0n/github-theme-contrib/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
  };
})
