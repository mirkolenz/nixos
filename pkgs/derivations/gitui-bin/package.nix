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
  platforms = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    aarch64-darwin = "mac";
  };
  getAsset = { platform, ... }: "gitui-${platform}.tar.gz";
  versionRegex = "v(.+)";

  sourceRoot = ".";

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ stdenv.cc.cc ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Blazing fast terminal-ui for git written in rust";
    license = lib.licenses.mit;
  };
}
