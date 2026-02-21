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
    assets = {
      aarch64-darwin = "sioyek-release-mac-arm.zip";
    };
    versionPrefix = "sioyek";
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
