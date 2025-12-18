{
  lib,
  mkGitHubBinaryApp,
}:
let
  platforms = {
    aarch64-darwin = "macos-arm64";
  };
in
mkGitHubBinaryApp (finalAttrs: {
  ghBin = {
    owner = "akiyosi";
    repo = "goneovim";
    file = ./release.json;
    getAsset = { system, version }: "goneovim-v${version}-${platforms.${system}}.tar.bz2";
    versionPrefix = "v";
    pattern = ''^goneovim-\($release.tag_name)-macos-arm64\\.tar\\.bz2$'';
  };
  wrapperPath = "Contents/MacOS/${finalAttrs.pname}";

  meta = {
    description = "GUI frontend for neovim";
    license = lib.licenses.mit;
    platforms = lib.attrNames platforms;
  };
})
