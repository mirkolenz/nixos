{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:
buildGoModule rec {
  pname = "gibo";
  version = "3.0.12";

  src = fetchFromGitHub {
    owner = "simonwhitaker";
    repo = "gibo";
    tag = "v${version}";
    hash = "sha256-ye6ql9NCoTdqABTPTQTIm60HSJ8Di+l9He5469ux3MI=";
  };

  vendorHash = "sha256-Z1BzqZDTDa/G7Jnsv/YStihiToTzn3i0YS7ybgD96S0=";

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

  meta = {
    description = "Easy access to gitignore boilerplates";
    homepage = "https://github.com/simonwhitaker/gibo";
    downloadPage = "https://github.com/simonwhitaker/gibo/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "gibo";
  };
}
