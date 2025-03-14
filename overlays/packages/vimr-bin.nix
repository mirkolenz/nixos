{
  mkApp,
  lib,
  fetchzip,
  rcodesign,
}:
mkApp rec {
  pname = "vimr";
  version = "0.51.1";
  build = "20250215.143933";
  appname = "VimR";
  src = fetchzip {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-zzf1jIzhmD9LTrRspjVKlJp7ExM6NkseC3I8hH6LfXY=";
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
