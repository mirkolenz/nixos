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
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-code";
  version = "1.0.48";
  # prefetch-attrs .#claude-code-bin.passthru.urls

  passthru = {
    # claude.ai/install.sh
    urls = {
      aarch64-darwin = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${finalAttrs.version}/darwin-arm64/claude";
      aarch64-linux = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${finalAttrs.version}/linux-arm64/claude";
      x86_64-darwin = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${finalAttrs.version}/darwin-x64/claude";
      x86_64-linux = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${finalAttrs.version}/linux-x64/claude";
    };
    hashes = {
      aarch64-darwin = "sha256-KTRgJXmVEaDO/gCdXOdHaXLuHjw6ome+d54s1TZS+80=";
      aarch64-linux = "sha256-AnNgIMAdb64yOeTjqtojP4k7Fs8aIvZMKsleSFnG5gk=";
      x86_64-darwin = "sha256-eFZcKnyznbp8u73o8l3noh8lMNzckZzi0hnamb09qIM=";
      x86_64-linux = "sha256-EG6S7cv4pnYgWxjsQO3im84crmXEnoC5gkXsvU936YI=";
    };
  };

  src = fetchurl {
    url = finalAttrs.passthru.urls.${system};
    hash = finalAttrs.passthru.hashes.${system};
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ] ++ (lib.optional (!stdenvNoCC.isDarwin) autoPatchelfHook);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 -D $src $out/bin/claude

    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/claude";
  versionCheckProgramArg = "--version";
  doInstallCheck = false; # tries to open $HOME/.claude.json

  meta = {
    description = "An agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    changelog = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "claude";
    platforms = lib.attrNames finalAttrs.passthru.urls;
  };
})
