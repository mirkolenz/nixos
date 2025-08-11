{
  lib,
  fetchurl,
  stdenv,
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
  assetName = "ty-${platform}.tar.gz";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ty";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/astral-sh/ty/releases/download/${finalAttrs.version}/${assetName}";
    hash = release.hashes.${assetName};
  };

  buildInputs = lib.optional (!stdenv.isDarwin) stdenv.cc.cc;
  nativeBuildInputs = [ installShellFiles ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installBin ty

    runHook postInstall
  '';

  # patchelf needs to run first, so we add a custom phase
  postPhases = [ "finalPhase" ];

  finalPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ty \
      --bash <($out/bin/ty generate-shell-completion bash) \
      --fish <($out/bin/ty generate-shell-completion fish) \
      --zsh <($out/bin/ty generate-shell-completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = binariesFromGitHub {
    owner = "astral-sh";
    repo = "ty";
    outputFile = ./release.json;
    assetsPattern = ''^ty-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$'';
    allowPrereleases = true;
  };

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
