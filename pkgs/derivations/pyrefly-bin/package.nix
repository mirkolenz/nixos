{
  lib,
  stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
mkGitHubBinary {
  owner = "facebook";
  repo = "pyrefly";
  file = ./release.json;
  platforms = {
    x86_64-linux = "linux-x86_64";
    aarch64-darwin = "macos-arm64";
  };
  getAsset = { platform, ... }: "pyrefly-${platform}.tar.gz";

  buildInputs = [ stdenv.cc.cc ];

  sourceRoot = ".";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fast type checker and language server for Python";
    license = lib.licenses.mit;
  };
}
