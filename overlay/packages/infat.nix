{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "infat";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "philocalyst";
    repo = "infat";
    tag = version;
    hash = "sha256-kE1veSGqRMCXo57X6q9yy/U214Onjx9AQ2B+ibuMhmw=";
  };

  cargoHash = "sha256-jUanpi7LmBxGlcCB9aHtDfQ0jnJAIRYGjDwf5K3144w=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A command line tool to set default openers for file formats and url schemes on macos";
    homepage = "https://github.com/philocalyst/infat";
    changelog = "https://github.com/philocalyst/infat/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "infat";
    githubActionsCheck = true;
  };
}
