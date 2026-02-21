{
  lib,
  stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
mkGitHubBinary {
  owner = "gitui-org";
  repo = "gitui";
  file = ./release.json;
  assets = {
    x86_64-linux = "gitui-linux-x86_64.tar.gz";
    aarch64-linux = "gitui-linux-aarch64.tar.gz";
    aarch64-darwin = "gitui-mac.tar.gz";
  };
  tagTemplate = "v{version}";

  sourceRoot = ".";

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ stdenv.cc.cc ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Blazing fast terminal-ui for git written in rust";
    license = lib.licenses.mit;
  };
}
