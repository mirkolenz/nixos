{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "picocss";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "picocss";
    repo = "pico";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fGQWYKCpprE9FvU7mbgxks41t8x7GsGvhkzVV95dgec=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r css scss $out/share/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = {
    description = "Minimal CSS Framework for semantic HTML";
    homepage = "https://github.com/picocss/pico";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    platforms = lib.platforms.all;
  };
})
