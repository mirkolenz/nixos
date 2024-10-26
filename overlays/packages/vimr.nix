{
  mkApp,
  lib,
  fetchzip,
}:
mkApp rec {
  pname = "vimr";
  version = "0.49.0";
  build = "20241006.202133";
  appname = "VimR";
  src = fetchzip {
    url = "https://github.com/qvacua/vimr/releases/download/v${version}-${build}/${appname}-v${version}.tar.bz2";
    hash = "sha256-aQjyENqRPBhgk6cPQCvhjl8hRWjmsJ++zhDgv7ot5o8=";
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
