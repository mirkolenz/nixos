{
  mkApp,
  lib,
  mkGitHubBinary,
}:
let
  platforms = {
    aarch64-darwin = "macos-arm64";
  };
  ghBin = mkGitHubBinary {
    owner = "akiyosi";
    repo = "goneovim";
    file = ./release.json;
    getAsset = { system, version }: "goneovim-v${version}-${platforms.${system}}.tar.bz2";
    versionPrefix = "v";
    pattern = ''^goneovim-\($release.tag_name)-macos-arm64\\.tar\\.bz2$'';
  };
in
mkApp (finalAttrs: {
  inherit (ghBin)
    pname
    version
    src
    passthru
    ;
  wrapperPath = "Contents/MacOS/${finalAttrs.pname}";

  meta = ghBin.meta // {
    description = "GUI frontend for neovim";
    license = lib.licenses.mit;
    platforms = lib.attrNames platforms;
  };
})
