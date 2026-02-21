{
  stdenvNoCC,
  makeBinaryWrapper,
  lib,
}:
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [
    "appname"
    "wrapperPath"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      # custom
      appname ? finalAttrs.pname,
      wrapperPath ? "",
      # upstream
      nativeBuildInputs ? [ ],
      meta ? { },
      ...
    }:
    {
      installPhase = ''
        runHook preInstall

        mkdir -p "$out/Applications"
        cp -R "${appname}.app" "$out/Applications"

        ${lib.optionalString (wrapperPath != "") ''
          mkdir -p "$out/bin"
          makeBinaryWrapper "$out/Applications/${appname}.app/${wrapperPath}" "$out/bin/${finalAttrs.pname}"
        ''}

        runHook postInstall
      '';

      dontConfigure = true;
      dontBuild = true;
      strictDeps = true;

      nativeBuildInputs = nativeBuildInputs ++ lib.optionals (wrapperPath != "") [ makeBinaryWrapper ];

      meta = {
        maintainers = with lib.maintainers; [ mirkolenz ];
        platforms = lib.platforms.darwin;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      }
      // (lib.optionalAttrs (wrapperPath != "") { mainProgram = finalAttrs.pname; })
      // meta;
    };
}
