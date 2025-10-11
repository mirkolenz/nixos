{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "copilot-cli";
  version = "0.0.339";

  src = fetchzip {
    url = "https://registry.npmjs.org/@github/copilot/-/copilot-${finalAttrs.version}.tgz";
    hash = "sha256-dgdlvsFVwFRziehe9wYjtWPGOFTtT/Px+9fkRy37c0k=";
  };

  npmDepsHash = "sha256-sojOiXpbdfvKmwVslbU3LA0+DM9MuCUS5wegsH/2LrQ=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  # passthru.updateScript = writeScript "copilot-cli-update" ''
  #   #!/usr/bin/env nix-shell
  #   #!nix-shell --pure -i bash --packages nodejs nix-update cacert git

  #   set -euo pipefail

  #   version=$(npm view @github/copilot version)
  #   NIXPKGS_ALLOW_UNFREE=1 nix-update copilot-cli --version="$version" --generate-lockfile
  # '';

  meta = {
    description = "GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal";
    homepage = "https://github.com/github/copilot-cli";
    downloadPage = "https://www.npmjs.com/package/@github/copilot";
    changelog = "https://github.com/github/copilot-cli/blob/main/changelog.md";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "copilot";
    broken = true;
  };
})
