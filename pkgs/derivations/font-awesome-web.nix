{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-awesome-web";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "FortAwesome";
    repo = "Font-Awesome";
    tag = finalAttrs.version;
    hash = "sha256-1hHjqPXz/+otqgRsfXQG4D3uAmKOzXo2eBqOUzSU8IM=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r css webfonts js svgs $out/share/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = {
    description = "Font Awesome web assets (CSS and webfonts)";
    homepage = "https://github.com/FortAwesome/Font-Awesome";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ mirkolenz ];
    platforms = lib.platforms.all;
  };
})
