{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-inspector";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "inspector";
    tag = finalAttrs.version;
    hash = "sha256-4A3G51NJOYHK/WVpJR5gE7ZiRxU37vs3eIf1dmsxSF0=";
  };

  npmDepsHash = "sha256-zCHs3lom+k9oH2F2SC4jNqw3HZ/qv8Lbn0hNQRD5+Tg=";

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
