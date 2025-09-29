{
  stdenvNoCC,
  undmg,
  makeBinaryWrapper,
  lib,
}:
args@{
  pname,
  appname ? pname,
  wrapperPath ? "",
  meta ? { },
  nativeBuildInputs ? [ ],
  ...
}:
stdenvNoCC.mkDerivation (
  (lib.removeAttrs args [
    "appname"
    "wrapperPath"
  ])
  // {
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
        makeBinaryWrapper "$out/Applications/${appname}.app/${wrapperPath}" "$out/bin/${pname}"
      ''}

      runHook postInstall
    '';

    nativeBuildInputs =
      nativeBuildInputs
      ++ [
        undmg
      ]
      ++ (lib.optional (wrapperPath != "") makeBinaryWrapper);

    meta = meta // {
      maintainers = with lib.maintainers; [ mirkolenz ];
      platforms = lib.platforms.darwin;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      mainProgram = pname;
    };
  }
)
