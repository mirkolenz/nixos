{
  mkApp,
  lib,
  mkGitHubBinary,
}:
let
  platforms = {
    x86_64-darwin = "macos-x86_64";
    aarch64-darwin = "macos-arm64";
  };
  ghBin = mkGitHubBinary {
    owner = "akiyosi";
    repo = "goneovim";
    file = ./release.json;
    getAsset = { system, version }: "goneovim-v${version}-${platforms.${system}}.tar.bz2";
    versionPrefix = "v";
    pattern = ''^goneovim-\($release.tag_name)-(?<platform>macos-(arm64|x86_64))\\.tar\\.bz2$'';
  };
in
mkApp rec {
  inherit (ghBin)
    pname
    version
    src
    passthru
    ;
  appname = pname;
  wrapperPath = "Contents/MacOS/${pname}";

  meta = ghBin.meta // {
    description = "GUI frontend for neovim";
    homepage = "https://github.com/akiyosi/goneovim";
    downloadPage = "https://github.com/akiyosi/goneovim/releases";
    license = lib.licenses.mit;
    platforms = lib.attrNames platforms;
    githubActionsCheck = true;
  };
}
