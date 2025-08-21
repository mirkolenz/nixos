{
  lib,
  fetchurl,
  stdenv,
  openssl,
  autoPatchelfHook,
  versionCheckHook,
  binariesFromGitHub,
  installShellFiles,
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
  assetName = "codex-${platform}.tar.gz";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codex";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/${assetName}";
    hash = release.hashes.${assetName};
  };

  sourceRoot = ".";

  buildInputs = lib.optionals (!stdenv.isDarwin) [
    stdenv.cc.cc
    openssl
  ];
  nativeBuildInputs = [ installShellFiles ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mv codex-${platform} codex
    installBin codex

    runHook postInstall
  '';

  # patchelf needs to run first, so we add a custom phase
  postPhases = [ "finalPhase" ];

  finalPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = binariesFromGitHub {
    owner = "openai";
    repo = "codex";
    outputFile = ./release.json;
    assetsPattern = ''^codex-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$'';
    versionPrefix = "rust-v";
  };

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    downloadPage = "https://github.com/openai/codex/releases";
    mainProgram = "codex";
    platforms = lib.attrNames systemToPlatform;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
  };
})
