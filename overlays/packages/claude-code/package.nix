{
  lib,
  buildNpmPackage,
  fetchzip,
  writeShellApplication,
  importNpmLock,
  nodejs,
  runCommandNoCCLocal,
  nix-update,
}:
let
  version = "1.0.10";
  upstreamSource = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-DcHlxeOOIKDe/Due952rH5qGT3KX+lUx84ctuj2/3aw=";
  };
  vendoredSource = runCommandNoCCLocal "claude-code-vendored-source" { } ''
    cp -r --no-preserve=all ${upstreamSource} $out
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
buildNpmPackage {
  pname = "claude-code";
  inherit version;
  # nix run .#claude-code.updateScript

  src = vendoredSource;

  npmDeps = importNpmLock { npmRoot = vendoredSource; };
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
      npm install --prefix "$workdir" --ignore-scripts --package-lock-only "@anthropic-ai/claude-code@$version"
      rm -f "$workdir/package.json"
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
