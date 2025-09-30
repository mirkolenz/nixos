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
  releaseFile = ./release.json;
  releaseContents = lib.importJSON releaseFile;
  platforms = {
    x86_64-darwin = "mac";
    aarch64-darwin = "mac-arm";
  };
  platform = platforms.${system};
  assetName = "sioyek-release-${platform}.zip";
in
mkApp rec {
  pname = "sioyek";
  version = releaseContents.version or "unstable";
  appname = "sioyek";

  src = fetchurl {
    url = "https://github.com/ahrm/sioyek/releases/download/sioyek${version}/${assetName}";
    hash = releaseContents.hashes.${assetName} or lib.fakeHash;
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
  # passthru.updateScript = binariesFromGitHub {
  #   owner = "ahrm";
  #   repo = "sioyek";
  #   file = ./release.json;
  #   assetsPattern = ''^sioyek-release-mac.*?\\.zip$'';
  #   versionPrefix = "sioyek";
  #   allowPrereleases = true;
  # };

  meta = {
    description = "PDF viewer with a focus on textbooks and research papers";
    homepage = "https://sioyek.info";
    downloadPage = "https://github.com/ahrm/sioyek/releases";
    license = lib.licenses.gpl3;
    platforms = lib.attrNames platforms;
    githubActionsCheck = true;
  };
}
