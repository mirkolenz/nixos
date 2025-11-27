{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-inspector";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "inspector";
    tag = finalAttrs.version;
    hash = "sha256-7sYkLmN33v7WiWA6zAkdpeJ+RKzUKaisNjizO9hcGpY=";
  };

  npmDepsHash = "sha256-bupfS/UC8CemOLUk9NfW0Z8LuZq3oKFLss+EnJS4T8E=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visual testing tool for MCP servers";
    homepage = "https://github.com/modelcontextprotocol/inspector";
    changelog = "https://github.com/modelcontextprotocol/inspector/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "mcp-inspector";
    broken = true;
  };
})
