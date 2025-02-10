{
  mkApp,
  lib,
  fetchzip,
}:
mkApp rec {
  pname = "vimr";
  version = "0.51.0";
  build = "20250129.234141";
  appname = "VimR";
  src = fetchzip {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-xCTMi46kQrQGuzEM7+I0R2los0YWA02mm3RB94jIYb4=";
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
