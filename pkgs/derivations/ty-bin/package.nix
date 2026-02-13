{
  lib,
  stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
mkGitHubBinary {
  owner = "astral-sh";
  repo = "ty";
  file = ./release.json;
  platforms = {
    x86_64-linux = "x86_64-unknown-linux-gnu";
    aarch64-linux = "aarch64-unknown-linux-gnu";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  getAsset = { platform, ... }: "ty-${platform}.tar.gz";
  allowPrereleases = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ stdenv.cc.cc ];

  # patchelf needs to run first, so we add a custom phase
  postPhases = [ "finalPhase" ];

  finalPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ty \
      --bash <($out/bin/ty generate-shell-completion bash) \
      --fish <($out/bin/ty generate-shell-completion fish) \
      --zsh <($out/bin/ty generate-shell-completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Extremely fast Python type checker and language server, written in Rust";
    license = lib.licenses.mit;
  };
}
