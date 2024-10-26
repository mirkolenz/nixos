{
  mkApp,
  fetchzip,
  lib,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform) system;
  platforms = {
    x86_64-darwin = "macos-x86_64";
    aarch64-darwin = "macos-arm64";
  };
  platform = platforms.${system};
in
mkApp rec {
  pname = "goneovim";
  version = "0.6.9";
  appname = pname;
  src = fetchzip {
    url = "https://github.com/akiyosi/goneovim/releases/download/v${version}/${pname}-v${version}-${platform}.tar.bz2";
    hash = "sha256-fIFoViBMwW0JRSUlVZgNwrcg1/Mb2iozD1bwm8QVz7U=";
  };
  wrapperPath = "Contents/MacOS/${pname}";
  meta = with lib; {
    description = "GUI frontend for neovim";
    homepage = "https://github.com/akiyosi/goneovim";
    downloadPage = "https://github.com/akiyosi/goneovim/releases";
    license = licenses.mit;
  };
}
