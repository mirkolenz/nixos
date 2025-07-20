{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  nix-update-script,
}:
buildGoModule rec {
  pname = "gibo";
  version = "3.0.14";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    tag = "v${version}";
    hash = "sha256-6w+qhwOHkfKt0hgKO98L6Si0RNJN+CXOOFzGlvxFjcA=";
  };

  vendorHash = "sha256-pD+7yvBydg1+BQFP0G8rRYTCO//Wg/6pzY19DLs42Gk=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/simonwhitaker/gibo/cmd.version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd gibo \
        --bash <(${emulator} $out/bin/gibo completion bash) \
        --fish <(${emulator} $out/bin/gibo completion fish) \
        --zsh <(${emulator} $out/bin/gibo completion zsh)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy access to gitignore boilerplates";
    homepage = "https://github.com/simonwhitaker/gibo";
    downloadPage = "https://github.com/simonwhitaker/gibo/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "gibo";
  };
}
