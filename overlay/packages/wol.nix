{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  installShellFiles,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "wol";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Trugamr";
    repo = "wol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kiV7DDGmVwJQzGMmvZHmmyz9IUfflbIrvxkIT5bY0Lw=";
  };

  vendorHash = "sha256-DRA9PPNohzUtrIzucVIke5FhGvvA6zRuJzHt0qfB7PA=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trugamr/wol/cmd.version=${finalAttrs.version}"
    "-X=github.com/trugamr/wol/cmd.commit=${finalAttrs.src.rev}"
    "-X=github.com/trugamr/wol/cmd.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd wol \
      --bash <($out/bin/wol completion bash) \
      --fish <($out/bin/wol completion fish) \
      --zsh <($out/bin/wol completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Wake up your devices with a single command or click, a Wake-On-LAN tool that works via CLI and web interface";
    homepage = "https://github.com/Trugamr/wol";
    downloadPage = "https://github.com/Trugamr/wol/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "wol";
  };
})
