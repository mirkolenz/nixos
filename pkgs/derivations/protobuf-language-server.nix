{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "protobuf-language-server";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lasorda";
    repo = "protobuf-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xaWcQMoahOVm6pAP8Y01fkSOuvuwS+aRFEb5ztbL3pk=";
  };

  vendorHash = "sha256-4nTpKBe7ekJsfQf+P6edT/9Vp2SBYbKz1ITawD3bhkI=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  strictDeps = true;

  meta = {
    description = "A language server implementation for Google Protocol Buffers";
    homepage = "https://github.com/lasorda/protobuf-language-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mirkolenz ];
    mainProgram = "protobuf-language-server";
  };
})
