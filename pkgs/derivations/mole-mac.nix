{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mole";
  version = "V1.16.1";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${finalAttrs.version}";
    hash = "sha256-zmc3o9Rt5yAIjz7aSbEPsuoOVkOEoHWcOhbeOzpbchY=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec

    cp -r bin lib $out/libexec/
    cp mole $out/libexec/
    # cp $finalAttrs.goHelpers/bin/* $out/libexec/bin/

    makeBinaryWrapper $out/libexec/mole $out/bin/mole
    makeBinaryWrapper $out/libexec/mole $out/bin/mo

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    # goHelpers = buildGoModule {
    #   pname = "mole-helpers";
    #   inherit (finalAttrs) version src;
    #   vendorHash = "";
    #   ldflags = [
    #     "-s"
    #     "-w"
    #   ];
    # };
  };

  meta = {
    description = "Deep clean and optimize your Mac";
    homepage = "https://github.com/tw93/Mole";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "mole";
    platforms = lib.platforms.darwin;
  };
})
