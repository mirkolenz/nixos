{
  lib,
  mkApp,
  fetchzip,
}:
mkApp rec {
  pname = "restic-browser";
  version = "0.3.2";
  appname = "Restic-Browser";
  src = fetchzip {
    url = "https://github.com/emuell/restic-browser/releases/download/v${version}/${appname}-v${version}-macOS.zip";
    hash = "sha256-3uPmdJZmUPfQjVCuf5h9Wa/rzezJqgfqsDz0vdcf5AM=";
    # the downloaded zip contains a tar archive instead of the app
    postFetch = ''
      tar -xf "$out/${appname}.app.tar" -C "$out"
      rm "$out/${appname}.app.tar"
    '';
  };
  meta = with lib; {
    description = "A GUI to browse and restore restic backup repositories.";
    homepage = "https://github.com/emuell/restic-browser";
    downloadPage = "https://github.com/emuell/restic-browser/releases";
    license = licenses.mit;
  };
}
