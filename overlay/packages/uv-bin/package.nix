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
  assetName = "uv-${platform}.tar.gz";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uv";
  version = release.version or "unstable";

  src = fetchurl {
    url = "https://github.com/astral-sh/uv/releases/download/${finalAttrs.version}/${assetName}";
    hash = release.hashes.${assetName};
  };

  buildInputs = lib.optional (!stdenv.isDarwin) stdenv.cc.cc;
  nativeBuildInputs = [ installShellFiles ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installBin uv uvx

    runHook postInstall
  '';

  # postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
  #   installShellCompletion --cmd uv \
  #     --bash <($out/bin/uv generate-shell-completion bash) \
  #     --fish <($out/bin/uv generate-shell-completion fish) \
  #     --zsh <($out/bin/uv generate-shell-completion zsh)
  # '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = binariesFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    outputFile = ./release.json;
    assetsPattern = ''^uv-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$'';
    allowPrereleases = true;
  };

  meta = {
    description = "An extremely fast Python package and project manager, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    downloadPage = "https://github.com/astral-sh/uv/releases";
    mainProgram = "uv";
    platforms = lib.attrNames systemToPlatform;
    maintainers = with lib.maintainers; [ mirkolenz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
})
