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
  version = "0.6.11";
  appname = pname;

  passthru = {
    urls = {
      x86_64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-x86_64.tar.bz2";
      aarch64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-arm64.tar.bz2";
    };
    hashes = {
      aarch64-darwin = "sha256-c/mIFxCaknoQTl9YWhnaBghX6zRmV7WhXq3td//9OKc=";
      x86_64-darwin = "sha256-laKJ8dVyqYmOe88IWNugb73llbMM7AmBytHrlQFT2Ms=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
  };
  wrapperPath = "Contents/MacOS/${pname}";

  meta = with lib; {
    description = "GUI frontend for neovim";
    homepage = "https://github.com/akiyosi/goneovim";
    downloadPage = "https://github.com/akiyosi/goneovim/releases";
    license = licenses.mit;
    platforms = attrNames passthru.urls;
  };
}
