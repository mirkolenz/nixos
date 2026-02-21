{
  lib,
  mkGitHubBinaryApp,
}:
mkGitHubBinaryApp (finalAttrs: {
  ghBin = {
    owner = "akiyosi";
    repo = "goneovim";
    file = ./release.json;
    assets = version: {
      aarch64-darwin = "goneovim-v${version}-macos-arm64.tar.bz2";
    };
    versionPrefix = "v";
  };
  wrapperPath = "Contents/MacOS/${finalAttrs.pname}";

  meta = {
    description = "GUI frontend for neovim";
    license = lib.licenses.mit;
  };
})
