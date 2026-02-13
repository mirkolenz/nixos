{
  lib,
  # stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
mkGitHubBinary {
  owner = "typst";
  repo = "typst";
  file = ./release.json;
  platforms = {
    x86_64-linux = "x86_64-unknown-linux-musl";
    aarch64-linux = "aarch64-unknown-linux-musl";
    aarch64-darwin = "aarch64-apple-darwin";
  };
  getAsset = { platform, ... }: "typst-${platform}.tar.xz";
  versionPrefix = "v";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "New markup-based typesetting system that is powerful and easy to learn";
    license = lib.licenses.asl20;
  };
}
