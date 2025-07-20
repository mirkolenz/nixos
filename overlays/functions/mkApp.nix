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

      mkdir -p "$out/Applications"
      cp -R "${appname}.app" "$out/Applications"

      ${lib.optionalString (wrapperPath != "") ''
        mkdir -p "$out/bin"
        makeWrapper "$out/Applications/${appname}.app/${wrapperPath}" "$out/bin/${pname}"
      ''}

      runHook postInstall
    '';
    # all of the following attributes need to removed from args
    nativeBuildInputs =
      nativeBuildInputs
      ++ [
        undmg
      ]
      ++ (lib.optional (wrapperPath != "") makeWrapper);
    meta = {
      maintainers = with lib.maintainers; [ mirkolenz ];
      platforms = lib.platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      mainProgram = pname;
    }
    // meta;
  }
  // (lib.removeAttrs args [
    "nativeBuildInputs"
    "meta"
  ])
)
