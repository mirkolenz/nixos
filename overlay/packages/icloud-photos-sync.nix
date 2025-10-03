{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "icloud-photos-sync";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "steilerDev";
    repo = "icloud-photos-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-435K6YJMIlVou3p+d5ynyUNg1Wmo/+auXveFiGbWL4c=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  npmDepsHash = "sha256-1dxmiONBahaN7mzFBVToO395QoFiFqLMBJKzu++JtPs=";

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
    broken = true;
  };
})
