{
  lib,
  stdenv,
  openssl,
  versionCheckHook,
  mkGitHubBinary,
}:
let
  inherit (stdenv.hostPlatform) system;
  platforms = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    x86_64-darwin = "x86_64-apple-darwin";
    aarch64-darwin = "aarch64-apple-darwin";
  };
in
mkGitHubBinary {
  owner = "openai";
  repo = "codex";
  file = ./release.json;
  getAsset = { system, ... }: "codex-${platforms.${system}}.tar.gz";
  assetsPattern = ''^codex-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$'';
  versionPrefix = "rust-v";

  sourceRoot = ".";

  buildInputs = lib.optionals (!stdenv.isDarwin) [
    stdenv.cc.cc
    openssl
  ];

  preInstall = ''
    mv codex-${platforms.${system}} codex
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

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    downloadPage = "https://github.com/openai/codex/releases";
    platforms = lib.attrNames platforms;
    license = lib.licenses.asl20;
    githubActionsCheck = true;
  };
}
