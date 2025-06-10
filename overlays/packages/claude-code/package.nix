{
  lib,
  buildNpmPackage,
  fetchzip,
  writeShellApplication,
  importNpmLock,
  nodejs,
  nix-update,
  jq,
}:
buildNpmPackage rec {
  pname = "claude-code";
  version = "1.0.18";
  # nix run .#claude-code.updateScript

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-xFQEdx29Kpqu/iQsfIneq6+YHgwrniHZb8vS4auA3/I=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDeps = importNpmLock { npmRoot = ./.; };
  inherit (importNpmLock) npmConfigHook;

  dontNpmBuild = true;

  # if (!process.env.AUTHORIZED)
  # Direct publishing is not allowed.
  # Please use the publish-external.sh script to publish this package.
  AUTHORIZED = "1";

  passthru.updateScript = writeShellApplication {
    name = "claude-code-update";
    runtimeInputs = [
      nodejs
      nix-update
      jq
    ];
    runtimeEnv = {
      PREFIX = "overlays/packages/claude-code";
    };
    text = ''
      npm update \
        --prefix "$PREFIX" \
        --ignore-scripts \
        --package-lock-only
      nix-update \
        --flake \
        --version "$(jq -r '.packages."node_modules/@anthropic-ai/claude-code".version' "$PREFIX/package-lock.json")" \
        claude-code
    '';
  };

  meta = {
    description = "An agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mirkolenz ];
    mainProgram = "claude";
  };
}
