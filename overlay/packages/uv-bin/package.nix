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
    x86_64-darwin = "x86_64-apple-darwin";
    aarch64-darwin = "aarch64-apple-darwin";
  };
in
mkGitHubBinary {
  owner = "astral-sh";
  repo = "uv";
  file = ./release.json;
  getAsset = { system, ... }: "uv-${platforms.${system}}.tar.gz";
  binaries = [
    "uv"
    "uvx"
  ];
  pattern = ''^uv-(aarch64|x86_64)-(unknown-linux-gnu|apple-darwin)\\.tar\\.gz$'';
  allowPrereleases = true;

  buildInputs = lib.optional (!stdenv.isDarwin) stdenv.cc.cc;

  # patchelf needs to run first, so we add a custom phase
  postPhases = [ "finalPhase" ];

  finalPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd uv \
      --bash <($out/bin/uv generate-shell-completion bash) \
      --fish <($out/bin/uv generate-shell-completion fish) \
      --zsh <($out/bin/uv generate-shell-completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "An extremely fast Python package and project manager, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    downloadPage = "https://github.com/astral-sh/uv/releases";
    platforms = lib.attrNames platforms;
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
}
