{
  mkApp,
  lib,
  mkGitHubBinary,
  rcodesign,
  unzip,
}:
let
  platforms = {
    x86_64-darwin = "mac";
    aarch64-darwin = "mac-arm";
  };
  ghBin = mkGitHubBinary {
    owner = "ahrm";
    repo = "sioyek";
    file = ./release.json;
    getAsset = { system, ... }: "sioyek-release-${platforms.${system}}.zip";
    versionPrefix = "sioyek";
    pattern = ''^sioyek-release-mac.*?\\.zip$'';
    allowPrereleases = true;
  };
in
mkApp rec {
  inherit (ghBin)
    pname
    version
    src
    # passthru # TODO: enable after next release (currently digest is missing)
    ;
  appname = "sioyek";

  wrapperPath = "Contents/MacOS/${pname}";

  nativeBuildInputs = [
    rcodesign
    unzip
  ];

  preInstall = ''
    undmg ${appname}.dmg
    rcodesign sign ${appname}.app
  '';

  meta = {
    description = "PDF viewer with a focus on textbooks and research papers";
    license = lib.licenses.gpl3;
    platforms = lib.attrNames platforms;
  };
}
