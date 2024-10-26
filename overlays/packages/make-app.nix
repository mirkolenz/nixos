{
  stdenvNoCC,
  undmg,
  makeWrapper,
  lib,
}:
args@{
  pname,
  appname ? pname,
  meta ? { },
  nativeBuildInputs ? [ ],
  wrapperPath ? "",
  ...
}:
stdenvNoCC.mkDerivation (
  {
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/${appname}.app"
      cp -R . "$out/Applications/${appname}.app"

      ${lib.optionalString (wrapperPath != "") ''
        mkdir -p "$out/bin"
        makeWrapper "$out/Applications/${appname}.app/${wrapperPath}" "$out/bin/${pname}"
      ''}

      runHook postInstall
    '';
    # all of the following attributes need to removed from args
    nativeBuildInputs = nativeBuildInputs ++ [
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
