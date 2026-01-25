{
  lib,
  mkGitHubBinaryApp,
  unzip,
  undmg,
  darwin,
}:
let
  platforms = {
    aarch64-darwin = "mac-arm";
  };
in
mkGitHubBinaryApp (finalAttrs: {
  ghBin = {
    owner = "ahrm";
    repo = "sioyek";
    file = ./release.json;
    getAsset = { system, ... }: "sioyek-release-${platforms.${system}}.zip";
    versionPrefix = "sioyek";
    pattern = ''^sioyek-release-mac-arm\\.zip$'';
    allowPrereleases = true;
  };

  wrapperPath = "Contents/MacOS/${finalAttrs.pname}";

  # TODO: enable after next release (currently digest is missing)
  passthru.updateScript = null;

  nativeBuildInputs = [
    unzip
    undmg
    darwin.autoSignDarwinBinariesHook
  ];

  preInstall = ''
    undmg ${finalAttrs.pname}.dmg
  '';

  meta = {
    description = "PDF viewer with a focus on textbooks and research papers";
    license = lib.licenses.gpl3;
    platforms = lib.attrNames platforms;
  };
})
