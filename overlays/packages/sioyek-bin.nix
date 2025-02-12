{
  mkApp,
  fetchzip,
  lib,
  stdenv,
  rcodesign,
}:
let
  inherit (stdenv.hostPlatform) system;
in
mkApp rec {
  pname = "sioyek";
  version = "3-alpha0";
  appname = "sioyek";

  passthru = {
    urls = {
      aarch64-darwin = "https://github.com/ahrm/sioyek/releases/download/sioyek${version}/${appname}-release-mac-arm.zip";
      x86_64-darwin = "https://github.com/ahrm/sioyek/releases/download/sioyek${version}/${appname}-release-mac.zip";
    };
    hashes = {
      aarch64-darwin = "sha256-UsjGHj0OAuuMnX93jzvdMYmz1ZdVuU2jGN80ATvccTI=";
      x86_64-darwin = "sha256-vouYHiqaXAM99WXxkoP/Qz6nQcRa8IOOuGc2f0vhboo=";
    };
  };

  src = fetchzip {
    url = passthru.urls.${system};
    hash = passthru.hashes.${system};
    # the downloaded zip contains a dmg instead of the app
    # postFetch = ''
    #   cd "$out"
    #   ${lib.getExe undmg} "${appname}.dmg"
    #   rm "${appname}.dmg"
    # '';
  };
  wrapperPath = "Contents/MacOS/${pname}";

  nativeBuildInputs = [
    rcodesign
  ];

  preInstall = ''
    undmg ${appname}.dmg
    rcodesign sign ${appname}.app
  '';

  meta = with lib; {
    description = "PDF viewer with a focus on textbooks and research papers";
    homepage = "https://sioyek.info";
    downloadPage = "https://github.com/ahrm/sioyek/releases";
    license = licenses.gpl3;
    platforms = attrNames passthru.urls;
  };
}
