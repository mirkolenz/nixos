{
  lib,
  stdenv,
  openssl,
  libcap,
  zlib,
  versionCheckHook,
  mkGitHubBinary,
}:
let
  inherit (stdenv.hostPlatform) system;
  platforms = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };
in
mkGitHubBinary {
  owner = "openai";
  repo = "codex";
  file = ./release.json;
  inherit platforms;
  getAsset = { platform, ... }: "codex-${platform}.tar.gz";
  versionRegex = "rust-v(.+)";

  sourceRoot = ".";

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    stdenv.cc.cc
    openssl
    libcap
    zlib
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
  doInstallCheck = true;

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    license = lib.licenses.asl20;
  };
}
