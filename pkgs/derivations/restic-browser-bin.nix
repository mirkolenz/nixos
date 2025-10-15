{
  lib,
  mkApp,
  fetchzip,
  nix-update-script,
}:
mkApp rec {
  pname = "restic-browser";
  version = "0.3.3";
  appname = "Restic-Browser";

  src = fetchzip {
    url = "https://github.com/emuell/restic-browser/releases/download/v${version}/${appname}-v${version}-macOS.zip";
    hash = "sha256-aLrZ/doMwd5xZ6ITtzTlrS4oPtGzgzqyryjRAdRBqZM=";
    # the downloaded zip contains a tar archive instead of the app
    postFetch = ''
      tar -xf "$out/${appname}.app.tar" -C "$out"
      rm "$out/${appname}.app.tar"
    '';
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A GUI to browse and restore restic backup repositories.";
    homepage = "https://github.com/emuell/restic-browser";
    downloadPage = "https://github.com/emuell/restic-browser/releases";
    license = lib.licenses.mit;
  };
}
