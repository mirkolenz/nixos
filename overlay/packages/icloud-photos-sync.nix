{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "icloud-photos-sync";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "steilerDev";
    repo = "icloud-photos-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JnmFO6Qj8/3Sws73kzvAvGQOBsQWQWb2w93tBvEKODY=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  npmDepsHash = "sha256-HQ9AnPS+LzU1lzW8SNJif3uVm8W0ClH1zWZDSR/CH94=";

  # https://github.com/steilerDev/icloud-photos-sync/blob/main/app/package.json
  # generate bin directory
  postBuild = ''
    npm run dist
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "One-way sync engine for the iCloud Photos Library into the native file system";
    homepage = "https://github.com/steilerDev/icloud-photos-sync";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "icloud-photos-sync";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
