{
  lib,
  stdenvNoCC,
  versionCheckHook,
  mkGitHubBinary,
  writableTmpDirAsHomeHook,
  unzip,
  makeBinaryWrapper,
}:
let
  platforms = {
    x86_64-linux = "linux-x64.tar.gz";
    aarch64-linux = "linux-arm64.tar.gz";
    aarch64-darwin = "darwin-arm64.zip";
  };
in
mkGitHubBinary {
  owner = "anomalyco";
  repo = "opencode";
  file = ./release.json;
  inherit platforms;
  getAsset = { platform, ... }: "opencode-${platform}";
  versionRegex = "v(.+)";

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ];

  __noChroot = stdenvNoCC.isDarwin;

  # otherwise the bun runtime is executed instead of the binary (on linux)
  dontStrip = true;

  postInstall = ''
    wrapProgram $out/bin/opencode \
      --set OPENCODE_DISABLE_AUTOUPDATE 1
  '';

  # patchelf needs to run first, so we add a custom phase
  postPhases = [ "finalPhase" ];

  # only bash supported: https://github.com/anomalyco/opencode/issues/1515
  finalPhase = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd opencode \
      --bash <($out/bin/opencode completion)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Open source coding agent";
    license = lib.licenses.mit;
  };
}
