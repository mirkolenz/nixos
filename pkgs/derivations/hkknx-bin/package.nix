{
  lib,
  versionCheckHook,
  mkGitHubBinary,
}:
mkGitHubBinary {
  owner = "brutella";
  repo = "hkknx-public";
  pname = "hkknx";
  file = ./release.json;
  platforms = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    aarch64-darwin = "darwin_arm64";
  };
  getAsset = { platform, version, ... }: "hkknx-${version}_${platform}.tar.gz";

  sourceRoot = ".";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "HomeKit Bridge for KNX";
    license = lib.licenses.unfree;
  };
}
