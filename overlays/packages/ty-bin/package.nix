{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  versionCheckHook,
}:
let
  inherit (stdenv.hostPlatform) system;
  release = lib.importJSON ./release.json;
  systemToPlatform = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    x86_64-darwin = "x86_64-apple-darwin";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  platform = systemToPlatform.${system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ty";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/astral-sh/ty/releases/download/${finalAttrs.version}/ty-${platform}.tar.gz";
    hash = release.hashes."ty-${platform}.tar.gz";
  };

  buildInputs = lib.optional (!stdenv.isDarwin) (lib.getLib stdenv.cc.cc);

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D ty $out/bin/ty

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An extremely fast Python type checker and language server, written in Rust";
    homepage = "https://github.com/astral-sh/ty";
    downloadPage = "https://github.com/astral-sh/ty/releases";
    mainProgram = "ty";
    platforms = lib.attrNames systemToPlatform;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
  };
})
