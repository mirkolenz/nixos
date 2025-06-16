{
  mkApp,
  fetchzip,
  lib,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform) system;
in
mkApp rec {
  pname = "goneovim";
  version = "0.6.14";
  appname = pname;
  # prefetch-attrs .#goneovim-bin.passthru.urls --unpack

  passthru = {
    urls = {
      x86_64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-x86_64.tar.bz2";
      aarch64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-arm64.tar.bz2";
    };
    hashes = {
      aarch64-darwin = "sha256-Kp/+7AIsbRgN0czeXsKnlCrHqsavV/caYaJZ6sgGvkw=";
      x86_64-darwin = "sha256-d0kLzbLu0YQkdFQxGMlXPYfOZPUPUZS2HLMxNnW4CAc=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };
  wrapperPath = "Contents/MacOS/${pname}";

  meta = {
    description = "GUI frontend for neovim";
    homepage = "https://github.com/akiyosi/goneovim";
    downloadPage = "https://github.com/akiyosi/goneovim/releases";
    license = lib.licenses.mit;
    platforms = lib.attrNames passthru.urls;
  };
}
