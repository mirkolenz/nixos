{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-inspector";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9UiBNYieI7ne56qEbERcQGgzGmuLuW5MWOFI3mIwkW8=";
  };

  npmDepsHash = "sha256-JuIYVXbyCNPUdaPJkmuCs7C682ibiGurJ+bxjTqp5dY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    changelog = "https://github.com/google-gemini/gemini-cli/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "gemini";
    broken = true;
  };
})
