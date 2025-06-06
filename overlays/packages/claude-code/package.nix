{
  lib,
  buildNpmPackage,
  fetchzip,
  writeShellApplication,
  importNpmLock,
  nodejs,
  nix-update,
}:
buildNpmPackage rec {
  pname = "claude-code";
  version = "1.0.16";
  # nix run .#claude-code.updateScript

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-WK6EnwciMGh5vo6EB35zbEjSS3ahYeY5lwEUk2a6f9o=";
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
    ];
    text = ''
      version="$(npm view @anthropic-ai/claude-code version)"
      workdir="overlays/packages/claude-code"
      npm update --prefix "$workdir" --ignore-scripts --package-lock-only
      nix-update --flake claude-code --version "$version"
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
