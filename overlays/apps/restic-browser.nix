{
  lib,
  mkApp,
  fetchzip,
}:
mkApp rec {
  pname = "restic-browser";
  version = "0.3.0";
  appname = "Restic-Browser";
  src = fetchzip {
    url = "https://github.com/emuell/restic-browser/releases/download/v${version}/${appname}-v${version}-macOS.zip";
    hash = "sha256-sOHwE6actnB2P5G+KBM4oVnaOcq+ibWFepI7zVqt6uI=";
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
