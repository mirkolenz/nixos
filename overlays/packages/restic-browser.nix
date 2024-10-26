{
  lib,
  mkApp,
  fetchzip,
}:
mkApp rec {
  pname = "restic-browser";
  version = "0.3.1";
  appname = "Restic-Browser";
  src = fetchzip {
    url = "https://github.com/emuell/restic-browser/releases/download/v${version}/${appname}-v${version}-macOS.zip";
    hash = "sha256-7fyJUuKLS9ed6zT1kefJQNxICudFbvrVRx5Pgxw6QIY=";
    # the downloaded zip contains a tar archive instead of the app
    postFetch = ''
      tar -xf "$out/${appname}.app.tar" -C "$out"
      rm "$out/${appname}.app.tar"
    '';
  };
  meta = {
    description = "A GUI to browse and restore restic backup repositories.";
    homepage = "https://github.com/emuell/restic-browser";
    downloadPage = "https://github.com/emuell/restic-browser/releases";
    license = with lib.licenses; [ mit ];
  };
}
