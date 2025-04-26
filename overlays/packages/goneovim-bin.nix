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
  version = "0.6.13";
  appname = pname;

  passthru = {
    urls = {
      x86_64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-x86_64.tar.bz2";
      aarch64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-arm64.tar.bz2";
    };
    hashes = {
      aarch64-darwin = "sha256-iLy3A0MgPCsKsc8sapMz5P2BkNw+d2cXTg7EKhWWybI=";
      x86_64-darwin = "sha256-uuzYtsEDhIdhl6Mco5aQPbtSo9uaB0XQjmoq0CmFpIU=";
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
