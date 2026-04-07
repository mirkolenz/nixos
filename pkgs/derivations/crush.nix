{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
  stdenv,
  installShellFiles,
}:
buildGo126Module (finalAttrs: {
  pname = "crush";
  version = "0.55.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UU195lYX+ncWF5hXvAp8t5R6LdgG4oXCoyegivcD9oU=";
  };

  vendorHash = "sha256-leQHNLt3WebIvV/2nY+Lo+SVOV2SQ8EL9Mopu4lro9s=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd crush \
      --bash <($out/bin/crush completion bash) \
      --fish <($out/bin/crush completion fish) \
      --zsh <($out/bin/crush completion zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = {
    description = "The glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "crush";
    hydraPlatforms = [ ];
  };
})
