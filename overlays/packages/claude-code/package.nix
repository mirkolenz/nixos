{
  lib,
  buildNpmPackage,
  fetchzip,
  writeShellApplication,
  importNpmLock,
  nodejs,
  nix-update,
  jq,
  makeWrapper,
}:
buildNpmPackage rec {
  pname = "claude-code";
  version = "1.0.22";
  # nix run .#claude-code.updateScript

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-Gn+AzZysuYsZDMzcXlzDMWSWeJS3L7itvlGJq4kYha0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1
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
    changelog = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mirkolenz ];
    mainProgram = "claude";
  };
}
