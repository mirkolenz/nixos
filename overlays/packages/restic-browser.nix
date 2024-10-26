{
  lib,
  mkApp,
  fetchzip,
}:
mkApp rec {
  pname = "restic-browser";
  version = "0.3.1";
  appname = "Restic-Browser";
  sourceRoot = "${appname}.app";
  src = fetchzip {
    url = "https://github.com/emuell/restic-browser/releases/download/v${version}/${appname}-v${version}-macOS.zip";
    hash = "sha256-KYxf+dtpmenJLc7/9QeB8Q5d6+jdqVqjRIGfLc+KUiY=";
  };
  unpackCmd = ''
    tar -xf "$curSrc/${appname}.app.tar" -C .
  '';
  meta = {
    description = "A GUI to browse and restore restic backup repositories.";
    homepage = "https://github.com/emuell/restic-browser";
    downloadPage = "https://github.com/emuell/restic-browser/releases";
    license = with lib.licenses; [ mit ];
  };
}
