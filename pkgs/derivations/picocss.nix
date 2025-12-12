{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "picocss";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "picocss";
    repo = "pico";
    tag = "v${version}";
    hash = "sha256-fGQWYKCpprE9FvU7mbgxks41t8x7GsGvhkzVV95dgec=";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r css scss $out/

    runHook postInstall
  '';

  meta = {
    description = "Minimal CSS Framework for semantic HTML";
    homepage = "https://github.com/picocss/pico";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "picocss";
    platforms = lib.platforms.all;
  };
}
