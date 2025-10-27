{
  lib,
  stdenv,
  versionCheckHook,
  mkGitHubBinary,
}:
let
  platforms = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    x86_64-darwin = "mac-x86";
    aarch64-darwin = "mac";
  };
in
mkGitHubBinary {
  owner = "gitui-org";
  repo = "gitui";
  file = ./release.json;
  getAsset = { system, ... }: "gitui-${platforms.${system}}.tar.gz";
  pattern = ''^gitui-(linux-aarch64|linux-x86_64|mac-x86|mac)\\.tar\\.gz$'';
  versionPrefix = "v";

  sourceRoot = ".";

  buildInputs = lib.optional (!stdenv.isDarwin) stdenv.cc.cc;

  # TODO: enable after next release (currently digest is missing)
  passthru.updateScript = null;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Blazing fast terminal-ui for git written in rust";
    platforms = lib.attrNames platforms;
    license = lib.licenses.mit;
  };
}
