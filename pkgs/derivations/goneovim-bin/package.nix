{
  lib,
  mkGitHubBinaryApp,
}:
mkGitHubBinaryApp (finalAttrs: {
  ghBin = {
    owner = "akiyosi";
    repo = "goneovim";
    file = ./release.json;
    assets = {
      aarch64-darwin = "goneovim-v{version}-macos-arm64.tar.bz2";
    };
    tagTemplate = "v{version}";
  };
  wrapperPath = "Contents/MacOS/${finalAttrs.pname}";

  meta = {
    description = "GUI frontend for neovim";
    license = lib.licenses.mit;
  };
})
