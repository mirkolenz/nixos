{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "gibo";
  version = "3.0.20";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u2e0YwtK3MnzIYvXNVc2a4zsoxISAcS3U+6WpgBsYUM=";
  };

  vendorHash = "sha256-YVs6S3x0u2dypb5h+pNCUkmfVK+0erzoGZzONipL49o=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X=github.com/simonwhitaker/gibo/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gibo \
      --bash <($out/bin/gibo completion bash) \
      --fish <($out/bin/gibo completion fish) \
      --zsh <($out/bin/gibo completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Easy access to gitignore boilerplates";
    homepage = "https://github.com/simonwhitaker/gibo";
    downloadPage = "https://github.com/simonwhitaker/gibo/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "gibo";
  };
})
