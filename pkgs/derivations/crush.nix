{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "crush";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wLa+4FY2p4NcRyATW3b69ANHuN/Td1qIenRg9W0h4a0=";
  };

  vendorHash = "sha256-sV5Whc6K9D7TX3V0ZxaIx0IM7qOinh4IZq0N+rHnUbw=";

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

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
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
  };
})
