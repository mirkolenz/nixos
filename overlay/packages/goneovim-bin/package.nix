{
  mkApp,
  fetchurl,
  lib,
  stdenv,
  binariesFromGitHub,
}:
let
  inherit (stdenv.hostPlatform) system;
  release = lib.importJSON ./release.json;
  systemToPlatform = {
    x86_64-darwin = "macos-x86_64";
    aarch64-darwin = "macos-arm64";
  };
  platform = systemToPlatform.${system};
in
mkApp rec {
  pname = "goneovim";
  version = release.version or "unstable";
  appname = pname;

  src = fetchurl {
    url = "https://github.com/akiyosi/goneovim/releases/download/v${version}/goneovim-v${version}-${platform}.tar.bz2";
    hash = release.hashes.${platform};
  };
  wrapperPath = "Contents/MacOS/${pname}";

  passthru.updateScript = binariesFromGitHub {
    owner = "akiyosi";
    repo = "goneovim";
    outputFile = ./release.json;
    versionPrefix = "v";
    assetsPattern = ''^goneovim-\($release.tag_name)-(?<platform>macos-(arm64|x86_64))\\.tar\\.bz2$'';
    assetsReplace = "\\(.platform)";
  };

  meta = {
    description = "GUI frontend for neovim";
    homepage = "https://github.com/akiyosi/goneovim";
    downloadPage = "https://github.com/akiyosi/goneovim/releases";
    license = lib.licenses.mit;
    platforms = lib.attrNames systemToPlatform;
  };
}
