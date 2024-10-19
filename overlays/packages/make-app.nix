{
  stdenvNoCC,
  unzip,
  undmg,
  makeWrapper,
  lib,
}:
args@{
  pname,
  appname ? pname,
  meta ? { },
  nativeBuildInputs ? [ ],
  ...
}:
stdenvNoCC.mkDerivation (
  {
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    sourceRoot = "${appname}.app";
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/${appname}.app"
      cp -R . "$out/Applications/${appname}.app"

      runHook postInstall
    '';
    # all of the following attributes need to removed from args
    nativeBuildInputs = nativeBuildInputs ++ [
      unzip
      undmg
      makeWrapper
    ];
    meta =
      with lib;
      {
        maintainers = with maintainers; [ mirkolenz ];
        platforms = platforms.darwin;
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        mainProgram = pname;
      }
      // meta;
  }
  // (lib.removeAttrs args [
    "nativeBuildInputs"
    "meta"
  ])
)
