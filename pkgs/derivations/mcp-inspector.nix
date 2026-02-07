{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-inspector";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "inspector";
    tag = finalAttrs.version;
    hash = "sha256-J9L8Ug3Qcgzw2XpYQfEKrEf2CTQCIKB/F9Tcls59BdY=";
  };

  npmDepsHash = "sha256-jWIRD6CkP5YPrK9umMOHdVpm0bv6qyUTxJ0oUffYp1Q=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

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
