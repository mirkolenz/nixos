{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
  stdenv,
  installShellFiles,
}:

buildGo125Module (finalAttrs: {
  pname = "crush";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ZrHki/k6TJZxb2ShrevzHZb1r8Q3EnEQejyaOCyLD4=";
  };

  vendorHash = "sha256-/9Sl5xQqqWsvd1FUn5FfC9D5WR/qF02xLJEuVGVbVV0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd crush \
      --bash <($out/bin/crush completion bash) \
      --fish <($out/bin/crush completion fish) \
      --zsh <($out/bin/crush completion zsh)
  '';

  # writes to home during check phase
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "crush";
    githubActionsCheck = true;
  };
})
