{
  lib,
  versionCheckHook,
  mkGitHubBinary,
}:
let
  platforms = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    x86_64-darwin = "darwin_amd64";
    aarch64-darwin = "darwin_arm64";
  };
in
mkGitHubBinary {
  owner = "brutella";
  repo = "hkknx-public";
  pname = "hkknx";
  getAsset = { system, version }: "hkknx-${version}_${platforms.${system}}.tar.gz";
  file = ./release.json;
  pattern = ''^hkknx-\($release.tag_name)_(darwin|linux)_(amd64|arm64)\\.tar\\.gz$'';

  sourceRoot = ".";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "HomeKit Bridge for KNX";
    homepage = "https://hochgatterer.me/hkknx";
    downloadPage = "https://github.com/brutella/hkknx-public/releases";
    mainProgram = "hkknx";
    platforms = lib.attrNames platforms;
    license = lib.licenses.unfree;
  };
}
