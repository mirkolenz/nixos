{
  lib,
  # stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
let
  platforms = {
    x86_64-linux = "x86_64-unknown-linux-musl";
    aarch64-linux = "aarch64-unknown-linux-musl";
    aarch64-darwin = "aarch64-apple-darwin";
  };
in
mkGitHubBinary {
  owner = "typst";
  repo = "typst";
  file = ./release.json;
  versionPrefix = "v";
  getAsset = { system, ... }: "typst-${platforms.${system}}.tar.xz";
  pattern = ''^typst-(aarch64|x86_64)-(unknown-linux-musl|apple-darwin)\\.tar\\.xz$'';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "New markup-based typesetting system that is powerful and easy to learn";
    platforms = lib.attrNames platforms;
    license = lib.licenses.asl20;
  };
}
