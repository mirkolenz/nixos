{
  lib,
  stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
let
  platforms = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };
in
mkGitHubBinary {
  owner = "astral-sh";
  repo = "ruff";
  file = ./release.json;
  getAsset = { system, ... }: "ruff-${platforms.${system}}.tar.gz";
  pattern = ''^ruff-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$'';
  allowPrereleases = true;

  buildInputs = lib.optional (!stdenv.isDarwin) stdenv.cc.cc;

  # patchelf needs to run first, so we add a custom phase
  postPhases = [ "finalPhase" ];

  finalPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ruff \
      --bash <($out/bin/ruff generate-shell-completion bash) \
      --fish <($out/bin/ruff generate-shell-completion fish) \
      --zsh <($out/bin/ruff generate-shell-completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Extremely fast Python linter and code formatter, written in Rust";
    platforms = lib.attrNames platforms;
    license = lib.licenses.mit;
  };
}
