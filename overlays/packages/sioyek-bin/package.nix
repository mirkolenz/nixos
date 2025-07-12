{
  mkApp,
  fetchurl,
  lib,
  stdenv,
  rcodesign,
  unzip,
}:
let
  inherit (stdenv.hostPlatform) system;
  release = lib.importJSON ./release.json;
  systemToPlatform = {
    x86_64-darwin = "mac";
    aarch64-darwin = "mac-arm";
  };
  platform = systemToPlatform.${system};
in
mkApp rec {
  pname = "sioyek";
  version = release.version or "unstable";
  appname = "sioyek";

  src = fetchurl {
    url = "https://github.com/ahrm/sioyek/releases/download/sioyek${version}/sioyek-release-${platform}.zip";
    hash = release.hashes."sioyek-release-${platform}.zip";
  };
  wrapperPath = "Contents/MacOS/${pname}";

  nativeBuildInputs = [
    rcodesign
    unzip
  ];

  preInstall = ''
    undmg ${appname}.dmg
    rcodesign sign ${appname}.app
  '';

  # TODO: enable after next release (currently digest is missing)
  # passthru.updateScript = ./update.sh;

  meta = {
    description = "PDF viewer with a focus on textbooks and research papers";
    homepage = "https://sioyek.info";
    downloadPage = "https://github.com/ahrm/sioyek/releases";
    license = lib.licenses.gpl3;
    platforms = lib.attrNames systemToPlatform;
  };
}
