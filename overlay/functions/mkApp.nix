{
  stdenvNoCC,
  undmg,
  makeWrapper,
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
        makeWrapper "$out/Applications/${appname}.app/${wrapperPath}" "$out/bin/${pname}"
      ''}

      runHook postInstall
    '';

    nativeBuildInputs =
      nativeBuildInputs
      ++ [
        undmg
      ]
      ++ (lib.optional (wrapperPath != "") makeWrapper);

    meta = meta // {
      maintainers = with lib.maintainers; [ mirkolenz ];
      platforms = lib.platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      mainProgram = pname;
    };
  }
)
