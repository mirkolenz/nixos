{
  lib,
  mkGitHubBinaryApp,
  unzip,
  undmg,
  darwin,
}:
mkGitHubBinaryApp (finalAttrs: {
  ghBin = {
    owner = "ahrm";
    repo = "sioyek";
    file = ./release.json;
    platforms = {
      aarch64-darwin = "mac-arm";
    };
    getAsset = { platform, ... }: "sioyek-release-${platform}.zip";
    versionRegex = "sioyek(.+)";
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
  };
})
