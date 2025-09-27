{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "infat";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "philocalyst";
    repo = "infat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o8Ga9Wd5wIIjtA/dse7aUCHw2cYgwvUKVzi0PaDNQGw=";
  };

  cargoHash = "sha256-NhW69VXP6UCRXnDd1DA4lJjPwykVzRzeV38MnLbuimo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A command line tool to set default openers for file formats and url schemes on macos";
    homepage = "https://github.com/philocalyst/infat";
    changelog = "https://github.com/philocalyst/infat/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "infat";
    githubActionsCheck = true;
  };
})
