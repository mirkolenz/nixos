{
  mkApp,
  lib,
  fetchzip,
}:
mkApp rec {
  pname = "vimr";
  version = "0.50.0";
  build = "20241224.155723";
  appname = "VimR";
  src = fetchzip {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-ErTi2DXNT/QBazwOb4Y7Ltmd2x9qY9qLZeXIapz9tyI=";
    stripRoot = false;
  };
  wrapperPath = "Contents/Resources/${pname}";
  meta = with lib; {
    description = "Neovim GUI for macOS in Swift";
    homepage = "https://github.com/qvacua/vimr";
    downloadPage = "https://github.com/qvacua/vimr/releases";
    license = licenses.mit;
  };
}
