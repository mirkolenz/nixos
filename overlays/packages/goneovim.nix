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
  version = "0.6.9";
  appname = pname;

  passthru = {
    urls = {
      x86_64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-x86_64.tar.bz2";
      aarch64-darwin = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-macos-arm64.tar.bz2";
    };
    hashes = {
      x86_64-darwin = "sha256-fIFoViBMwW0JRSUlVZgNwrcg1/Mb2iozD1bwm8QVz7U=";
      aarch64-darwin = "sha256-7ysz2LzAJxYnf1nAHwEu3NfPtLDyhirMCbNeLtIp0mo=";
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
