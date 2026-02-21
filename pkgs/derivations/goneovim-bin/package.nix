{
  lib,
  mkGitHubBinaryApp,
}:
mkGitHubBinaryApp (finalAttrs: {
  ghBin = {
    owner = "akiyosi";
    repo = "goneovim";
    file = ./release.json;
    platforms = {
      aarch64-darwin = "macos-arm64";
    };
    getAsset = { platform, version, ... }: "goneovim-v${version}-${platform}.tar.bz2";
    versionRegex = "v(.+)";
  };
  wrapperPath = "Contents/MacOS/${finalAttrs.pname}";

  meta = {
    description = "GUI frontend for neovim";
    license = lib.licenses.mit;
  };
})
