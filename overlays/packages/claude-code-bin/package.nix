{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  makeWrapper,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  gcsBucket = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  manifest = lib.importJSON ./manifest.json;
  systemToPlatform = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };
  platform = systemToPlatform.${system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-code";
  version = manifest.version or "unstable";

  src = fetchurl {
    url = "${gcsBucket}/${finalAttrs.version}/${platform}/claude";
    hash = manifest.hashes.${platform};
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ (lib.optional (!stdenvNoCC.isDarwin) autoPatchelfHook);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D $src $out/bin/claude
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/claude";
  versionCheckProgramArg = "--version";
  doInstallCheck = false; # tries to open $HOME/.claude.json

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    changelog = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "claude";
    platforms = lib.attrNames systemToPlatform;
  };
})
