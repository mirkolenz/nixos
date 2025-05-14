{
  mkApp,
  lib,
  fetchzip,
  rcodesign,
}:
mkApp rec {
  pname = "vimr";
  version = "0.53.0";
  build = "20250430.152427";
  appname = "VimR";
  src = fetchzip {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-D/6aZc0nvvCkjgoK+Co4623wPnE+QSbA/dFPdkZLlcY=";
    stripRoot = false;
  };
  wrapperPath = "Contents/Resources/${pname}";

  nativeBuildInputs = [
    rcodesign
  ];

  preInstall = ''
    rcodesign sign ${appname}.app
  '';

  meta = {
    description = "Neovim GUI for macOS in Swift";
    homepage = "https://github.com/qvacua/vimr";
    downloadPage = "https://github.com/qvacua/vimr/releases";
    license = lib.licenses.mit;
  };
}
